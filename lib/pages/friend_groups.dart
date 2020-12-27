import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

class FriendGroupsPage extends StatefulWidget {
  @override
  _FriendGroupsState createState() {
    return _FriendGroupsState();
  }
}

class _FriendGroupsState extends State<FriendGroupsPage> {
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: TextThemes.ndBlue,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.search),
            Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
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
        body: Container(
          color: TextThemes.ndBlue,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 75),
                child: Center(
                  child: Text('Make or join a \nFriend Group.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.robotoSlab(
                        color: Colors.white,
                        fontSize: 30,
                      )),
                      
                ),
                
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 150,
                        color: Colors.white,
                      ),
                      Text("MAKE",
                          style: GoogleFonts.robotoSlab(
                            color: Colors.white,
                            fontSize: 25,
                          )),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        Icons.people,
                        size: 150,
                        color: Colors.white,
                      ),
                      Text("JOIN",
                          style: GoogleFonts.robotoSlab(
                            color: Colors.white,
                            fontSize: 25,
                          )),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
