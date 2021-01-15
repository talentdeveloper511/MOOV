import 'dart:collection';
import 'dart:ui';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/ProfilePage.dart';
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
  int status = 2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .doc(moovId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
          if (snapshot.hasError) return CircularProgressIndicator();

          List<dynamic> likedArray = course["liked"];
          Map<String, dynamic> invitees = course['invitees'];

          var sortedKeys = invitees.keys.toList(growable: false)
            ..sort((k1, k2) => invitees[k2].compareTo(invitees[k1]));
          LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
              key: (k) => k, value: (k) => invitees[k]);

          List<dynamic> inviteesIds = sortedMap.keys.toList();

          List<dynamic> inviteesValues = sortedMap.values.toList();

          return Column(
            children: [
              invitees != null
                  ? ListView.builder(
                      shrinkWrap: true, //MUST TO ADDED
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: inviteesIds.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(inviteesIds[index])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();

                              inviteesValues[index] == (2)
                                  ? status = 2
                                  : inviteesValues[index] == 1
                                      ? status = 1
                                      : inviteesValues[index] == 3
                                          ? status = 3
                                          : status = 0;

                              var pic = snapshot.data['photoUrl'];
                              var name = snapshot.data['displayName'];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (inviteesIds[index] ==
                                            currentUser.id) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtherProfile(pic, name,
                                                          inviteesIds[index])));
                                        }
                                      },
                                      child: Container(
                                          height: status == 0 ? 0 : 55,
                                          color: status == 2
                                              ? Colors.yellow[50]
                                              : status == 1
                                                  ? Colors.red[50]
                                                  : status == 3
                                                      ? Colors.green[50]
                                                      : Colors.white,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 12,
                                                            top: 4,
                                                            bottom: 4),
                                                    child: CircleAvatar(
                                                        radius: 22,
                                                        backgroundColor:
                                                            TextThemes.ndBlue,
                                                        child: CircleAvatar(
                                                          radius: 22.0,
                                                          backgroundImage:
                                                              NetworkImage(pic),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        )),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16.0),
                                                    child: Text(name,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: TextThemes
                                                                .ndBlue,
                                                            decoration:
                                                                TextDecoration
                                                                    .none)),
                                                  ),
                                                ]),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: status == 2
                                                        ? Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                child: Icon(
                                                                    Icons
                                                                        .accessibility,
                                                                    color: Colors
                                                                            .yellow[
                                                                        600]),
                                                              ),
                                                              Text(
                                                                "Undecided",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .yellow[
                                                                        600],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              )
                                                            ],
                                                          )
                                                        : status == 1
                                                            ? Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8.0),
                                                                    child: Icon(
                                                                        Icons
                                                                            .directions_walk,
                                                                        color: Colors
                                                                            .red),
                                                                  ),
                                                                  Text(
                                                                    "Not going",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  )
                                                                ],
                                                              )
                                                            : status == 3
                                                                ? Row(
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(right: 8.0),
                                                                        child: Icon(
                                                                            Icons
                                                                                .directions_run,
                                                                            color:
                                                                                Colors.green),
                                                                      ),
                                                                      Text(
                                                                        "Going!",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.green,
                                                                            fontWeight: FontWeight.w700),
                                                                      )
                                                                    ],
                                                                  )
                                                                : Container())
                                              ])),
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
  int status = 2;

  GoingPageFriends(this.likedArray, this.moovId);

  bool _isPressed;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .doc(moovId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data;
          if (snapshot.hasError) return CircularProgressIndicator();

          List<dynamic> likedArray = course["liked"];
          Map<String, dynamic> invitees = course['invitees'];

          var sortedKeys = invitees.keys.toList(growable: false)
            ..sort((k1, k2) => invitees[k2].compareTo(invitees[k1]));
          LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
              key: (k) => k, value: (k) => invitees[k]);

          List<dynamic> inviteesIds = sortedMap.keys.toList();

          List<dynamic> inviteesValues = sortedMap.values.toList();

          return Column(
            children: [
              invitees != null
                  ? ListView.builder(
                      shrinkWrap: true, //MUST TO ADDED
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: inviteesIds.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(inviteesIds[index])
                                .snapshots(),
                            builder: (context, snapshot2) {
                              if (!snapshot2.hasData)
                                return CircularProgressIndicator();
                              if (snapshot2.data['friendArray']
                                  .contains(currentUser.id)) {
                                inviteesValues[index] == (2)
                                    ? status = 2
                                    : inviteesValues[index] == 1
                                        ? status = 1
                                        : inviteesValues[index] == 3
                                            ? status = 3
                                            : status = 2;

                                var pic = snapshot2.data['photoUrl'];
                                var name = snapshot2.data['displayName'];

                                if (status == 0) {
                                  return Container();
                                }

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2.0),
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (inviteesIds[index] ==
                                              currentUser.id) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePage()));
                                          } else {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtherProfile(
                                                            pic,
                                                            name,
                                                            inviteesIds[
                                                                index])));
                                          }
                                        },
                                        child: Container(
                                            color: status == 2
                                                ? Colors.yellow[50]
                                                : status == 1
                                                    ? Colors.red[50]
                                                    : Colors.green[50],
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 12,
                                                              top: 4,
                                                              bottom: 4),
                                                      child: CircleAvatar(
                                                          radius: 22,
                                                          backgroundColor:
                                                              TextThemes.ndBlue,
                                                          child: CircleAvatar(
                                                            radius: 22.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    pic),
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                          )),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0),
                                                      child: Text(name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: TextThemes
                                                                  .ndBlue,
                                                              decoration:
                                                                  TextDecoration
                                                                      .none)),
                                                    ),
                                                  ]),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: status == 2
                                                          ? Row(
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                                  child: Icon(
                                                                      Icons
                                                                          .accessibility,
                                                                      color: Colors
                                                                              .yellow[
                                                                          600]),
                                                                ),
                                                                Text(
                                                                  "Undecided",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .yellow[
                                                                          600],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                )
                                                              ],
                                                            )
                                                          : status == 1
                                                              ? Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .directions_walk,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    Text(
                                                                      "Not going",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    )
                                                                  ],
                                                                )
                                                              : Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8.0),
                                                                      child: Icon(
                                                                          Icons
                                                                              .directions_run,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                                    Text(
                                                                      "Going!",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .green,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    )
                                                                  ],
                                                                ))
                                                ])),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            });
                      })
                  : Center(child: Text('')),
            ],
          );
        });
  }
}
