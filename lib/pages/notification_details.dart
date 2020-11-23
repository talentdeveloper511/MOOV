import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MOOV/services/database.dart';

import 'home.dart';

class NotificationDetails extends StatefulWidget {
  String photoUrl, displayName, id, email, username;
  NotificationDetails(this.photoUrl, this.displayName, this.id, this.email,
      this.username);

  @override
  State<StatefulWidget> createState() {
    return _NotificationDetailsState(this.photoUrl, this.displayName, this.id,
        this.email, this.username);
  }
}

class _NotificationDetailsState extends State<NotificationDetails> {
  String photoUrl, displayName, id, email, username;
  final dbRef = Firestore.instance;
  _NotificationDetailsState(this.photoUrl, this.displayName, this.id,
      this.email, this.username);

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount userMe = googleSignIn.currentUser;
    final strUserId = userMe.id;
    final strPic = userMe.photoUrl;
    final strUserName = userMe.displayName;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: TextThemes.ndGold,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: TextThemes.ndBlue,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                      radius: 50,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                displayName,
                style: TextThemes.extraBold,
              ),
            ),
          /*  Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                email,
                style: TextThemes.subtitle1,
              ),
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '42 Friends',
                  style: TextThemes.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('•'),
                ),
                Text(
                  '2 upcoming MOOVS',
                  style: TextThemes.bodyText1,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
              child: Row(
                children: [
                  RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    color:  Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    onPressed: () {
                      Database().sendFriendRequest(strUserId, id, strUserName, strPic);
                      Navigator.pop(context);
                    },
                    child: Text("Reject Friend Request",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  RaisedButton(
                    padding: const EdgeInsets.all(10.0),
                    color:  Color.fromRGBO(2, 43, 91, 1.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    onPressed: () {
                      Database().acceptFriendRequest(strUserId, id, strUserName, strPic);
                      Navigator.pop(context);
                    },
                    child: Text("Accept Friend Request",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}