import 'package:auctioneer/Components/roundedbuttons.dart';
import 'package:auctioneer/additems.dart';
import 'package:auctioneer/home.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'loginscreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        backgroundColor: Colors.white70,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/auctionpng.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    String pattern =
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                        r"{0,253}[a-zA-Z0-9])?)*$";
                    RegExp regex = RegExp(pattern);
                    if (value == null ||
                        value.isEmpty ||
                        !regex.hasMatch(value))
                      return 'Enter a valid email address';
                    else
                      return null;
                  },
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextfielddecoration.copyWith(
                      hintText: 'Enter your Email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  textAlign: TextAlign.center,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must Enter the name';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextfielddecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                SizedBox(
                  height: 24.0,
                ),
                Roundedbutton(Colors.lightBlueAccent, 'Log In', () async {
                  if (formkey.currentState?.validate() != null) {
                    try {
                      setState(() {
                        showspinner = true;
                      });
                      print(email);
                      print(password);
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (user != null) {
                        Navigator.pushNamed(context, HomePageWidget.id);
                      }
                      setState(() {
                        showspinner = false;
                      });
                    } catch (e) {
                      setState(() {
                        showspinner = false;
                      });
                      String ans = "Invalid Input";
                      int counter = 0;
                      for (int i = 0; i < e.toString().length; i++) {
                        if (counter != 0) {
                          ans = ans + e.toString()[i];
                        }
                        if (e.toString()[i] == ']') {
                          counter = 1;
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          ans,
                          textAlign: TextAlign.center,
                        ),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ));
                    }
                  }
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
