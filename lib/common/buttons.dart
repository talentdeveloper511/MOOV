import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  final Widget child;
  final Text text;

  Buttons({Key key, @required this.child, this.text}) : super(key: key);

  _ButtonsState createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'lib/assets/bouts.jpg',
                fit: BoxFit.cover,
              ),
            ),

            margin: EdgeInsets.only(left: 30, top: 10, right: 30, bottom: 10),
            height: 75,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            // constraints: BoxConstraints(
            //     minHeight: 40,
            //     maxHeight: 40,
            //     minWidth: 300,
            //     maxWidth: 300),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(33.0),
              alignment: Alignment(0.0, 0.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(0),
                      Colors.black,
                      Colors.black12,
                    ],
                  ),
                ),
                child: Text(
                  "Baraka Bouts",
                  style: TextStyle(
                      fontFamily: 'Solway',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0),
                ),
              ),
            ),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "MOOV of the Day",
              )),
        ),
      ],
    );
  }
}
