// import 'package:chatapp/screens/chat_screen.dart';
// import 'package:chatapp/Components/roundedbuttons.dart';
// import 'package:chatapp/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:auctioneer/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'additems.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:auctioneer/welcomescreen.dart';
import 'package:auctioneer/registeration screen.dart';
import 'login screen.dart';
import 'home.dart';
import 'package:auctioneer/present.dart';
import 'package:auctioneer/past.dart';
import 'future.dart';

// void main() async {
//   // Ensure that Firebase is initialized
//   // WidgetsFlutterBinding.ensureInitialized();
//   // // Initialize Firebase
//   // await Firebase.initializeApp();
//   //
//   runApp(MaterialApp(initialRoute: AdditemsScreen.id, routes: {
//     AdditemsScreen.id: (context) => AdditemsScreen(),
//   }));
// }
void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  //
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        AdditemsScreen.id: (context) => AdditemsScreen(),
        HomePageWidget.id:(context)=>HomePageWidget(),
        PresentPage.id:(context)=>PresentPage(),
        FuturePage.id:(context)=>FuturePage(),
        PastPage.id:(context)=> PastPage()
      },
    );
  }
}
