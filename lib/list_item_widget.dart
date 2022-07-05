import 'package:flutter/material.dart';
import 'auction_page.dart';

class ListItemWidget extends StatefulWidget {

  // const ListItemWidget({Key? key}) : super(key: key);
  final String id;
  final String title;
  final String description;
  final String imageURL;
  final String sellerEmail;
  final DateTime date;
  final String bidderEmail;
  final bidPrice;

  ListItemWidget({required this.id,required this.title, required this.description, required this.imageURL, required this.sellerEmail, required this.date, required this.bidderEmail, required this.bidPrice});

  @override
  State<ListItemWidget> createState() => _ListItemWidgetState();
}

class _ListItemWidgetState extends State<ListItemWidget> {
  @override

  String demoText = 'My Widget';

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AuctionPage(
                    id: widget.id,
                    title: widget.title,
                    description: widget.description,
                    imageURL: widget.imageURL,
                    seller: widget.sellerEmail,
                    date: widget.date,
                    bidder: widget.bidderEmail,
                    bidPrice: widget.bidPrice))
        );
      },
      child: Container(
        width: 500,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xA9E1DBFF),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
          border: Border.all(style: BorderStyle.solid)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              // height: do,
              width: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.red,
                ),
              ),
            ),
            Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.imageURL)
                      )
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}