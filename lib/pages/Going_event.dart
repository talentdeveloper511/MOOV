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
          // title = snapshot.data['title'];
          // pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => OtherProfile(
                                            likedArray[index]['strPic'],
                                            likedArray[index]['strName'],
                                            likedArray[index]['uid']))),
                                child: Container(
                                    child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: TextThemes.ndBlue,
                                          child: CircleAvatar(
                                            radius: 22.0,
                                            backgroundImage: NetworkImage(
                                                likedArray[index]['strPic']),
                                            backgroundColor: Colors.transparent,
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(likedArray[index]['strName'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: TextThemes.ndBlue,
                                              decoration: TextDecoration.none)),
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        );
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
          // title = snapshot.data['title'];
          // pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
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
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => OtherProfile(
                                            likedArray[index]['strPic'],
                                            likedArray[index]['strName'],
                                            likedArray[index]['uid']))),
                                child: Container(
                                    child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12),
                                      child: CircleAvatar(
                                          radius: 22,
                                          backgroundColor: TextThemes.ndBlue,
                                          child: CircleAvatar(
                                            radius: 22.0,
                                            backgroundImage: NetworkImage(
                                                likedArray[index]['strPic']),
                                            backgroundColor: Colors.transparent,
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 16.0),
                                      child: Text(likedArray[index]['strName'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: TextThemes.ndBlue,
                                              decoration: TextDecoration.none)),
                                    ),
                                  ],
                                )),
                              ),
                            ],
                          ),
                        );
                      })
                  : Center(child: Text('')),
            ],
          );
        });
  }
}
