import 'dart:ui';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoingPage extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId, likeCount;

  GoingPage(this.likedArray, this.moovId);

  bool _isPressed;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection('food').document(moovId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
          if (snapshot.hasError) return CircularProgressIndicator();

          List<dynamic> likedArray = course["liked"];
          List<String> uidArray = List<String>();
          if (likedArray != null) {
            likeCount = likedArray.length;
            for (int i = 0; i < likeCount; i++) {
              var id = likedArray[i]["uid"];
              uidArray.add(id);
            }
          } else {
            likeCount = 0;
          }

          if (uidArray != null && uidArray.contains(currentUser.id)) {
            _isPressed = true;
          } else {
            _isPressed = false;
          }

          return Column(
            children: [
              likedArray != null
                  ? ListView.builder(
                      shrinkWrap: true, //MUST TO ADDED
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: likedArray.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(likedArray[index]['uid'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              var pic = snapshot.data['photoUrl'];
                              var name = snapshot.data['displayName'];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherProfile(
                                                      pic,
                                                      name,
                                                      likedArray[index]
                                                          ['uid']))),
                                      child: Container(
                                          child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 12),
                                            child: CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    TextThemes.ndBlue,
                                                child: CircleAvatar(
                                                  radius: 22.0,
                                                  backgroundImage:
                                                      NetworkImage(pic),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 16.0),
                                            child: Text(name,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: TextThemes.ndBlue,
                                                    decoration:
                                                        TextDecoration.none)),
                                          ),
                                        ],
                                      )),
                                    ),
                                  ],
                                ),
                              );
                            });
                      })
                  : Center(child: Text('')),
            ],
          );
        });
  }
}

class GoingPageFriends extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId, likeCount;

  GoingPageFriends(this.likedArray, this.moovId);

  bool _isPressed;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            Firestore.instance.collection('food').document(moovId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
          if (snapshot.hasError) return CircularProgressIndicator();

          List<dynamic> likedArray = course["liked"];
          List<String> uidArray = List<String>();
          if (likedArray != null) {
            likeCount = likedArray.length;
            for (int i = 0; i < likeCount; i++) {
              var id = likedArray[i]["uid"];
              uidArray.add(id);
            }
          } else {
            likeCount = 0;
          }

          if (uidArray != null && uidArray.contains(currentUser.id)) {
            _isPressed = true;
          } else {
            _isPressed = false;
          }

          return Column(
            children: [
              likedArray != null
                  ? ListView.builder(
                      shrinkWrap: true, //MUST TO ADDED
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: likedArray.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: Firestore.instance
                                .collection('users')
                                .document(likedArray[index]['uid'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              if (snapshot.data['friendArray']
                                  .contains(currentUser.id)) {
                                var pic = snapshot.data['photoUrl'];
                                var name = snapshot.data['displayName'];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherProfile(
                                                        pic,
                                                        name,
                                                        likedArray[index]
                                                            ['uid']))),
                                        child: Container(
                                            child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 12),
                                              child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                    radius: 22.0,
                                                    backgroundImage:
                                                        NetworkImage(pic),
                                                    backgroundColor:
                                                        Colors.transparent,
                                                  )),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16.0),
                                              child: Text(name,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: TextThemes.ndBlue,
                                                      decoration:
                                                          TextDecoration.none)),
                                            ),
                                          ],
                                        )),
                                      ),
                                    ],
                                  ),
                                );
                              } else
                                return Container();
                            });
                      })
                  : Center(child: Text('')),
            ],
          );
        });
  }
}
