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
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "You have no MOOVS :(",
              ),
            ),
            FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: Text('Find a MOOV'),
                icon: Icon(Icons.search),
                backgroundColor: Color.fromRGBO(220, 180, 57, 1.0)),
          ],
        ),
      ),
    ));
  }
}
