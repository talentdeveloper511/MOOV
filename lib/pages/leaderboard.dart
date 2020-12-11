import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

class LeaderBoardPage extends StatefulWidget {
  @override
  _LeaderBoardState createState() {
    return _LeaderBoardState();
  }
}

class _LeaderBoardState extends State<LeaderBoardPage> {
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 55.0,
              ),
            ],
          ),
        ),
      ),
      body: Center(child: Text('Leaderboard goes here.')),
    );
  }
}
