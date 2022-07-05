import 'package:flutter/material.dart';

class Roundedbutton extends StatelessWidget {
  Roundedbutton(this.color, this.title, this.OnPressed);
  late final Color color;
  late final String title;
  final Function()? OnPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: OnPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
