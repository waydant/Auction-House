import 'package:flutter/material.dart';
import 'package:auctioneer/present.dart';
import 'future.dart';
import 'package:auctioneer/past.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'additems.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = auth.FirebaseAuth.instance;
late auth.User loggedInUser;


class HomePageWidget extends StatefulWidget {
  // const HomePageWidget({Key? key}) : super(key: key);

  static String id = 'Home';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {

  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Past',
    ),
    Text(
      'Index 2: Present',
    ),
    Text(
      'Index 3: Future',
    ),
  ];

  void _onItemTapped(int index){
    setState((){
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auctioneer',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        // child: _widgetOptions.elementAt(_selectedIndex),
        child: (_selectedIndex==0)?PastPage():(_selectedIndex==1)?PresentPage():FuturePage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
              label: 'Past'),
          BottomNavigationBarItem(icon: Icon(Icons.business),
              label: 'Present'),
          BottomNavigationBarItem(icon: Icon(Icons.school),
              label: 'Future'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context,
            AdditemsScreen.id
          );
        },
        // backgroundColor: Colors.black45,
        child: Icon(Icons.add),
      ),
    );
  }
}

