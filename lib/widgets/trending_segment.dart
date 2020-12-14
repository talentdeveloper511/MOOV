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
    var height = 400;
    dynamic likeCount;

    return ListView(children: [
      Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('food')
                .where('type', isEqualTo: 'Food')
                .orderBy('likeCounter', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('Loading data...');
              return Container(
                height: (snapshot.data.documents.length <= 3) ? 270 : 400,
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
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset('lib/assets/plate.png', height: 40),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child:
                                    Text('FOOD', style: TextThemes.extraBold),
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
                                                builder: (context) =>
                                                    PostDetail(
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
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: Color(0xff000000),
                                              width: 1,
                                            )),
                                            child: Image.network(
                                                course['image'],
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
                                                    top: 6.0,
                                                    left: 12,
                                                    right: 2),
                                                child: Icon(Icons.timer,
                                                    color: TextThemes.ndGold,
                                                    size: 15),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Text(
                                                    DateFormat('MMMd')
                                                        .add_jm()
                                                        .format(
                                                            course['startDate']
                                                                .toDate()),
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }, childCount: snapshot.data.documents.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            )),
                      ],
                    )),
                  ],
                ),
              );
            }),
      ),
      Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('food')
                .where('type', isEqualTo: 'Party')
                .orderBy('likeCounter', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('');
              return Container(
                height: (snapshot.data.documents.length <= 3) ? 205 : 400,
                child: Column(
                  children: [
                    Expanded(
                        child: CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset('lib/assets/dance.png', height: 40),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('PARTIES',
                                    style: TextThemes.extraBold),
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
                                                builder: (context) =>
                                                    PostDetail(
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
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: Color(0xff000000),
                                              width: 1,
                                            )),
                                            child: Image.network(
                                                course['image'],
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
                                                    top: 6.0,
                                                    left: 12,
                                                    right: 2),
                                                child: Icon(Icons.timer,
                                                    color: TextThemes.ndGold,
                                                    size: 15),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Text(
                                                    DateFormat('MMMd')
                                                        .add_jm()
                                                        .format(
                                                            course['startDate']
                                                                .toDate()),
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }, childCount: snapshot.data.documents.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            )),
                      ],
                    )),
                  ],
                ),
              );
            }),
      ),
      Container(
        child: StreamBuilder(
            stream: Firestore.instance
                .collection('food')
                .where('type', isEqualTo: 'Sport')
                .orderBy('likeCounter', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text('');
              return Container(
                height: (snapshot.data.documents.length <= 3) ? 270 : 400,
                child: Column(
                  children: [
                    Expanded(
                        child: CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Image.asset('lib/assets/dance.png', height: 40),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child:
                                    Text('MORE', style: TextThemes.extraBold),
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
                                                builder: (context) =>
                                                    PostDetail(
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
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: Color(0xff000000),
                                              width: 1,
                                            )),
                                            child: Image.network(
                                                course['image'],
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
                                                    top: 6.0,
                                                    left: 12,
                                                    right: 2),
                                                child: Icon(Icons.timer,
                                                    color: TextThemes.ndGold,
                                                    size: 15),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: Text(
                                                    DateFormat('MMMd')
                                                        .add_jm()
                                                        .format(
                                                            course['startDate']
                                                                .toDate()),
                                                    style: TextStyle(
                                                      fontSize: 9.0,
                                                    )),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }, childCount: snapshot.data.documents.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            )),
                      ],
                    )),
                  ],
                ),
              );
            }),
      ),
    ]);
  }
}
