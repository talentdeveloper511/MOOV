// import 'package:MOOV/widgets/segmented_control.dart';
import 'package:MOOV/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/post/MoovMaker.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/services/database.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage> {
  final String currentUserId = currentUser?.id;
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    isLiked = false;
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
        ),
      ),

     body: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Padding(
           padding: const EdgeInsets.only(bottom: 15.0),
           child: Text('You have no MOOVs :('),
         ),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             FloatingActionButton.extended(
                  onPressed: () {
                    // Add your onPressed code here!
                  },
                  label: Text('Find a MOOV',
                      style: TextStyle(color: Colors.white)),
                  icon: Icon(Icons.search, color: Colors.white),
                  backgroundColor: Color.fromRGBO(220, 180, 57, 1.0)),
           ],
         ),
       ],
     )
    );
  }

  handleLikePost() {
    if (isLiked == true) {
      isLiked = false;
    } else {
      isLiked = true;
    }
  }
}
