import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';

import 'package:MOOV/helpers/themes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
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
    bool isLargePhone = Screen.diagonal(context) > 766;

    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    var height = 400;
    dynamic likeCount;

    return Container(
      color: Colors.grey[100],
      child: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pinkAccent[200], TextThemes.ndBlue])),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('T R E N D I N G',
                    style: GoogleFonts.sriracha(
                        color: Colors.white, fontSize: 30)),
              ))),
          Expanded(
            child: ListView(children: [
              Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('food')
                        .where('type', isEqualTo: 'Restaurants & Bars')
                        .where('privacy', isEqualTo: "Public")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');
                      return Container(
                        height: (snapshot.data.docs.length <= 3) ? 210 : 400,
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
                                      Image.asset('lib/assets/plate.png',
                                          height: 40),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('Restaurants & Bars',
                                            style: TextThemes.extraBold),
                                      ),
                                    ],
                                  ),
                                )),
                                SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      DocumentSnapshot course =
                                          snapshot.data.docs[index];

                                      return PostOnTrending(course);
                                    }, childCount: snapshot.data.docs.length),
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
                    stream: FirebaseFirestore.instance
                        .collection('food')
                        .where('type', isEqualTo: "Pregames & Parties")
                        .where('privacy', isEqualTo: "Public")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');

                      return Container(
                        height: (snapshot.data.docs.length <= 3) ? 270 : 345,
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
                                      Image.asset('lib/assets/dance.png',
                                          height: 40),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('Pregames & Parties',
                                            style: TextThemes.extraBold),
                                      ),
                                    ],
                                  ),
                                )),
                                SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      DocumentSnapshot course =
                                          snapshot.data.docs[index];

                                      return PostOnTrending(course);
                                    }, childCount: snapshot.data.docs.length),
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
                    stream: FirebaseFirestore.instance
                        .collection('food')
                        .where('type', isEqualTo: 'Sport')
                        .orderBy('likeCounter', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text('');
                      return Container(
                        height: (snapshot.data.docs.length <= 3) ? 270 : 400,
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
                                      Image.asset('lib/assets/dance.png',
                                          height: 40),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('MORE',
                                            style: TextThemes.extraBold),
                                      ),
                                    ],
                                  ),
                                )),
                                SliverGrid(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                      DocumentSnapshot course =
                                          snapshot.data.docs[index];

                                      return PostOnTrending(course);
                                    }, childCount: snapshot.data.docs.length),
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
            ]),
          ),
        ],
      ),
    );
  }
}

class PostOnTrending extends StatelessWidget {
  DocumentSnapshot course;

  PostOnTrending(this.course);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Container(
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PostDetail(course.id)));
              },
              child: Column(
                children: [
                  Stack(alignment: Alignment.center, children: [
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: course['image'],
                        fit: BoxFit.cover,
                        height: isLargePhone
                            ? MediaQuery.of(context).size.height * 0.1226
                            : MediaQuery.of(context).size.height * 0.1432,
                        width: isLargePhone
                            ? MediaQuery.of(context).size.width * 0.315
                            : MediaQuery.of(context).size.width * 0.32,
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.0, 0.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.black.withAlpha(0),
                              Colors.black,
                              Colors.black12,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            course['title'],
                            maxLines: 1,
                            style: TextStyle(
                                fontFamily: 'Solway',
                                color: Colors.white,
                                fontSize: isLargePhone ? 12.0 : 10,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Container(

                    height: 21,
                    decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.pinkAccent[100], Colors.blue[100]])),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                        //   child: CircleAvatar(
                        //     radius: 8.0,
                        //     backgroundImage: NetworkImage(
                        //       course['profilePic'],
                        //     ),
                        //     backgroundColor: Colors.transparent,
                        //   ),
                        // ),
                       
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                              DateFormat('EEE')
                                  .add_jm()
                                  .format(course['startDate'].toDate()),
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700
                              )),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
