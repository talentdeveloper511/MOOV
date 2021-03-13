import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/widgets/group_carousel_card.dart';
import 'package:MOOV/widgets/hottestMOOV.dart';
import 'package:MOOV/widgets/poll2.dart';
import 'package:MOOV/widgets/post_card_new.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/suggestionBox.dart';
import 'package:animations/animations.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'dart:math' as math;

import 'friend_finder.dart';
import 'notification_feed.dart';

class HomePage extends StatefulWidget {
  User user;
  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
  static const IconData leaderboard_outlined =
      IconData(0xe26f, fontFamily: 'MaterialIcons');
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController _scrollController;
  AnimationController _hideFabAnimController;
  EasyRefreshController _controller;

  List<dynamic> likedArray;
  String eventprofile, title;

  @override
  bool get wantKeepAlive => true;

  TabController _tabController;
  dynamic moovId;
  String type;
  int todayOnly = 0;
  String privacy;

  // Current Index of tab
  int _currentIndex = 0;

  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;

  Widget getChildWidget() => childWidgets[selectedIndex];

  @override
  void dispose() {
    _tabController.dispose();

    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    _controller = EasyRefreshController();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1,
    );

    _tabController =
        TabController(vsync: this, length: 7, initialIndex: _currentIndex);
    _tabController.animation
      ..addListener(() {
        setState(() {
          _currentIndex = (_tabController.animation.value).round();
        });
      });
  }

  Future request() async => await Future.delayed(
      const Duration(seconds: 0), () => postsRef.orderBy("startDate").get());

  final privacyList = ["Featured", "All", "Private"];
  String privacyDropdownValue = 'Featured';

  Widget build(BuildContext context) {
    super.build(context);

    SizeConfig().init(context);
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .8,
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ListView(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: [
                              _currentIndex != 1
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(1);
                                        print(_currentIndex);

                                        setState(() {
                                          _currentIndex = 1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8, bottom: 5),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0),
                                              child: Image.asset(
                                                'lib/assets/icons/BarICON.png',
                                                height: 40,
                                                width: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0),
                                              child: Text(
                                                "Food/Drink",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(0);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, top: 8, bottom: 5),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/BarICON2.png',
                                              height: 44,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Text(
                                                "Food/Drink",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              _currentIndex != 2
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(2);
                                        print(_currentIndex);

                                        setState(() {
                                          _currentIndex = 2;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0, top: 4),
                                              child: Image.asset(
                                                'lib/assets/icons/PartyICON.png',
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 1.0),
                                              child: Text(
                                                "Parties",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(0);
                                        setState(() {
                                          _currentIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3.0, top: 4),
                                              child: Image.asset(
                                                'lib/assets/icons/PartyICON2.png',
                                                height: 50,
                                                width: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 1.0),
                                              child: Text(
                                                "Parties",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              _currentIndex != 3
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(3);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 3;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 15),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/ShowICON.png',
                                              height: 50,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Shows",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(0);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 5.0, right: 15),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/ShowICON2.png',
                                              height: 55,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0,
                                                  right: 8,
                                                  top: 3,
                                                  bottom: 2),
                                              child: Text(
                                                "Shows",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              _currentIndex != 4
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(4);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 4;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Image.asset(
                                              'lib/assets/icons/SportICON.png',
                                              height: 42,
                                              width: 50,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Sports",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        _tabController.animateTo(0);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 0;
                                          ;
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6.0),
                                            child: Image.asset(
                                              'lib/assets/icons/SportICON2.png',
                                              height: 45,
                                              width: 50,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 7.0,
                                                left: 8,
                                                right: 8,
                                                bottom: 0),
                                            child: Text(
                                              "Sports",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              _currentIndex != 5
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(5);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 5;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, top: 5),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/RecICON.png',
                                              height: 45,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Recreation",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(0);
                                        print(_currentIndex);
                                        setState(() {
                                          _currentIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: Image.asset(
                                                'lib/assets/icons/RecICON2.png',
                                                height: 45,
                                                width: 50,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0,
                                                  left: 8,
                                                  right: 8,
                                                  bottom: 0),
                                              child: Text(
                                                "Recreation",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                              _currentIndex != 6
                                  ? GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(6);
                                        setState(() {
                                          _currentIndex = 6;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, top: 5, right: 5),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/VirtualICON.png',
                                              height: 45,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0,
                                                  left: 8,
                                                  right: 10,
                                                  bottom: 0),
                                              child: Text(
                                                "Virtual",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();

                                        _tabController.animateTo(0);
                                        setState(() {
                                          _currentIndex = 0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, right: 5, top: 5),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              'lib/assets/icons/VirtualICON2.png',
                                              height: 45,
                                              width: 50,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 7.0,
                                                  left: 8,
                                                  right: 10,
                                                  bottom: 0),
                                              child: Text(
                                                "Virtual",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      ]),
                ),
                Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView(
                                physics: AlwaysScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(width: isLargePhone ? 47.5 : 40),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 2.0, left: 20, top: 1),
                                      child: todayOnly == 0
                                          ? RaisedButton(
                                              onPressed: () {
                                                HapticFeedback.lightImpact();

                                                setState(() {
                                                  todayOnly = 1;
                                                });
                                              },
                                              color: TextThemes.ndBlue,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Text('Today Only?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  isLargePhone
                                                                      ? 14
                                                                      : 12.5)),
                                                    ),
                                                    Icon(Icons.calendar_today,
                                                        size: 15,
                                                        color:
                                                            TextThemes.ndGold),
                                                  ],
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            )
                                          : RaisedButton(
                                              onPressed: () {
                                                setState(() {
                                                  todayOnly = 0;
                                                });
                                              },
                                              color: Colors.green,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 8.0),
                                                      child: Text('Today Only!',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  isLargePhone
                                                                      ? 14
                                                                      : 12.5)),
                                                    ),
                                                    Icon(Icons.check,
                                                        color:
                                                            TextThemes.ndGold),
                                                  ],
                                                ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0)),
                                            )),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 1),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          .29,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          canvasColor: TextThemes.ndBlue,
                                        ),
                                        child: ButtonTheme(
                                          height: 10,
                                          child: DropdownButtonFormField(
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    bottom: 8,
                                                    left: 10,
                                                    right: 5),
                                                border: UnderlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                  const Radius.circular(10.0),
                                                )),
                                                filled: true,
                                                hintStyle: TextStyle(
                                                    color: Colors.grey[800]),
                                                fillColor: TextThemes.ndBlue),
                                            style: isLargePhone
                                                ? TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)
                                                : TextStyle(
                                                    fontSize: 12.5,
                                                    color: Colors.white),
                                            value: privacyDropdownValue,
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: TextThemes.ndGold),
                                            items:
                                                privacyList.map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(
                                                  value,
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (String newValue) {
                                              HapticFeedback.lightImpact();

                                              setState(() {
                                                privacyDropdownValue = newValue;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                          )
                        ])),
                SizedBox(height: 5),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    FutureBuilder(
                      //THE DEFAULT NO FILTERS FEED
                      future: request(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container();
                        }

                        return EasyRefresh(
                          onRefresh: () async {
                            await Future.delayed(Duration(seconds: 1), () {
                              _controller.resetLoadState();
                            });
                          },
                          onLoad: () async {
                            await Future.delayed(Duration(seconds: 1), () {
                              _controller.finishLoad();
                            });
                          },
                          enableControlFinishRefresh: false,
                          enableControlFinishLoad: true,
                          controller: _controller,
                          header: BezierCircleHeader(
                              color: TextThemes.ndBlue,
                              backgroundColor: Colors.white),
                          footer:
                              BezierBounceFooter(backgroundColor: Colors.white),
                          bottomBouncing: false,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot course =
                                  snapshot.data.docs[index];
                              Timestamp startDate = course["startDate"];
                              privacy = course['privacy'];
                              Map<String, dynamic> statuses =
                                  (snapshot.data.docs[index]['statuses']);

                              int status = 0;
                              List<dynamic> statusesIds =
                                  statuses.keys.toList();

                              List<dynamic> statusesValues =
                                  statuses.values.toList();

                              if (statuses != null) {
                                for (int i = 0; i < statuses.length; i++) {
                                  if (statusesIds[i] == currentUser.id) {
                                    if (statusesValues[i] == 3) {
                                      status = 3;
                                    }
                                  }
                                }
                              }

                              bool hide = false;

                              if (startDate.millisecondsSinceEpoch <
                                  Timestamp.now().millisecondsSinceEpoch -
                                      3600000) {
                                print("Expired. See ya later.");
                                Future.delayed(
                                    const Duration(milliseconds: 1000), () {
                                  Database().deletePost(
                                      course['postId'],
                                      course['userId'],
                                      course['title'],
                                      course['statuses'],
                                      course['posterName']);
                                });
                              }
                              final now = DateTime.now();
                              bool isToday = false;
                              bool isTomorrow = false;

                              final today =
                                  DateTime(now.year, now.month, now.day);

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
                              if (course['featured'] != true &&
                                  privacyDropdownValue == "Featured") {
                                hide = true;
                              }
                              if (isToday == false && todayOnly == 1) {
                                hide = true;
                              }
                              if (privacy == "Friends Only" ||
                                  privacy == "Invite Only") {
                                hide = true;
                              }
                              if (privacyDropdownValue == "Private" &&
                                  (privacy != "Friends Only" ||
                                      privacy != "Invite Only")) {
                                hide = true;
                              }
                              if (privacy == "Friends Only" &&
                                  privacyDropdownValue == "Private" &&
                                  currentUser.friendArray
                                      .contains(course['userId'])) {
                                hide = false;
                              }
                              if (privacy == "Invite Only" &&
                                  privacyDropdownValue == "Private" &&
                                  course['statuses']
                                      .keys
                                      .contains(currentUser.id)) {
                                hide = false;
                              }

                              // if (course['featured'] != true) {
                              //   hide = true;
                              // }

                              if (index == 0) {
                                return Column(children: [
                                  Container(
                                    height: isLargePhone ? 190 : 160,
                                    child: MOTD(),
                                  ),
                                  SizedBox(height: 0),
                                  _currentIndex == 0 &&
                                          todayOnly == 0 &&
                                          privacyDropdownValue == 'Featured'
                                      ? CarouselSlider(
                                          options: CarouselOptions(
                                            height: 170,
                                            aspectRatio: 16 / 9,
                                            viewportFraction: 1,
                                            initialPage: 0,
                                            enableInfiniteScroll: true,
                                            // scrollPhysics: NeverScrollableScrollPhysics(),
                                            pauseAutoPlayOnTouch: false,
                                            reverse: false,
                                            autoPlay: true,
                                            autoPlayInterval:
                                                Duration(seconds: 6),
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 800),
                                            autoPlayCurve: Curves.fastOutSlowIn,
                                            enlargeCenterPage: true,
                                            // onPageChanged: callbackFunction,
                                            scrollDirection: Axis.horizontal,
                                          ),
                                          items: [
                                              PollView(),
                                              SuggestionBoxCarousel(),
                                              currentUser.friendGroups != null
                                                  ? GroupCarousel()
                                                  : null,
                                              HottestMOOV()
                                            ])
                                      : Container(),
                                ]);
                              }
                              return (hide == false)
                                  ? PostOnFeed(course)
                                  : Text("",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20));
                            },
                          ),
                        );
                      },
                    ),
                    FutureBuilder(
                      //Parties
                      future:
                          postsRef.where("type", isEqualTo: "Food/Drink").get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }

                            // if (course['featured'] != true) {
                            //   hide = true;
                            // }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                    FutureBuilder(
                      //Parties
                      future: postsRef
                          .where("type", isEqualTo: "Parties")
                          .orderBy("startDate")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }
                            // if (course['featured'] != true) {
                            //   hide = true;
                            // }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                    FutureBuilder(
                      future: postsRef
                          .where("type", isEqualTo: "Shows")
                          .orderBy("startDate")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }

                            // if (course['featured'] != true) {
                            //   hide = true;
                            // }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                    FutureBuilder(
                      //Sports
                      future: postsRef
                          .where("type", isEqualTo: "Sports")
                          .orderBy("startDate")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }

                            // if (course['featured'] != true) {
                            //   hide = true;
                            // }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                    FutureBuilder(
                      future: postsRef
                          .where("type", isEqualTo: "Recreation")
                          .orderBy("startDate")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }

                            if (course['userId'] == currentUser.id) {
                              hide = false;
                            }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                    FutureBuilder(
                      future: postsRef
                          .where("type", isEqualTo: "Virtual")
                          .orderBy("startDate")
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data.docs.length == 0)
                          return Center(
                            child: Text("",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );

                        return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            Timestamp startDate = course["startDate"];
                            privacy = course['privacy'];
                            Map<String, dynamic> statuses =
                                (snapshot.data.docs[index]['statuses']);

                            int status = 0;
                            List<dynamic> statusesIds = statuses.keys.toList();

                            List<dynamic> statusesValues =
                                statuses.values.toList();

                            if (statuses != null) {
                              for (int i = 0; i < statuses.length; i++) {
                                if (statusesIds[i] == currentUser.id) {
                                  if (statusesValues[i] == 3) {
                                    status = 3;
                                  }
                                }
                              }
                            }

                            bool hide = false;

                            if (startDate.millisecondsSinceEpoch <
                                Timestamp.now().millisecondsSinceEpoch -
                                    3600000) {
                              print("Expired. See ya later.");
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                Database().deletePost(
                                    course['postId'],
                                    course['userId'],
                                    course['title'],
                                    course['statuses'],
                                    course['posterName']);
                              });
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
                            if (isToday == false && todayOnly == 1) {
                              hide = true;
                            }
                            if (course['featured'] != true &&
                                privacyDropdownValue == "Featured") {
                              hide = true;
                            }
                            if (privacy == "Friends Only" ||
                                privacy == "Invite Only") {
                              hide = true;
                            }
                            if (privacyDropdownValue == "Private" &&
                                (privacy != "Friends Only" ||
                                    privacy != "Invite Only")) {
                              hide = true;
                            }
                            if (privacy == "Friends Only" &&
                                privacyDropdownValue == "Private" &&
                                currentUser.friendArray
                                    .contains(course['userId'])) {
                              hide = false;
                            }
                            if (privacy == "Invite Only" &&
                                privacyDropdownValue == "Private" &&
                                course['statuses']
                                    .keys
                                    .contains(currentUser.id)) {
                              hide = false;
                            }

                            if (course['userId'] == currentUser.id) {
                              hide = false;
                            }

                            return (hide == false)
                                ? PostOnFeed(course)
                                : Text("",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20));
                          },
                        );
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
    // return MaterialApp(
    //   home: Scaffold(
    //     backgroundColor: CupertinoColors.lightBackgroundGray,
    //     appBar: MyAppBar(
    //         title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         Image.asset(
    //           'lib/assets/moovheader.png',
    //           fit: BoxFit.cover,
    //           height: 45.0,
    //         ),
    //         Image.asset(
    //           'lib/assets/ndlogo.png',
    //           fit: BoxFit.cover,
    //           height: 25,
    //         )
    //       ],
    //     )),
    //     body: Container(
    //       decoration:
    //           BoxDecoration(color: CupertinoColors.extraLightBackgroundGray),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.max,
    //         children: <Widget>[
    //           Expanded(flex: 5, child: Motd()),
    //           Expanded(flex: 5, child: _FirstRow()),
    //           Expanded(flex: 5, child: _SecondRow()),
    //           Expanded(flex: 1, child: _HaveMOOVButton()),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class Category extends StatelessWidget {
  String type;
  int todayOnly;
  String privacyDropdownValue;

  Category(String type, int todayOnly, String privacyDropDownValue);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsRef.where("type", isEqualTo: type).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.docs.length == 0)
          return Center(
            child: Text("",
                textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
          );

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot course = snapshot.data.docs[index];
            Timestamp startDate = course["startDate"];
            String privacy = course['privacy'];
            Map<String, dynamic> statuses =
                (snapshot.data.docs[index]['statuses']);

            int status = 0;
            List<dynamic> statusesIds = statuses.keys.toList();

            List<dynamic> statusesValues = statuses.values.toList();

            if (statuses != null) {
              for (int i = 0; i < statuses.length; i++) {
                if (statusesIds[i] == currentUser.id) {
                  if (statusesValues[i] == 3) {
                    status = 3;
                  }
                }
              }
            }

            bool hide = false;

            if (startDate.millisecondsSinceEpoch <
                Timestamp.now().millisecondsSinceEpoch - 3600000) {
              print("Expired. See ya later.");
              Future.delayed(const Duration(milliseconds: 1000), () {
                Database().deletePost(course['postId'], course['userId'],
                    course['title'], course['statuses'], course['posterName']);
              });
            }
            final now = DateTime.now();
            bool isToday = false;
            bool isTomorrow = false;

            final today = DateTime(now.year, now.month, now.day);
            final tomorrow = DateTime(now.year, now.month, now.day + 1);

            final dateToCheck = startDate.toDate();
            final aDate =
                DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

            if (aDate == today) {
              isToday = true;
            } else if (aDate == tomorrow) {
              isTomorrow = true;
            }
            if (isToday == false && todayOnly == 1) {
              hide = true;
            }
            if (course['featured'] != true &&
                privacyDropdownValue == "Featured") {
              hide = true;
            }
            if (privacy == "Friends Only" || privacy == "Invite Only") {
              hide = true;
            }
            if (privacy == "Friends Only" || privacy == "Invite Only") {
              hide = true;
            }
            if (privacyDropdownValue == "Private" &&
                privacy != "Friends Only") {
              hide = true;
            }
            if (privacy == "Friends Only" &&
                privacyDropdownValue == "Private" &&
                !currentUser.friendArray.contains(course['userId'])) {
              hide = true;
            }

            // if (course['featured'] != true) {
            //   hide = true;
            // }

            return (hide == false)
                ? PostOnFeed(course)
                : Text("",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20));
          },
        );
      },
    );
  }
}
