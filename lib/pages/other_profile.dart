import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MOOV/services/database.dart';

import 'home.dart';

class OtherProfile extends StatefulWidget {
  String photoUrl, displayName, id;
  OtherProfile(this.photoUrl, this.displayName, this.id);

  @override
  State<StatefulWidget> createState() {
    return _OtherProfileState(this.photoUrl, this.displayName, this.id);
  }
}

class _OtherProfileState extends State<OtherProfile> {
  String photoUrl, displayName, id;
  final dbRef = Firestore.instance;
  _OtherProfileState(this.photoUrl, this.displayName, this.id);
  bool requestsent = false;
  bool sendRequest = false;
  bool friends;
  var status;
  var userRequests;

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount userMe = googleSignIn.currentUser;
    final strUserId = userMe.id;
    final strPic = userMe.photoUrl;
    final strUserName = userMe.displayName;

    // status definitions:
    //    null: no request between either users
    //    0: friend request was made
    //    1: users are friends
    //    2: other user has already requested current user

    // check to see if a request from other user already exists
    Database().checkStatus(id, strUserId).then((QuerySnapshot docs) => {
          if (docs.documents.isNotEmpty)
            {
              setState(
                  () => userRequests = docs.documents[0].data['friendArray']),
              for (var i = 0; i < userRequests.length; i++)
                {
                  if (userRequests[i][id] == 0) {status = 2}
                }
            }
        });

    // if existing request does not exist
    if (status != 2) {
      Database().checkStatus(strUserId, id).then((QuerySnapshot docs) => {
            if (docs.documents.isNotEmpty)
              {
                setState(
                    () => userRequests = docs.documents[0].data['friendArray']),
                for (var i = 0; i < userRequests.length; i++)
                  {
                    if (userRequests[i][strUserId] != null)
                      {status = userRequests[i][strUserId]}
                  }
              }
          });
    }

    // print(status);

    return StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');
          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset('lib/assets/ndlogo.png', height: 100),
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
                          backgroundImage: (photoUrl == null)
                              ? AssetImage('images/user-avatar.png')
                              : NetworkImage(photoUrl),
                          // backgroundImage: NetworkImage(currentUser.photoUrl),
                          radius: 50,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      displayName != "" ? displayName : "Username not found",
                      style: TextThemes.extraBold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
                        child: Text(
                          "Female dog in Pangborn",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "This is my bio",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Text(
                            '2',
                            style: TextThemes.extraBold,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Next MOOVs   ',
                              style: TextThemes.bodyText1,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              '0',
                              style: TextThemes.extraBold,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Friends',
                                style: TextThemes.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '0',
                            style: TextThemes.extraBold,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              'Friend Groups',
                              style: TextThemes.bodyText1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 7.5, bottom: 15, top: 15.5),
                    child: status == 2
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RaisedButton(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Color.fromRGBO(0, 100, 0, 1.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    setState(() {
                                      Database().acceptFriendRequest(
                                          id, strUserId, strUserName, strPic);
                                    });
                                    status = 1;
                                  },
                                  child: Text(
                                    "Accept Friend Request",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  )),
                              RaisedButton(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    setState(() {
                                      status = null;
                                      Database().rejectFriendRequest(
                                          strUserId, id, strUserName, strPic);
                                    });
                                  },
                                  child: Text(
                                    "Decline Friend Request",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  )),
                            ],
                          )
                        : status != 1
                            ? RaisedButton(
                                padding: const EdgeInsets.all(12.0),
                                color: Color.fromRGBO(2, 43, 91, 1.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0))),
                                onPressed: () {
                                  setState(() {
                                    Database().sendFriendRequest(
                                        strUserId, id, strUserName, strPic);
                                  });
                                },
                                child: status == null
                                    ? Text(
                                        "Send Friend Request",
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      )
                                    : Text(
                                        "Request Sent",
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.0,
                                        ),
                                      ),
                              )
                            : RaisedButton(
                                padding: const EdgeInsets.all(12.0),
                                color: Color.fromRGBO(0, 100, 0, 1.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(3.0))),
                                onPressed: () {
                                  // setState(() {}
                                },
                                child: Text(
                                  "Friends",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                )),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
