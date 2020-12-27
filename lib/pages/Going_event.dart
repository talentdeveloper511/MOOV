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
  List<dynamic> likedArray, friendArray;
  dynamic moovId, likeCount;
  GoingPageFriends(this.likedArray, this.moovId);

  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(currentUser.id)
            .snapshots(),

// .where("liker", arrayContains: {
//                 "uid": strUserId
//               })

        builder: (context, snapshot) {
          // title = snapshot.data['title'];
          // pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          friendArray = snapshot.data["friendArray"];

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
                      itemCount: 1,
                      itemBuilder: (_, index) {
                        return PostsList(
                            friendsArray: friendArray,
                            likedArray: likedArray,
                            index: index,
                            moovId: moovId);
                      })
                  : Center(child: Text('')),
            ],
          );
        });
  }
}

class PostsList extends StatelessWidget {
  final List<dynamic> friendsArray, likedArray;
  int index;
  final dynamic moovId;
  dynamic likeCount = 0;

  PostsList({this.friendsArray, this.likedArray, this.index, this.moovId});
  @override
  bool _isPressed;

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
                      itemCount: likedArray.length,
                      shrinkWrap: true, //MUST TO ADDED
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        print(index++);
                        List<dynamic> likerArray = course["liker"];
                        // print(likedArray[index]['uid'] + " this is likedarray");
                        // print(friendsArray);
                        if (friendsArray.contains(likedArray[index]['uid'])) {
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
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
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: CircleAvatar(
                                              radius: 22,
                                              backgroundColor:
                                                  TextThemes.ndBlue,
                                              child: CircleAvatar(
                                                radius: 22.0,
                                                backgroundImage: NetworkImage(
                                                    likedArray[index]
                                                        ['strPic']),
                                                backgroundColor:
                                                    Colors.transparent,
                                              )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                              likedArray[index]['strName'],
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
                              ));
                        } else {
                          return null;
                        }
                      })
                  : Center(child: Text('${likedArray[0]['uid']}')),
            ],
          );
        });
  }

  likerLoop(friendsArray, likedArray, index) {
    friendsArray.forEach((id) {
      if (likedArray[index]['uid'] == id)
      // return id;
      {
        print(likedArray[index]['strName']);
        var friendPic = likedArray[index]['strPic'];
        var friendName = likedArray[index]['strName'];
        var friendId = likedArray[index]['uid'];
      } else {
        // return null;
        print('boo');
      }
    });

    // for (index in friendsArray)
    // if (friendsArray.contains(course['liker'][index])) return true;
  }

//   likerLoop2(likerArray) {
//     while (index <= friendsArray.length) {
//       print(likerArray[index]);
//       if (friendsArray.contains(likerArray[index])) return true;

//       index++;
//     }
//   }
// }
}
