import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = auth.FirebaseAuth.instance;
late auth.User loggedInUser;

class AuctionPage extends StatefulWidget {
  // const AuctionPage({Key? key}) : super(key: key);
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final String seller;
  final DateTime date;
  String bidder;
  var bidPrice;

  AuctionPage({
    required this.id,
  required this.title,
  required this.description,
  required this.imageURL,
  required this.seller,
  required this.date,
  required this.bidder,
  required this.bidPrice});


  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {

  late String time1;
  bool isPast = false;
  bool isPresent = false;
  bool isFuture = false;
  late var end_time;
  late String formattedDate;

  @override
  void initState() {
    super.initState();

    print(widget.date);
    DateTime end= widget.date.add(Duration(minutes: 30));
    end_time = DateFormat.Hms().format(end);
    DateTime now = new DateTime.now();
    if(now.isBefore(widget.date)){
      isPast = true;
    }else if(now.isAfter(end)){
      isFuture = true;
    }else{
      isPresent = true;
    }
    print(end);
    time1 = DateFormat.Hms().format(widget.date);
    formattedDate = DateFormat('dd-MM-yyyy').format(widget.date);
  }

  Future<void> placeBid(int bidIncrement) async{
    final docRef = FirebaseFirestore.instance.collection('autionitem').doc(widget.id);
    await FirebaseFirestore.instance.runTransaction(
            (transaction) async{
              DocumentSnapshot documentSnapshot = await transaction.get(docRef);
              if(documentSnapshot['bidPrice'] > widget.bidPrice + bidIncrement){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("You missed the shot !")));
                return;
              }
              await transaction.update(docRef, {
                'bidPrice' : widget.bidPrice + bidIncrement,
                'bidder' : auth.FirebaseAuth.instance.currentUser!.email
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Succesfully placed bid")));
              setState((){
                widget.bidPrice=widget.bidPrice + bidIncrement;
                widget.bidder = auth.FirebaseAuth.instance.currentUser!.email!;
              });
            });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Page'),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Text(
            'Item : ${widget.title}',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            'Seller email: ${widget.seller}',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 300,
            width: 600,
            child: Container(
              // alignment: Alignment.center,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.imageURL)
                  )
              ),
              // child: Icon(
              //     Icons.add
              // ),
            ),
          ),
          if(isPast) ...[
          Text(
            'Auction Start time: ${time1}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
            Text(
              'Auction Start Date: ${formattedDate}',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ] else if (isPresent) ... [
          Text(
            (widget.bidder!='') ? 'Bidder email: ${widget.bidder}' : 'No bids yet',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            (widget.bidder!='') ? 'Current Bid price: ${widget.bidPrice}' : 'Base Price = 0',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text(
            'Auction end time: ${end_time}',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed:()async{
                        await placeBid(100);
                      },
                      child: Text(
                        '+100'
                      )
                  ),
                  TextButton(
                      onPressed:()async{
                        await placeBid(500);
                      },
                      child: Text(
                          '+500'
                      )
                  ),
                  TextButton(
                      onPressed:()async{
                        await placeBid(1000);
                      },
                      child: Text(
                          '+1000'
                      )
                  )
                ],
              ),
            )
          ] else ... [
          Text(
            (widget.bidder!='')?'Sold at \$${widget.bidPrice} to ${widget.bidder}':'Unsold!',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          ]
        ],
      ),
    );
  }
}
