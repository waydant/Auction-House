import 'package:flutter/material.dart';
import 'list_item_widget.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = auth.FirebaseAuth.instance;
late auth.User loggedInUser;


class FuturePage extends StatefulWidget {
  const FuturePage({Key? key}) : super(key: key);
  static String id = 'Future';

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('autionitem').snapshots(),
        builder:(context,snapshot){
          List<Widget> currentAuctionItems = [];
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final dataStream = snapshot.data?.docs;

          for(var data in dataStream!){
            DateTime start = data['timestamp'].toDate();
            DateTime end = data['timestamp'].toDate().add(Duration(minutes: 30));
            DateTime now = new DateTime.now();
            // print(data['timestamp'].toDate());
            if(now.isBefore(start)){
              currentAuctionItems.add(
                ListItemWidget(
                    id: data.id,
                    title: data['Name'],
                    description: data['Description'],
                    imageURL: data['imageURL'],
                    sellerEmail: data['seller'],
                    date: data['timestamp'].toDate(),
                    bidderEmail: data['bidder'],
                    bidPrice: data['bidPrice']
                ),
              );
            }
          }
          return currentAuctionItems.isNotEmpty ? ListView(
            children: currentAuctionItems,
          ): Center(child: Text("No Items"),);
        }
    );
  }
}
