import 'dart:async';

import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/edit_post.dart';
import 'package:MOOV/pages/friend_finder.dart';
import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/progress.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
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
    String userId = currentUser.friendArray[0];

    bool isIncognito = false;
    bool friendFinderVisibility = true;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
                  child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Friends' Plans", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: TextThemes.ndBlue),),
               IconButton(
                                            padding: EdgeInsets.only(
                                                left: 0,
                                                right: 0,
                                                bottom: 15,
                                                top: 5),
                                            icon: Image.asset(
                                                'lib/assets/ff.png'),
                                            color: Colors.white,
                                            splashColor: Color.fromRGBO(
                                                220, 180, 57, 1.0),
                                          ), 
                ],
              ),
              Divider(
                color: TextThemes.ndBlue,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
              StreamBuilder(
                  stream: usersRef.doc(userId).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return circularProgress();
                    isIncognito = snapshot.data['privacySettings']['incognito'];
                    friendFinderVisibility = snapshot.data['privacySettings']
                        ['friendFinderVisibility'];

                    return Stack(children: [
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 130,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (userId == currentUser.id) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePageWithHeader()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherProfile(
                                                      userId,
                                                    )));
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  snapshot.data['photoUrl']),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FittedBox(
                                            child: Text(
                                              snapshot.data['displayName'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: TextThemes.ndBlue,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: isIncognito || !friendFinderVisibility
                                      ? 50
                                      : 0),
                              Container(
                                  decoration:
                                      isIncognito || !friendFinderVisibility
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              color: Colors.black,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 20.0,
                                                  offset: Offset(5.0, 5.0),
                                                ),
                                              ],
                                            )
                                          : null,
                                  child: isIncognito || !friendFinderVisibility
                                      ? Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Row(children: [
                                            Image.asset(
                                              'lib/assets/incognito.png',
                                              height: 20,
                                            ),
                                            Text(" Incognito",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold))
                                          ]),
                                        )
                                      : Text("is going to")),
                              Container(
                                  child: StreamBuilder(
                                      stream: postsRef
                                          .where('going', arrayContains: userId)
                                          .orderBy("startDate")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Center(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: isIncognito ||
                                                    !friendFinderVisibility
                                                ? Text("")
                                                : Text("nothing, right now."),
                                          ));
                                        if ((!snapshot.hasData ||
                                                snapshot.data.docs.length == 0) &&
                                            (!isIncognito ||
                                                !friendFinderVisibility))
                                          return SizedBox(
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: !isLargePhone
                                                        ? const EdgeInsets.all(
                                                            4.0)
                                                        : EdgeInsets.all(2.0),
                                                    child: Text(
                                                        "nothing, right now."),
                                                  )),
                                              width: isLargePhone
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.51
                                                  : isIncognito ||
                                                          !friendFinderVisibility
                                                      ? 0
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.49,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.15);
                                        var course = snapshot.data.docs[0];
                                        Timestamp startDate = course["startDate"];
                                        bool hide = false;

                                        final now = DateTime.now();
                                        bool isToday = false;
                                        bool isTomorrow = false;
                                        bool isBoth = false;
                                        bool isEither = false;

                                        bool isNextWeek = false;

                                        final today = DateTime(
                                            now.year, now.month, now.day);
                                        final yesterday = DateTime(
                                            now.year, now.month, now.day - 1);
                                        final tomorrow = DateTime(
                                            now.year, now.month, now.day + 1);
                                        final week = DateTime(
                                            now.year, now.month, now.day + 6);

                                        final dateToCheck = startDate.toDate();
                                        final aDate = DateTime(dateToCheck.year,
                                            dateToCheck.month, dateToCheck.day);

                                        if (aDate == today) {
                                          isToday = true;
                                        } else if (aDate == tomorrow) {
                                          isTomorrow = true;
                                        }
                                        if (isToday == false && todayOnly == 1) {
                                          hide = true;
                                        }

                                        if (isIncognito == true ||
                                            friendFinderVisibility == false) {
                                          hide = true;
                                        }
                                        if (course['privacy'] == "Invite Only") {
                                          hide = true;
                                        }

                                        return (hide == false)
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              (PostDetail(course[
                                                                  'postId']))));
                                                },
                                                child: Stack(
                                                    alignment: Alignment.center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: isLargePhone
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.51
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.49,
                                                        height: isLargePhone
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.15
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.17,
                                                        child: Container(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(10),
                                                            child:
                                                                CachedNetworkImage(
                                                              imageUrl:
                                                                  course['image'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                          margin: EdgeInsets.only(
                                                              left: 20,
                                                              top: 0,
                                                              right: 20,
                                                              bottom: 7.5),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius.all(
                                                              Radius.circular(10),
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                spreadRadius: 5,
                                                                blurRadius: 7,
                                                                offset: Offset(0,
                                                                    3), // changes position of shadow
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20)),
                                                          gradient:
                                                              LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: <Color>[
                                                              Colors.black
                                                                  .withAlpha(0),
                                                              Colors.black,
                                                              Colors.black12,
                                                            ],
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(
                                                                maxWidth: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .3),
                                                            child: Text(
                                                              snapshot.data
                                                                      .docs[0]
                                                                  ['title'],
                                                              maxLines: 2,
                                                              textAlign: TextAlign
                                                                  .center,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Solway',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      isLargePhone
                                                                          ? 17.0
                                                                          : 14),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      isToday == false
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 30,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors
                                                                                .pink[400],
                                                                            Colors
                                                                                .purple[300]
                                                                          ],
                                                                          begin: Alignment
                                                                              .centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0)),
                                                                child: isNextWeek
                                                                    ? Text(
                                                                        DateFormat(
                                                                                'MMM d')
                                                                            .add_jm()
                                                                            .format(
                                                                                course['startDate'].toDate()),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18),
                                                                      )
                                                                    : Text(
                                                                        DateFormat(
                                                                                'EEE')
                                                                            .add_jm()
                                                                            .format(
                                                                                course['startDate'].toDate()),
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .white,
                                                                            fontSize:
                                                                                18),
                                                                      ),
                                                              ),
                                                            )
                                                          : Container(),
                                                      isToday == true
                                                          ? Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child: Container(
                                                                height: 30,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors
                                                                                .red[400],
                                                                            Colors
                                                                                .red[600]
                                                                          ],
                                                                          begin: Alignment
                                                                              .centerLeft,
                                                                          end: Alignment
                                                                              .centerRight,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10.0)),
                                                                child: Text(
                                                                  DateFormat(
                                                                          'EEE')
                                                                      .add_jm()
                                                                      .format(course[
                                                                              'startDate']
                                                                          .toDate()),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                            )
                                                          : Text(""),
                                                    ]),
                                              )
                                            : isIncognito ||
                                                    !friendFinderVisibility
                                                ? Text("")
                                                : SizedBox(
                                                    width: isLargePhone
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.51
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.49,
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.15,
                                                    child: Align(
                                                        alignment:
                                                            Alignment.centerLeft,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 2.0),
                                                          child: Text(
                                                              "no MOOVs, right now."),
                                                        )),
                                                  );
                                      }))
                            ]),
                      ),
                      Positioned(
                          right: 20,
                          bottom: 15,
                          child: GestureDetector(
                            onTap: (){
                                   Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendFinder()));
                            },
                              child: Text(
                            "View more",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          )))
                    ]);
                  }),
                  SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Friend Groups ",style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: TextThemes.ndBlue),),
                   IconButton(
                                          padding: EdgeInsets.only(left: 5.0, top:5, bottom: 10),
                                          icon:
                                              Image.asset('lib/assets/fg1.png'),
                                          splashColor:
                                              Color.fromRGBO(220, 180, 57, 1.0),
                                        ),
                      ],
                    ),
              Divider(
                color: TextThemes.ndBlue,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),

                  Container(height: 200,
                    child: StreamBuilder(
              stream: groupsRef
                    .where('members', arrayContains: currentUser.id)
                    .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data.docs.length == 0) {
                    return Container( );
                }

                return Stack(
                                  children: [Container(
                      // height: (snapshot.data.documents.length <= 3) ? 270 : 400,
                      child: Column(
                        children: [
                          Expanded(
                              child: CustomScrollView(
                                physics: NeverScrollableScrollPhysics(),
                            slivers: [
                            
                              SliverGrid(
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();
                                    if (snapshot.data.docs.length == 0) {
                                      return Container();
                                    }

                                    DocumentSnapshot course =
                                        snapshot.data.docs[index];
                                    var length = course['members'].length - 2;
                                    String groupId = course['groupId'];

                                    // var rng = new Random();
                                    // var l = rng.nextInt(course['members'].length);
                                    // print(l);
                                    // print(course['groupName']);

                                    return StreamBuilder(
                                        stream: usersRef
                                            .where('friendGroups',
                                                arrayContains: groupId)
                                            .snapshots(),
                                        builder: (context, snapshot3) {
                                          if (!snapshot3.hasData)
                                            return CircularProgressIndicator();
                                          if (snapshot3.hasError ||
                                              snapshot3.data == null)
                                            return CircularProgressIndicator();

                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              // color: Colors.white,
                                              clipBehavior: Clip.none,
                                              child: Stack(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GroupDetail(
                                                                      groupId)));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.only(
                                                                  bottom: 5.0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.all(
                                                                        Radius
                                                                            .circular(
                                                                                20)),
                                                                border: Border.all(
                                                                  color: TextThemes
                                                                      .ndBlue,
                                                                  width: 3,
                                                                )),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.all(
                                                                      Radius.circular(
                                                                          15)),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: course[
                                                                    'groupPic'],
                                                                fit: BoxFit.cover,
                                                                height: isLargePhone
                                                                    ? MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height *
                                                                        0.11
                                                                    : MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .height *
                                                                        0.13,
                                                                width: isLargePhone
                                                                    ? MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.35
                                                                    : MediaQuery.of(
                                                                                context)
                                                                            .size
                                                                            .width *
                                                                        0.35,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                  12.5),
                                                          child: Center(
                                                            child: FittedBox(
                                                              child: Text(
                                                                course['groupName']
                                                                    .toString(),
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    color:
                                                                        Colors.black,
                                                                    fontSize:
                                                                        isLargePhone
                                                                            ? 20.0
                                                                            : 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign.center,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: isLargePhone ? 80 : 70,
                                                    right: 20,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Stack(children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: course['members']
                                                                          .length >
                                                                      1
                                                                  ? CircleAvatar(
                                                                      radius: 20.0,
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                        snapshot3.data
                                                                                .docs[1]
                                                                            [
                                                                            'photoUrl'],
                                                                      ),
                                                                    )
                                                                  : Container()),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 4,
                                                                      left: 20.0),
                                                              child: CircleAvatar(
                                                                radius: 20.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  snapshot3.data
                                                                          .docs[0]
                                                                      ['photoUrl'],
                                                                ),
                                                              )),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets.only(
                                                                    top: 4,
                                                                    left: 40.0),
                                                            child: CircleAvatar(
                                                              radius: 20.0,
                                                              child: course['members']
                                                                          .length >
                                                                      2
                                                                  ? Text(
                                                                      "+" +
                                                                          (length
                                                                              .toString()),
                                                                      style: TextStyle(
                                                                          color: TextThemes
                                                                              .ndGold,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    )
                                                                  : Text(
                                                                      (course['members']
                                                                          .length
                                                                          .toString()),
                                                                      style: TextStyle(
                                                                          color: TextThemes
                                                                              .ndGold,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500),
                                                                    ),
                                                              backgroundColor:
                                                                  TextThemes.ndBlue,
                                                            ),
                                                          ),
                                                        ])
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  }, childCount: 2),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                  )),
                            ],
                          )),
                        ],
                      ),
                  ),
                  Positioned(
                          right: 20,
                          bottom: 15,
                          child: GestureDetector(
                            onTap: (){
                                   Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FriendGroupsPage()));
                            },
                              child: Text(
                            "View more",
                            style: TextStyle(
                                color: Colors.blue, fontWeight: FontWeight.bold),
                          )))]
                );
              }),
                  )
            ],
          ),
        ));

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
