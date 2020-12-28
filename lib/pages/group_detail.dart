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

class GroupDetail extends StatefulWidget {
  String photoUrl, displayName;
  List<dynamic> members;

  GroupDetail(this.photoUrl, this.displayName, this.members);

  @override
  State<StatefulWidget> createState() {
    return _GroupDetailState(this.photoUrl, this.displayName, this.members);
  }
}

class _GroupDetailState extends State<GroupDetail> {
  String photoUrl, displayName;
  List<dynamic> members;
  final dbRef = Firestore.instance;
  _GroupDetailState(this.photoUrl, this.displayName, this.members);
  bool requestsent = false;
  bool sendRequest = false;
  bool friends;
  var status;
  var userRequests;
  final GoogleSignInAccount userMe = googleSignIn.currentUser;
  final strUserId = currentUser.id;
  final strPic = currentUser.photoUrl;
  final strUserName = currentUser.displayName;
  var iter = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('friendGroups', arrayContains: displayName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

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
                    Text(displayName,
                        style: TextStyle(fontSize: 30.0, color: Colors.white))
                  ],
                ),
              ),
            ),
            body: ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (_, index) {
                  return Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => OtherProfile()));
                                  },
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: TextThemes.ndGold,
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundColor: TextThemes.ndBlue,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(snapshot
                                            .data
                                            .documents[index]
                                            .data['photoUrl']),
                                        radius: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: RichText(
                                      textScaleFactor: 1.3,
                                      text: TextSpan(
                                          style: TextThemes.mediumbody,
                                          children: [
                                            TextSpan(
                                                text: "\"" +
                                                    snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['displayName']
                                                        .toString() +
                                                    "\"",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
