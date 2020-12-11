import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';

import 'package:MOOV/helpers/themes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/home.dart';

class TrendingSegment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TrendingSegmentState();
  }
}

class TrendingSegmentState extends State<TrendingSegment> {
  int selectedIndex = 0;
  Map<int, Widget> map = new Map();
  @override
  void initState() {
    super.initState();
    loadCupertinoTabs();
  }

  void loadCupertinoTabs() {
    map = new Map();
    map = {
      0: Container(
          width: 100,
          child: Center(
            child: Text(
              "Featured",
              style: TextStyle(color: Colors.white),
            ),
          )),
      1: Container(
          width: 100,
          child: Center(
            child: Text(
              "All",
              style: TextStyle(color: Colors.white),
            ),
          )),
      2: Container(
          width: 100,
          child: Center(
            child: Text(
              "Friends",
              style: TextStyle(color: Colors.white),
            ),
          ))
    };
  }

  bool _isPressed; // = false;
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;

    dynamic likeCount;
    // TODO: implement build
    return StreamBuilder(
        stream: Firestore.instance
            .collection('food')
            .orderBy('likeCounter', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Text('Loading data...');
          return Container(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.redAccent, TextThemes.ndBlue])),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text('TRENDING',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Pacifico')),
                    ))),
                Expanded(
                    child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset('lib/assets/plate.png', height: 40),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('FOOD', style: TextThemes.extraBold),
                          ),
                        ],
                      ),
                    )),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          DocumentSnapshot course =
                              snapshot.data.documents[index];
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

                          if (uidArray != null &&
                              uidArray.contains(strUserId)) {
                            _isPressed = true;
                          } else {
                            _isPressed = false;
                          }

                          return Card(
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PostDetail(
                                                course['image'],
                                                course['title'],
                                                course['description'],
                                                course['startDate'],
                                                course['location'],
                                                course['address'],
                                                course['profilePic'],
                                                course['userName'],
                                                course['userEmail'],
                                                likedArray,
                                                course.documentID)));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              course['title'].toString(),
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Color(0xff000000),
                                          width: 1,
                                        )),
                                        child: Image.network(course['image'],
                                            fit: BoxFit.cover,
                                            height: 75,
                                            width: 110),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 4.0),
                                            child: CircleAvatar(
                                              radius: 8.0,
                                              backgroundImage: NetworkImage(
                                                course['profilePic'],
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6.0, left: 12, right: 2),
                                            child: Icon(Icons.timer,
                                                color: TextThemes.ndGold,
                                                size: 15),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Text(
                                                DateFormat('MMMd')
                                                    .add_jm()
                                                    .format(course['startDate']
                                                        .toDate()),
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                )),
                                          )
                                        ],
                                      )
                                    ],

                                    // children: [
                                    //   ListTile(
                                    //     title: Row(children: <Widget>[
                                    //       Expanded(
                                    //           child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       top: 5.0,
                                    //                       right: 5,
                                    //                       bottom: 5),
                                    //               child: Container(
                                    //                 decoration: BoxDecoration(
                                    //                     border: Border.all(
                                    //                   color: Color(0xff000000),
                                    //                   width: 1,
                                    //                 )),
                                    //                 child: Image.network(
                                    //                     course['image'],
                                    //                     fit: BoxFit.cover,
                                    //                     height: 130,
                                    //                     width: 50),
                                    //               ))),
                                    //       Expanded(
                                    //           child: Column(children: <Widget>[
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(8.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(2.0),
                                    //             child: Text(
                                    //                 course['title'].toString(),
                                    //                 style: TextStyle(
                                    //                     color: Colors.blue[900],
                                    //                     fontSize: 20.0,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //                 textAlign:
                                    //                     TextAlign.center)),
                                    //         Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(10.0),
                                    //           child: Text(
                                    //             course['description']
                                    //                 .toString(),
                                    //             textAlign: TextAlign.center,
                                    //             style: TextStyle(
                                    //                 fontSize: 12.0,
                                    //                 color: Colors.black
                                    //                     .withOpacity(0.6)),
                                    //           ),
                                    //         ),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(5.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(3.0),
                                    //             child: Row(
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.end,
                                    //               children: [
                                    //                 Text('START: ',
                                    //                     style: TextStyle(
                                    //                         fontSize: 12.0,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 Text(
                                    //                     DateFormat('MMMd')
                                    //                         .add_jm()
                                    //                         .format(course[
                                    //                                 'startDate']
                                    //                             .toDate()),
                                    //                     style: TextStyle(
                                    //                       fontSize: 12.0,
                                    //                     )),
                                    //               ],
                                    //             )),
                                    //       ]))
                                    //     ]),
                                    //   ),
                                    //   Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 1.0),
                                    //     child: Container(
                                    //       height: 1.0,
                                    //       width: 500.0,
                                    //       color: Colors.grey[300],
                                    //     ),
                                    //   ),
                                    //   Container(
                                    //       child: Row(
                                    //     children: [
                                    //       Padding(
                                    //           padding:
                                    //               const EdgeInsets.fromLTRB(
                                    //                   12, 10, 4, 10),
                                    //           child: CircleAvatar(
                                    //             radius: 22.0,
                                    //             backgroundImage: NetworkImage(
                                    //                 course['profilePic']),
                                    //             backgroundColor:
                                    //                 Colors.transparent,
                                    //           )),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userName'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 14,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userEmail'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Spacer(),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.end,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 8.0),
                                    //               child: IconButton(
                                    //                 icon: (_isPressed)
                                    //                     ? new Icon(
                                    //                         Icons
                                    //                             .directions_run,
                                    //                         color: Colors.green)
                                    //                     : new Icon(Icons
                                    //                         .directions_walk),
                                    //                 color: Colors.red,
                                    //                 iconSize: 30.0,
                                    //                 splashColor: Colors.green,
                                    //                 //splashRadius: 7.0,
                                    //                 highlightColor:
                                    //                     Colors.green,
                                    //                 onPressed: () {
                                    //                   // Perform action
                                    //                   setState(() {
                                    //                     List<dynamic>
                                    //                         likedArray =
                                    //                         course["liked"];
                                    //                     List<String> uidArray =
                                    //                         List<String>();
                                    //                     if (likedArray !=
                                    //                         null) {
                                    //                       likeCount =
                                    //                           likedArray.length;
                                    //                       for (int i = 0;
                                    //                           i < likeCount;
                                    //                           i++) {
                                    //                         var id =
                                    //                             likedArray[i]
                                    //                                 ["uid"];
                                    //                         uidArray.add(id);
                                    //                       }
                                    //                     }

                                    //                     if (uidArray != null &&
                                    //                         uidArray.contains(
                                    //                             strUserId)) {
                                    //                       Database().removeGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                     } else {
                                    //                       Database().addGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                       print(
                                    //                         course["userId"],
                                    //                       );
                                    //                     }
                                    //                   });
                                    //                 },
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 10.0,
                                    //                       bottom: 4.0),
                                    //               child: Text(
                                    //                 'Going?',
                                    //                 style:
                                    //                     TextStyle(fontSize: 12),
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.fromLTRB(
                                    //                       0, 0, 30.0, 10),
                                    //               child: Text('$likeCount',
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 )),
                                    //               ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }, childCount: 6),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        )),
                    SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset('lib/assets/dance.png', height: 38),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('PARTIES', style: TextThemes.extraBold),
                          ),
                        ],
                      ),
                    )),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          DocumentSnapshot course =
                              snapshot.data.documents[index];
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

                          if (uidArray != null &&
                              uidArray.contains(strUserId)) {
                            _isPressed = true;
                          } else {
                            _isPressed = false;
                          }

                          return Card(
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PostDetail(
                                                course['image'],
                                                course['title'],
                                                course['description'],
                                                course['startDate'],
                                                course['location'],
                                                course['address'],
                                                course['profilePic'],
                                                course['userName'],
                                                course['userEmail'],
                                                likedArray,
                                                course.documentID)));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              course['title'].toString(),
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Color(0xff000000),
                                          width: 1,
                                        )),
                                        child: Image.network(course['image'],
                                            fit: BoxFit.cover,
                                            height: 75,
                                            width: 110),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 4.0),
                                            child: CircleAvatar(
                                              radius: 8.0,
                                              backgroundImage: NetworkImage(
                                                course['profilePic'],
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6.0, left: 12, right: 2),
                                            child: Icon(Icons.timer,
                                                color: TextThemes.ndGold,
                                                size: 15),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Text(
                                                DateFormat('MMMd')
                                                    .add_jm()
                                                    .format(course['startDate']
                                                        .toDate()),
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                )),
                                          )
                                        ],
                                      )
                                    ],

                                    // children: [
                                    //   ListTile(
                                    //     title: Row(children: <Widget>[
                                    //       Expanded(
                                    //           child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       top: 5.0,
                                    //                       right: 5,
                                    //                       bottom: 5),
                                    //               child: Container(
                                    //                 decoration: BoxDecoration(
                                    //                     border: Border.all(
                                    //                   color: Color(0xff000000),
                                    //                   width: 1,
                                    //                 )),
                                    //                 child: Image.network(
                                    //                     course['image'],
                                    //                     fit: BoxFit.cover,
                                    //                     height: 130,
                                    //                     width: 50),
                                    //               ))),
                                    //       Expanded(
                                    //           child: Column(children: <Widget>[
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(8.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(2.0),
                                    //             child: Text(
                                    //                 course['title'].toString(),
                                    //                 style: TextStyle(
                                    //                     color: Colors.blue[900],
                                    //                     fontSize: 20.0,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //                 textAlign:
                                    //                     TextAlign.center)),
                                    //         Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(10.0),
                                    //           child: Text(
                                    //             course['description']
                                    //                 .toString(),
                                    //             textAlign: TextAlign.center,
                                    //             style: TextStyle(
                                    //                 fontSize: 12.0,
                                    //                 color: Colors.black
                                    //                     .withOpacity(0.6)),
                                    //           ),
                                    //         ),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(5.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(3.0),
                                    //             child: Row(
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.end,
                                    //               children: [
                                    //                 Text('START: ',
                                    //                     style: TextStyle(
                                    //                         fontSize: 12.0,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 Text(
                                    //                     DateFormat('MMMd')
                                    //                         .add_jm()
                                    //                         .format(course[
                                    //                                 'startDate']
                                    //                             .toDate()),
                                    //                     style: TextStyle(
                                    //                       fontSize: 12.0,
                                    //                     )),
                                    //               ],
                                    //             )),
                                    //       ]))
                                    //     ]),
                                    //   ),
                                    //   Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 1.0),
                                    //     child: Container(
                                    //       height: 1.0,
                                    //       width: 500.0,
                                    //       color: Colors.grey[300],
                                    //     ),
                                    //   ),
                                    //   Container(
                                    //       child: Row(
                                    //     children: [
                                    //       Padding(
                                    //           padding:
                                    //               const EdgeInsets.fromLTRB(
                                    //                   12, 10, 4, 10),
                                    //           child: CircleAvatar(
                                    //             radius: 22.0,
                                    //             backgroundImage: NetworkImage(
                                    //                 course['profilePic']),
                                    //             backgroundColor:
                                    //                 Colors.transparent,
                                    //           )),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userName'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 14,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userEmail'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Spacer(),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.end,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 8.0),
                                    //               child: IconButton(
                                    //                 icon: (_isPressed)
                                    //                     ? new Icon(
                                    //                         Icons
                                    //                             .directions_run,
                                    //                         color: Colors.green)
                                    //                     : new Icon(Icons
                                    //                         .directions_walk),
                                    //                 color: Colors.red,
                                    //                 iconSize: 30.0,
                                    //                 splashColor: Colors.green,
                                    //                 //splashRadius: 7.0,
                                    //                 highlightColor:
                                    //                     Colors.green,
                                    //                 onPressed: () {
                                    //                   // Perform action
                                    //                   setState(() {
                                    //                     List<dynamic>
                                    //                         likedArray =
                                    //                         course["liked"];
                                    //                     List<String> uidArray =
                                    //                         List<String>();
                                    //                     if (likedArray !=
                                    //                         null) {
                                    //                       likeCount =
                                    //                           likedArray.length;
                                    //                       for (int i = 0;
                                    //                           i < likeCount;
                                    //                           i++) {
                                    //                         var id =
                                    //                             likedArray[i]
                                    //                                 ["uid"];
                                    //                         uidArray.add(id);
                                    //                       }
                                    //                     }

                                    //                     if (uidArray != null &&
                                    //                         uidArray.contains(
                                    //                             strUserId)) {
                                    //                       Database().removeGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                     } else {
                                    //                       Database().addGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                       print(
                                    //                         course["userId"],
                                    //                       );
                                    //                     }
                                    //                   });
                                    //                 },
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 10.0,
                                    //                       bottom: 4.0),
                                    //               child: Text(
                                    //                 'Going?',
                                    //                 style:
                                    //                     TextStyle(fontSize: 12),
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.fromLTRB(
                                    //                       0, 0, 30.0, 10),
                                    //               child: Text('$likeCount',
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 )),
                                    //               ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }, childCount: 6),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        )),
                        SliverToBoxAdapter(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Image.asset('lib/assets/dance.png', height: 38),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text('ENTERTAINMENT', style: TextThemes.extraBold),
                          ),
                        ],
                      ),
                    )),
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          DocumentSnapshot course =
                              snapshot.data.documents[index];
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

                          if (uidArray != null &&
                              uidArray.contains(strUserId)) {
                            _isPressed = true;
                          } else {
                            _isPressed = false;
                          }

                          return Card(
                            color: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => PostDetail(
                                                course['image'],
                                                course['title'],
                                                course['description'],
                                                course['startDate'],
                                                course['location'],
                                                course['address'],
                                                course['profilePic'],
                                                course['userName'],
                                                course['userEmail'],
                                                likedArray,
                                                course.documentID)));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                              course['title'].toString(),
                                              style: TextStyle(
                                                  color: Colors.blue[900],
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                          color: Color(0xff000000),
                                          width: 1,
                                        )),
                                        child: Image.network(course['image'],
                                            fit: BoxFit.cover,
                                            height: 75,
                                            width: 110),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0, top: 4.0),
                                            child: CircleAvatar(
                                              radius: 8.0,
                                              backgroundImage: NetworkImage(
                                                course['profilePic'],
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 6.0, left: 12, right: 2),
                                            child: Icon(Icons.timer,
                                                color: TextThemes.ndGold,
                                                size: 15),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Text(
                                                DateFormat('MMMd')
                                                    .add_jm()
                                                    .format(course['startDate']
                                                        .toDate()),
                                                style: TextStyle(
                                                  fontSize: 9.0,
                                                )),
                                          )
                                        ],
                                      )
                                    ],

                                    // children: [
                                    //   ListTile(
                                    //     title: Row(children: <Widget>[
                                    //       Expanded(
                                    //           child: Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       top: 5.0,
                                    //                       right: 5,
                                    //                       bottom: 5),
                                    //               child: Container(
                                    //                 decoration: BoxDecoration(
                                    //                     border: Border.all(
                                    //                   color: Color(0xff000000),
                                    //                   width: 1,
                                    //                 )),
                                    //                 child: Image.network(
                                    //                     course['image'],
                                    //                     fit: BoxFit.cover,
                                    //                     height: 130,
                                    //                     width: 50),
                                    //               ))),
                                    //       Expanded(
                                    //           child: Column(children: <Widget>[
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(8.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(2.0),
                                    //             child: Text(
                                    //                 course['title'].toString(),
                                    //                 style: TextStyle(
                                    //                     color: Colors.blue[900],
                                    //                     fontSize: 20.0,
                                    //                     fontWeight:
                                    //                         FontWeight.bold),
                                    //                 textAlign:
                                    //                     TextAlign.center)),
                                    //         Padding(
                                    //           padding:
                                    //               const EdgeInsets.all(10.0),
                                    //           child: Text(
                                    //             course['description']
                                    //                 .toString(),
                                    //             textAlign: TextAlign.center,
                                    //             style: TextStyle(
                                    //                 fontSize: 12.0,
                                    //                 color: Colors.black
                                    //                     .withOpacity(0.6)),
                                    //           ),
                                    //         ),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(5.0)),
                                    //         Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(3.0),
                                    //             child: Row(
                                    //               mainAxisAlignment:
                                    //                   MainAxisAlignment.end,
                                    //               children: [
                                    //                 Text('START: ',
                                    //                     style: TextStyle(
                                    //                         fontSize: 12.0,
                                    //                         fontWeight:
                                    //                             FontWeight
                                    //                                 .bold)),
                                    //                 Text(
                                    //                     DateFormat('MMMd')
                                    //                         .add_jm()
                                    //                         .format(course[
                                    //                                 'startDate']
                                    //                             .toDate()),
                                    //                     style: TextStyle(
                                    //                       fontSize: 12.0,
                                    //                     )),
                                    //               ],
                                    //             )),
                                    //       ]))
                                    //     ]),
                                    //   ),
                                    //   Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //         horizontal: 1.0),
                                    //     child: Container(
                                    //       height: 1.0,
                                    //       width: 500.0,
                                    //       color: Colors.grey[300],
                                    //     ),
                                    //   ),
                                    //   Container(
                                    //       child: Row(
                                    //     children: [
                                    //       Padding(
                                    //           padding:
                                    //               const EdgeInsets.fromLTRB(
                                    //                   12, 10, 4, 10),
                                    //           child: CircleAvatar(
                                    //             radius: 22.0,
                                    //             backgroundImage: NetworkImage(
                                    //                 course['profilePic']),
                                    //             backgroundColor:
                                    //                 Colors.transparent,
                                    //           )),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.start,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userName'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 14,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       left: 2.0),
                                    //               child: Text(
                                    //                   course['userEmail'],
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       Spacer(),
                                    //       Container(
                                    //         child: Column(
                                    //           //  mainAxisAlignment: MainAxisAlignment.start,
                                    //           crossAxisAlignment:
                                    //               CrossAxisAlignment.end,
                                    //           children: [
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 8.0),
                                    //               child: IconButton(
                                    //                 icon: (_isPressed)
                                    //                     ? new Icon(
                                    //                         Icons
                                    //                             .directions_run,
                                    //                         color: Colors.green)
                                    //                     : new Icon(Icons
                                    //                         .directions_walk),
                                    //                 color: Colors.red,
                                    //                 iconSize: 30.0,
                                    //                 splashColor: Colors.green,
                                    //                 //splashRadius: 7.0,
                                    //                 highlightColor:
                                    //                     Colors.green,
                                    //                 onPressed: () {
                                    //                   // Perform action
                                    //                   setState(() {
                                    //                     List<dynamic>
                                    //                         likedArray =
                                    //                         course["liked"];
                                    //                     List<String> uidArray =
                                    //                         List<String>();
                                    //                     if (likedArray !=
                                    //                         null) {
                                    //                       likeCount =
                                    //                           likedArray.length;
                                    //                       for (int i = 0;
                                    //                           i < likeCount;
                                    //                           i++) {
                                    //                         var id =
                                    //                             likedArray[i]
                                    //                                 ["uid"];
                                    //                         uidArray.add(id);
                                    //                       }
                                    //                     }

                                    //                     if (uidArray != null &&
                                    //                         uidArray.contains(
                                    //                             strUserId)) {
                                    //                       Database().removeGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                     } else {
                                    //                       Database().addGoing(
                                    //                           course["userId"],
                                    //                           course["image"],
                                    //                           strUserId,
                                    //                           course.documentID,
                                    //                           strUserName,
                                    //                           strUserPic,
                                    //                           course[
                                    //                               "startDate"],
                                    //                           course["title"],
                                    //                           course[
                                    //                               "description"],
                                    //                           course[
                                    //                               "location"],
                                    //                           course["address"],
                                    //                           course[
                                    //                               "profilePic"],
                                    //                           course[
                                    //                               "userName"],
                                    //                           course[
                                    //                               "userEmail"],
                                    //                           course["liked"]);
                                    //                       print(
                                    //                         course["userId"],
                                    //                       );
                                    //                     }
                                    //                   });
                                    //                 },
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.only(
                                    //                       right: 10.0,
                                    //                       bottom: 4.0),
                                    //               child: Text(
                                    //                 'Going?',
                                    //                 style:
                                    //                     TextStyle(fontSize: 12),
                                    //               ),
                                    //             ),
                                    //             Padding(
                                    //               padding:
                                    //                   const EdgeInsets.fromLTRB(
                                    //                       0, 0, 30.0, 10),
                                    //               child: Text('$likeCount',
                                    //                   style: TextStyle(
                                    //                       fontSize: 12,
                                    //                       color:
                                    //                           TextThemes.ndBlue,
                                    //                       decoration:
                                    //                           TextDecoration
                                    //                               .none)),
                                    //                           ),
                                    //                         ],
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 )),
                                    //               ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }, childCount: 6),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        )),
                        
                  ],
                )),
              ],
            ),
          );
        });
  }
}
