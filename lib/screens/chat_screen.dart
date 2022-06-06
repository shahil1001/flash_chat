import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller=TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late String message;
  late final User loggedInUser;


  @override
  void initState() {
    super.initState();
    getCurrentUSer();
  }

  void getCurrentUSer() async {
    final currentUser = await _auth.currentUser!;
    loggedInUser = currentUser;
    if (currentUser != null) {
      loggedInUser = currentUser;
      // print(loggedInUser);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection("messages").get(); //getDocs() in old verson
  //   //messages.docs is reffered to each keyvalue in Firestoredatabase
  //   for (var msg in messages.docs) {
  //    // print(msg.data());
  //   }
  // }

  void getMessageStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      // it trigers the activit
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //Implement logout functionality
                getMessageStream(); // it is once calling the function then will call itself autometically !
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').orderBy('timestamp',descending: false).snapshots(),
                builder: (context, snapshot) {
                  List<Widget> messagesWidget = [];
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    // do somthing

                    final messages = snapshot.data?.docs.reversed;
                    // it will chech the null system

                    for (var msg in messages!) {
                      bool temp;
                      final message = msg.get("text");
                      final messagSender = msg.get("sender");
                      final time=msg.get('timestamp');
                      final currentUser = loggedInUser.email;
                      if (currentUser == messagSender) {
                        temp = true;
                      } else {
                        temp = false;
                      }
                      final messageWidget =
                          MessagesBubble(message, messagSender, temp,time);
                      // Text("$message by $messagSender" )
                      messagesWidget.add(messageWidget);

                      // final messageWidget=Text("$message by $messagSender" );

                    }
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messagesWidget,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },

                    ),
                  ),
                  TextButton(
                    onPressed: () async{
                        controller.clear();

                      _firestore
                          .collection("messages")
                          .add({'text': message, 'sender': loggedInUser.email,
                        'timestamp': Timestamp.now(),

                          });
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesBubble extends StatelessWidget {
  String Meessage, sendby;
  bool Isme;
Timestamp time;
  MessagesBubble(this.Meessage, this.sendby, this.Isme,this.time);
  final f = new DateFormat( 'h:mm a');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            Isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          Text(
            "  $sendby",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Material(
            borderRadius: Isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 16,
            color: Isme ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                '$Meessage',
                style: GoogleFonts.lato(
                    fontSize: 18, color: Isme ? Colors.white : Colors.black),
              ),

            ),
          ),
          Text(
            "  ${f.format(time.toDate())}",
            style: GoogleFonts.lato(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
