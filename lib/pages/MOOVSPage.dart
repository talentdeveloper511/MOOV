import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[Text("Test")],
        ),
      ),
    );
  }
}
