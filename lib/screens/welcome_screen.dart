import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

import '../ReusableWidgets/MyButtons.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

late AnimationController animationController;
late Animation animation;

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    //
    // "this" is acting as ticker
    animation = CurvedAnimation(
        parent: animationController, curve: Curves.decelerate); //
    // decause the default value ranges b/w 0-1
    //

    animationController.forward();
    animationController.addListener(() {
      // use to listen everysingal tick
      setState(() {});
    });

    animation.addStatusListener((status) {

    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                      child: Image.asset('images/logo.png'),
                      height:100),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          backgroundColor: Colors.white),
                    ),
                  ],
                  onTap: () {},
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            MyButtons( LoginScreen.id, Colors.blueAccent,"Login"),
            MyButtons( RegistrationScreen.id, Colors.blueAccent,"Register"),
          ],
        ),
      ),
    );
  }
}


