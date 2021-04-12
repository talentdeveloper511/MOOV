import 'dart:async';

import 'package:flutter/material.dart';

class SundayWrapUp extends StatefulWidget {
  final String title, description, choice1, choice2, image, postTitle;

  // final MyEventCallback choice1Action, choice2Action;

  const SundayWrapUp(
      {Key key,
      this.title,
      this.description,
      this.choice1,
      this.choice2,
      this.image,
      // this.choice1Action,
      // this.choice2Action,
      this.postTitle});

  @override
  _SundayWrapUpState createState() => _SundayWrapUpState();
}

class _SundayWrapUpState extends State<SundayWrapUp> {
  bool isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: contentBox(context)));
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: isChecking ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              isChecking
                  ? Icon(Icons.check, size: 45, color: Colors.white)
                  : Text(
                      widget.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.description,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 27.5,
              ),
              Row(
                children: [Text("MOOVs", style: TextStyle(fontWeight: FontWeight.w600))],
              ),
              SizedBox(height: 100)
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          right: 10,
          child: Container(
            child: Stack(alignment: Alignment.center, children: [
              Icon(Icons.replay),
            ]),
          ),
        ),
      ],
    );
  }
}
