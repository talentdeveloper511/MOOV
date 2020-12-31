import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';
import 'MorePage.dart';

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

class MyAppBar extends AppBar {
  MyAppBar({Key key, Widget title})
      : super(
            key: key,
            title: title,
            backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.search),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Search');
                },
              ),
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.message),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Message');
                },
              )
            ]);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _hideFabAnimController;
  List<dynamic> likedArray;
  String eventprofile, title;

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1,
    );

    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    SizeConfig().init(context);
    bool isLargePhone = Screen.diagonal(context) > 720;
    bool isNarrow = Screen.widthInches(context) < 3.5;

    // final GoogleSignInAccount user = googleSignIn.currentUser;
    // final strUserId = user.id;
    var userFriends;

    Future navigateToCategoryFeed(context, type) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CategoryFeed(type: type)));
    }

    return Scaffold(
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child: ScaleTransition(
          scale: _hideFabAnimController,
          child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: MoovMaker(postModel: PostModel())));
              },
              label: const Text("Post the MOOV",
                  style: TextStyle(fontSize: 20, color: Colors.white))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            leading: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset('lib/assets/ndlogo.png', height: 100),
            ),
            backgroundColor: TextThemes.ndBlue,
            //pinned: true,
            floating: true,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.insert_chart),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to leaderboard page here...
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LeaderBoardPage()));
                  print('Leaderboards clicked');
                },
              ),
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.notifications_active),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationFeed()));
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'lib/assets/moovblue.png',
                    fit: BoxFit.cover,
                    height: 55.0,
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 0, right: 0),
            sliver: SliverGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.25,
              children: <Widget>[
                Container(
                  child: MOTD(),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 20, right: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: isLargePhone ? 1.48 : 1.5,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(5.0),
                          icon: Image.asset('lib/assets/ff.png'),
                          color: Colors.white,
                          splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FriendFinder()));
                            // Implement navigation to shopping cart page here...
                            print('FRIEND FINDER CLICKED');
                          },
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FriendFinder()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Friend Finder",
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16.0),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(5.0),
                          icon: Image.asset('lib/assets/fg1.png'),
                          color: Colors.white,
                          splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FriendGroupsPage()));
                            // Implement navigation to shopping cart page here...
                            print('FRIEND GROUPS CLICKED');
                          },
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FriendGroupsPage()));
                                // Implement navigation to shopping cart page here...
                                print('FRIEND GROUPS CLICKED');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  "Friend Groups",
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 16.0),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10),
            sliver: SliverGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .95,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            navigateToCategoryFeed(context, "Food");
                          },
                          child: CategoryButton(asset: 'lib/assets/food5.png')),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Restaurants & Bars",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToCategoryFeed(context, "Party");
                        },
                        child: CategoryButton(asset: 'lib/assets/party2.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Pregames & Parties",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("No bullshit."),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  "Created by two students (ND '22 and ND '23), MOOV is ND's app \n \n We know how important privacy is. Only friends will see your data, and MOOVs disappear right after their start times. You are safe. This is your app. You define the experience."),
                            ),
                          ),
                      barrierDismissible: true);
                },
                child: Card(
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 20),
                  color: Color.fromRGBO(249, 249, 249, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2, top: 10),
                        child: RichText(
                          textScaleFactor: 1.75,
                          text:
                              TextSpan(style: TextThemes.mediumbody, children: [
                            TextSpan(
                                text: "This is",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                            TextSpan(text: " our ", style: TextThemes.italic),
                            TextSpan(
                                text: "app",
                                style: TextStyle(fontWeight: FontWeight.w400)),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: Center(
                          child: RichText(
                            textScaleFactor: 1.75,
                            text: TextSpan(
                                style: TextThemes.mediumbody,
                                children: [
                                  TextSpan(
                                      style: TextThemes.mediumbody,
                                      children: [
                                        TextSpan(
                                            text: "Only",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        TextSpan(
                                            text: " us ",
                                            style: TextThemes.italic),
                                        TextSpan(
                                            text: "and",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400)),
                                        TextSpan(
                                            text: " our ",
                                            style: TextThemes.italic),
                                        TextSpan(
                                            text: "local biz",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400))
                                      ]),
                                ]),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2, bottom: 10),
                          child: RichText(
                            textScaleFactor: 1.75,
                            text: TextSpan(
                                style: TextThemes.mediumbody,
                                children: [
                                  TextSpan(
                                      text: "Go ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400)),
                                  TextSpan(
                                      text: "Irish", style: TextThemes.italic),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .75,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            navigateToCategoryFeed(context, "Club");
                          },
                          child: CategoryButton(asset: 'lib/assets/club2.png')),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Clubs",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToCategoryFeed(context, "Sport");
                        },
                        child: CategoryButton(
                            asset: 'lib/assets/sportbutton1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sports",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToCategoryFeed(context, "Show");
                        },
                        child: CategoryButton(
                            asset: 'lib/assets/filmbutton1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Shows",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: <Widget>[
                //     GestureDetector(
                //         onTap: () {
                //           navigateToShowFeed(context);
                //         },
                //         child: CategoryButton(
                //             asset: 'lib/assets/filmbutton1.png')),
                //     Align(
                //         alignment: Alignment.center,
                //         child: Text(
                //           "Shows",
                //           style: TextStyle(
                //               fontFamily: 'Open Sans',
                //               fontWeight: FontWeight.bold,
                //               color: Colors.black,
                //               fontSize: 16.0),
                //         ))
                //   ],
                // ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: isLargePhone ? 1.187 : 1.1,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToCategoryFeed(context, "Virtual");
                        },
                        child:
                            CategoryButton(asset: 'lib/assets/virtual1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Virtual",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToCategoryFeed(context, "Dorm Life");
                        },
                        child: CategoryButton(asset: 'lib/assets/dorm1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Dorm Life",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MorePage()));
                },
                child: Card(
                  margin: EdgeInsets.all(15),
                  color: TextThemes.ndBlue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 25, top: 25),
                        child: RichText(
                          textScaleFactor: 1.75,
                          text:
                              TextSpan(style: TextThemes.mediumbody, children: [
                            TextSpan(
                                text: "More ",
                                style: TextStyle(color: Colors.white)),
                            TextSpan(
                                text: "MOOVs",
                                style: TextStyle(color: TextThemes.ndGold)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
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

class CategoryButton extends StatelessWidget {
  CategoryButton({@required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;
    bool isNarrow = Screen.widthInches(context) < 3.5;

    return Container(
      // height:
      height: isLargePhone
          ? MediaQuery.of(context).size.height * 0.15
          : MediaQuery.of(context).size.height * 0.178,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          (asset),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 7.5),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
