import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV3/helpers/themes.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            backgroundColor: TextThemes.ndBlue,
            //pinned: true,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.search),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Search');
                },
              ),
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.message),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Message');
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'lib/assets/moovheader.png',
                    fit: BoxFit.cover,
                    height: 45.0,
                  ),
                  Image.asset(
                    'lib/assets/ndlogo.png',
                    fit: BoxFit.cover,
                    height: 25,
                  )
                ],
              ),
            ),),
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "You have no MOOVs :(",
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
