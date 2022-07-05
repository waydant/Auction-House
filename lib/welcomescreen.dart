import 'package:auctioneer/login screen.dart';
import 'package:auctioneer/registeration screen.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auctioneer/Components/roundedbuttons.dart';
import 'package:auctioneer/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcomescreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();
    // controller = AnimationController(
    //   duration: Duration(seconds: 10),
    //   vsync: this,
    // );
    // animation = ColorTween(begin: Colors.blueGrey, end: Colors.white70)
    //     .animate(controller);
    // controller.forward();
    //
    // controller.addListener(() {
    //   setState(() {});
    //   // print(animation.value);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: animation.value,
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
                    child: Image.asset('images/auctionpng.png'),
                    height: 60.0,
                  ),
                ),
                // TypewriterAnimatedTextKit
                  Text(
                  'AuctHouse',
                  style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Roundedbutton(Colors.blue, 'Register', () {
              Navigator.pushNamed(context, RegistrationScreen.id);
            }),
            Roundedbutton(Colors.lightBlueAccent, 'Log in', () {
              Navigator.pushNamed(context, LoginScreen.id);
            }),
          ],
        ),
      ),
    );
  }
}
