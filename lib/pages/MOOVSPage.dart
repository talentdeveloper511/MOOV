import 'dart:async';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/edit_post.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/send_moov.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage>
    with SingleTickerProviderStateMixin {
  GlobalKey _myPostsKey = GlobalKey();
  GlobalKey _goingKey = GlobalKey();
  // TabController to control and switch tabs
  TabController _tabController;
  dynamic moovId;
  String type;
  var todayOnly = 0;

  // Current Index of tab
  int _currentIndex = 1;

  String text = 'https://www.whatsthemoov.com';
  String subject = 'Check out MOOV. You get paid to download!';
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;

  bool _isPressed;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowCase() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus = preferences.getBool("displayShowCase3");
      if (showCaseVisibilityStatus == null) {
        preferences.setBool("displayShowCase3", false);
        return true;
      }
      return false;
    }

    displayShowCase().then((status) {
      if (status) {
        Timer(Duration(seconds: 1), () {
          ShowCaseWidget.of(context).startShowCase([_myPostsKey, _goingKey]);
        });
      }
    });

    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: TextThemes.ndBlue,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(1.0, 1.0),
                    ),
                  ],
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Sign In Button
                    Showcase(
                      key: _myPostsKey,
                      title: "YOUR POSTS",
                      description:
                          "\nHere's where your own posts will be — until they expire",
                      titleTextStyle: TextStyle(
                          color: TextThemes.ndBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      descTextStyle: TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: EdgeInsets.all(10),
                      shapeBorder: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: new FlatButton(
                        color: _currentIndex == 0
                            ? Colors.blue[100]
                            : Colors.white,
                        onPressed: () {
                          _tabController.animateTo(0);
                          setState(() {
                            _currentIndex = 0;
                          });
                        },
                        child: new Text("My Posts"),
                      ),
                    ),
                    // Sign Up Button
                    Showcase(
                      key: _goingKey,
                      title: "YOU STILL DOWN?",
                      description:
                          "\nMOOVs you are \"going\" to will feed here ",
                      titleTextStyle: TextStyle(
                          color: TextThemes.ndBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      descTextStyle: TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: EdgeInsets.all(10),
                      shapeBorder: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: new FlatButton(
                        color: _currentIndex == 1
                            ? Colors.blue[100]
                            : Colors.white,
                        onPressed: () {
                          _tabController.animateTo(1);
                          setState(() {
                            _currentIndex = 1;
                          });
                        },
                        child: new Text("Going"),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    // Restrict scroll by user
                    children: [
                  StreamBuilder(
                      stream: postsRef
                          .where("userId", isEqualTo: currentUser.id)
                          // .orderBy("startDate")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                              child: Text(
                                  "You have no posts. \n\nGo post the MOOV!",
                                  style: TextStyle(fontSize: 20)));
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            Map<String, dynamic> statuses = course['statuses'];
                            List<dynamic> statusesIds = statuses.keys.toList();
                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            bool hide = false;
                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] != 3) {
                                    hide = true;
                                  }
                                }
                              }
                            }

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Database().deletePost(
                                  course['postId'],
                                  course['userId'],
                                  course['title'],
                                  course['statuses'],
                                  course['posterName']);
                            }
                            final now = DateTime.now();
                            bool isToday = false;
                            bool isTomorrow = false;

                            final today =
                                DateTime(now.year, now.month, now.day);
                            final yesterday =
                                DateTime(now.year, now.month, now.day - 1);
                            final tomorrow =
                                DateTime(now.year, now.month, now.day + 1);

                            final dateToCheck = startDate.toDate();
                            final aDate = DateTime(dateToCheck.year,
                                dateToCheck.month, dateToCheck.day);

                            if (aDate == today) {
                              isToday = true;
                            } else if (aDate == tomorrow) {
                              isTomorrow = true;
                            }

                            if (isToday == false && todayOnly == 1) hide = true;

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Container();
                          },
                        );
                      }),
                  StreamBuilder(
                      stream: postsRef
                          .where("going", arrayContains: currentUser.id)
                          .orderBy("startDate")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("You're not going to any MOOVs!",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );
                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];

                            var strUserPic = currentUser.photoUrl;

                            bool hide = false;
                            // var y = startDate;
                            // var x = Timestamp.now();
                            // print(x.toDate());
                            // print(y.toDate());

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Database().deletePost(
                                  course['postId'],
                                  course['userId'],
                                  course['title'],
                                  course['statuses'],
                                  course['posterName']);
                            }
                            final now = DateTime.now();
                            bool isToday = false;
                            bool isTomorrow = false;

                            final today =
                                DateTime(now.year, now.month, now.day);
                            final yesterday =
                                DateTime(now.year, now.month, now.day - 1);
                            final tomorrow =
                                DateTime(now.year, now.month, now.day + 1);

                            final dateToCheck = startDate.toDate();
                            final aDate = DateTime(dateToCheck.year,
                                dateToCheck.month, dateToCheck.day);

                            if (aDate == today) {
                              isToday = true;
                            } else if (aDate == tomorrow) {
                              isTomorrow = true;
                            }

                            if (isToday == false && todayOnly == 1) hide = true;

                            if (!course['going'].contains(currentUser.id)) {
                              hide = true;
                            }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Container();
                          },
                        );
                      }),
                ]))
          ])),
    );

    // FloatingActionButton.extended(
    //     onPressed: () {
    //       // Add your onPressed code here!
    //     },
    //     label: Text('Find a MOOV',
    //         style: TextStyle(color: Colors.white)),
    //     icon: Icon(Icons.search, color: Colors.white),
    //     backgroundColor: Color.fromRGBO(220, 180, 57, 1.0))
  }

  void showAlertDialog(
      BuildContext context, postId, userId, title, statuses, posterName) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Delete?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nRemove this post from the feed?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Database()
                  .deletePost(postId, userId, title, statuses, posterName);
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
}
