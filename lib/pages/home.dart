import 'dart:async';
import 'dart:io';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/BusinessTab.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:MOOV/pages/MessagesHub.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/WelcomePage.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/locationCheckIn.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:page_transition/page_transition.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();
final usersRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('users');
final postsRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('food');
final groupsRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('friendGroups');
final notificationFeedRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('notificationFeed');
final chatRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('chat');
final messagesRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('directMessages');
final archiveRef = FirebaseFirestore.instance
    .collection('notreDame')
    .doc('data')
    .collection('postArchives');

final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  callback() {
    setState(() {});
  }

  AnimationController _hideFabAnimController;
  ScrollController scrollController;

  bool isSelected = false;
  String stringValue = "No value";

  bool isAuth = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseMessaging _fcm = FirebaseMessaging();
  PageController pageController;
  int pageIndex = 0;
  dynamic startDate, moovId;
  List<dynamic> likedArray;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription iosSubscription;
  @override
  initState() {
    super.initState();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1,
    );
    scrollController = ScrollController();

    scrollController.addListener(() {
      switch (scrollController.position.userScrollDirection) {
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

    pageController = PageController();
    // Detects when user signed in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error signing in: $err');
    });

    // Reauthenticate user when app is opened
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error signing in: $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account == null) {
      setState(() {
        isAuth = false;
      });
    } else {
      createUserInFirestore();
    }
  }

  configurePushNotifications() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermission();

    _fcm.getToken().then((token) {
      print('token: $token\n');
      usersRef.doc(user.id).update({'androidNotificationToken': token});
    });

    Future<dynamic> myBackgroundMessageHandler(
        Map<String, dynamic> message) async {
      print("BG?");
      final String pushId = message['link'];
      final String page = message['page'];
      final String recipientId = message['recipient'];
      final String body = message['notification']['title'] +
          ' ' +
          message['notification']['body'];

//      FlutterAppBadger.updateBadgeCount(1);
      if (recipientId == currentUser.id) {
        print(pushId);
        Flushbar snackbar = Flushbar(
            padding: EdgeInsets.all(20),
            borderRadius: 15,
            flushbarStyle: FlushbarStyle.FLOATING,
            boxShadows: [
              BoxShadow(
                  color: Colors.blue[800],
                  offset: Offset(0.0, 2.0),
                  blurRadius: 3.0)
            ],
            icon: Icon(
              Icons.directions_run,
              color: Colors.green,
            ),
            duration: Duration(seconds: 4),
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.white,
            messageText: Text(body,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black)));
        // SnackBar snackybar = SnackBar(
        //     content: Text(body, overflow: TextOverflow.ellipsis),
        //     backgroundColor: Colors.green);
        // _scaffoldKey.currentState.showSnackBar(snackybar);
        snackbar.show(context);
      }
    }

    _fcm.configure(onLaunch: (Map<String, dynamic> message) async {
      print('message: $message');
      final String pushId = message['link'];
      final String page = message['page'];
      final String recipientId = message['recipient'];
      final String body = message['notification']['title'] +
          ' ' +
          message['notification']['body'];
//      FlutterAppBadger.updateBadgeCount(1);
      // if (page == 'chat') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => MessagesHub()));
      // } else if (page == 'post') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => PostDetail(pushId)));
      // } else if (page == 'group') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => GroupDetail(pushId)));
      // } else if (page == 'user') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => OtherProfile(pushId)));
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => NotificationFeed()));
      // }
//          if (recipientId == currentUser.id) {
      print('Notification shown');

      Flushbar snackbar = Flushbar(
          onTap: (data) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PostDetail(pushId)));
          },
          flushbarStyle: FlushbarStyle.FLOATING,
          boxShadows: [
            BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0)
          ],
          backgroundGradient:
              LinearGradient(colors: [TextThemes.ndGold, TextThemes.ndGold]),
          icon: Icon(
            Icons.directions_run,
            color: Colors.green[700],
          ),
          duration: Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.green,
          messageText: Text(
            body,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white),
          ));
      // SnackBar snackybar = SnackBar(
      //     content: Text(body, overflow: TextOverflow.ellipsis),
      //     backgroundColor: Colors.green);
      // _scaffoldKey.currentState.showSnackBar(snackybar);
      snackbar.show(context);
      // Get.snackbar("Message", body);
//          }
      print('Notification not shown :(');
    },
//        onBackgroundMessage: myBackgroundMessageHandler,
        onResume: (Map<String, dynamic> message) async {
      // if (Platform.isIOS) {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => MessageList()));
      // }
      //   _navigationService.navigateTo(
      //   routes.EventDetail,
      //      arguments: '${message["eventId"]}',
      //   );
      // } else {
      //   _navigationService.navigateTo(
      //    routes.EventDetail,
      //      arguments: '${message["data"]["eventId"]}',
      //    );
      // }

      print('message resume: $message');
      final String pushId = message['link'];
      final String page = message['page'];
      final String recipientId = message['recipient'];
      final String body = message['notification']['title'] +
          ' ' +
          message['notification']['body'];
//      FlutterAppBadger.updateBadgeCount(1);
      // if (page == 'chat') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => MessagesHub()));
      // } else if (page == 'post') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => PostDetail(pushId)));
      // } else if (page == 'group') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => GroupDetail(pushId)));
      // } else if (page == 'user') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => OtherProfile(pushId)));
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => NotificationFeed()));
      // }
//          if (recipientId == currentUser.id) {
      print('Notification shown');
      Flushbar snackbar = Flushbar(
          onTap: (data) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PostDetail(pushId)));
          },
          flushbarStyle: FlushbarStyle.FLOATING,
          boxShadows: [
            BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0)
          ],
          backgroundGradient:
              LinearGradient(colors: [TextThemes.ndGold, TextThemes.ndGold]),
          icon: Icon(
            Icons.directions_run,
            color: Colors.green[700],
          ),
          duration: Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.green,
          messageText: Text(body,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white)));
      // SnackBar snackybar = SnackBar(
      //     content: Text(body, overflow: TextOverflow.ellipsis),
      //     backgroundColor: Colors.green);
      // _scaffoldKey.currentState.showSnackBar(snackybar);
      snackbar.show(context);

      // Get.snackbar(recipientId, body, backgroundColor: Colors.green);
//          }
      print('Notification not shown :(');
    }, onMessage: (Map<String, dynamic> message) async {
      print('message onmessage: $message');

      String pushId = "";
      String page = "";
      String recipientId = "";
      String body = "";

      if (message.containsKey("notification")) {
        pushId = message['link'];
        page = message['page'];
        recipientId = message['recipient'];
        body = message['notification']['title'] +
            ' ' +
            message['notification']['body'];
      } else {
//        pushId = message['link'];
//        page = message['page'];
//        recipientId = message['recipient'];
        body = message["aps"]['title'] + ' ' + message['aps']['body'];
      }

//      FlutterAppBadger.updateBadgeCount(1);
      // if (page == 'chat') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => MessagesHub()));
      // } else if (page == 'post') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => PostDetail(pushId)));
      // } else if (page == 'group') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => GroupDetail(pushId)));
      // } else if (page == 'user') {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => OtherProfile(pushId)));
      // } else {
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => NotificationFeed()));
      // }

//      FlutterAppBadger.updateBadgeCount(1);
//          if (recipientId == currentUser.id) {
//            print(pushId);
//            print(page);

      usersRef.doc(user.id).update({'test': message.toString()});

      Flushbar snackbar = Flushbar(
          onTap: (data) {
            print("DATA ${data}");
//            Navigator.push(context,
//                MaterialPageRoute(builder: (context) => PostDetail(pushId)));
          },
          padding: EdgeInsets.all(20),
          borderRadius: 15,
          flushbarStyle: FlushbarStyle.FLOATING,
          boxShadows: [
            BoxShadow(
                color: Colors.blue[800],
                offset: Offset(0.0, 2.0),
                blurRadius: 3.0)
          ],
          icon: Icon(
            Icons.directions_run,
            color: Colors.green,
          ),
          duration: Duration(seconds: 4),
          flushbarPosition: FlushbarPosition.TOP,
          backgroundColor: Colors.white,
          messageText: Text("SAMPLE",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black)));
      // SnackBar snackybar = SnackBar(
      //     content: Text(body, overflow: TextOverflow.ellipsis),
      //     backgroundColor: Colors.green);
      // _scaffoldKey.currentState.showSnackBar(snackybar);
      snackbar.show(context);

      usersRef.doc(user.id).update({'snackbar': message.toString()});
//          }
      print('Notification not shown :(');
    });
  }

  getiOSPermission() {
    _fcm.requestNotificationPermissions(IosNotificationSettings());
    _fcm.onIosSettingsRegistered.listen((settings) {
      print('settings: $settings');
    });
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final result = await Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomePage()),
        (Route<dynamic> route) => false,
      );

      final String dorm = result[0];
      final String year = result[2];
      final String gender = result[1];
      final String referral = result[3];
      final String venmoUsername = result[4];

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "Create a bio here",
        "header": "",
        "timestamp": timestamp,
        "score": 0,
        "gender": gender,
        "year": year,
        "dorm": dorm,
        "referral": referral,
        "postLimit": 3,
        "sendLimit": 5,
        "suggestLimit": 5,
        "groupLimit": 2,
        "nameChangeLimit": 1,
        "verifiedStatus": 0,
        "friendArray": [],
        "friendRequests": [],
        "friendGroups": [],
        "venmoUsername": venmoUsername,
        "pushSettings": {
          "going": true,
          "hourBefore": true,
          "suggestions": true
        },
        "privacySettings": {
          "friendFinderVisibility": true,
          "friendsOnly": false,
          "incognito": false,
          "showDorm": true
        }
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    setState(() {
      isAuth = true;
    });
    configurePushNotifications();
  }

  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    _hideFabAnimController.dispose();
    scrollController.dispose();

    if (iosSubscription != null) iosSubscription.cancel();
    super.dispose();
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
    setState(() {
      currentIndex = pageIndex;
    });
  }

  Scaffold buildAuthScreen() {
    Future<String> randomPostMaker() async {
      String randomPost;
      print(randomAlpha(1));

      final QuerySnapshot result = await postsRef
          .where("postId", isGreaterThanOrEqualTo: randomAlpha(1))
          .where("privacy", isEqualTo: "Public")
          .orderBy("postId")
          .limit(1)
          .get();
      if (result.docs != null && result.docs.first['privacy'] == "Public")
        randomPost = await result.docs.first['postId'];
      print(result.docs.first['privacy']);
      return randomPost;
    }

    int hi = 2;
    if (hi != 0) {
      isSelected = true;
    }

    locationCheckIn(context, callback);

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child: ScaleTransition(
          scale: _hideFabAnimController,
          child: FloatingActionButton.extended(
              onPressed: () {
                HapticFeedback.lightImpact();

                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.topToBottom,
                        child: MoovMaker(postModel: PostModel())));
              },
              label: Row(
                children: [
                  Text("Post ",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Icon(Icons.directions_run, color: Colors.white),
                ],
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        leadingWidth: 55,
        leading: CarouselSlider(
          options: CarouselOptions(
            height: 400,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            scrollPhysics: NeverScrollableScrollPhysics(),
            pauseAutoPlayOnTouch: false,
            reverse: false,
            autoPlay: false,
            autoPlayInterval: Duration(seconds: 4),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: [
            IconButton(
              padding: EdgeInsets.only(left: 5.0),
              icon: Icon(Icons.insert_chart_outlined),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () async {
                // Implement navigation to leaderboard page here...
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LeaderBoardPage()));
              },
            ),
            // GestureDetector(
            //   onTap: () async {
            //     var randomPost = await randomPostMaker();
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => PostDetail(randomPost)));
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.all(7.0),
            //     padding: const EdgeInsets.all(7.0),
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Colors.white),
            //         borderRadius: BorderRadius.circular(7)),
            //     child: Text(
            //       "Surprise",
            //       style: TextStyle(fontSize: 14.0, color: Colors.white),
            //     ),
            //   ),
            // ),
            // FocusedMenuHolder(
            //   menuWidth: MediaQuery.of(context).size.width * .95,

            //   blurSize: 5.0,
            //   menuItemExtent: 200,
            //   menuBoxDecoration: BoxDecoration(
            //       color: Colors.grey,
            //       borderRadius: BorderRadius.all(Radius.circular(15.0))),
            //   duration: Duration(milliseconds: 100),
            //   animateMenuItems: true,
            //   blurBackgroundColor: Colors.black54,
            //   openWithTap:
            //       true, // Open Focused-Menu on Tap rather than Long Press
            //   menuOffset:
            //       10.0, // Offset value to show menuItem from the selected item
            //   bottomOffsetHeight:
            //       80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
            //   menuItems: <FocusedMenuItem>[
            //     // Add Each FocusedMenuItem  for Menu Options

            //     FocusedMenuItem(
            //         title: Center(
            //             child: Text(
            //           "     Lowkey / Chill",
            //           style: GoogleFonts.robotoSlab(fontSize: 40),
            //         )),
            //         // trailingIcon: Icon(Icons.edit),
            //         onPressed: () {
            //           navigateToCategoryFeed(context, "Shows");
            //         }),
            //     FocusedMenuItem(
            //         backgroundColor: Colors.red[50],
            //         title: Text("          Rage",
            //             style: GoogleFonts.yeonSung(
            //                 fontSize: 50, color: Colors.red)),
            //         onPressed: () {
            //           navigateToCategoryFeed(context, "Parties");
            //         }),
            //   ],
            //   onPressed: () {},
            //   child: Container(
            //     margin: const EdgeInsets.all(7.0),
            //     padding: const EdgeInsets.all(7.0),
            //     decoration: BoxDecoration(
            //         border: Border.all(color: Colors.white),
            //         borderRadius: BorderRadius.circular(7)),
            //     child: Text(
            //       "Mood",
            //       style: TextStyle(fontSize: 14.0, color: Colors.white),
            //     ),
            //   ),
            // ),
          ].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width * 3,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(),
                    child: Center(
                      child: i,
                    ));
              },
            );
          }).toList(),
        ),

        // child: Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: Image.asset('lib/assets/ndlogo.png', height: 70),
        // ),

        backgroundColor: TextThemes.ndBlue,
        //pinned: true,
        actions: <Widget>[
          NamedIconMessages(
              iconData: Icons.mail_outline,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessageList()));
              }),
          NamedIcon(
              iconData: Icons.notifications_active_outlined,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationFeed()));
                Database().setNotifsSeen();
              }),
        ],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {},
                child: Bounce(
                  duration: Duration(milliseconds: 50),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Image.asset(
                    'lib/assets/moovblue.png',
                    fit: BoxFit.cover,
                    height: 50.0,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: PageView(
        children: <Widget>[
          // Timeline(),
          HomePage(),

          SearchBar(),

          currentUser.isBusiness ? Biz() : MOOVSPage(),
          ProfilePage()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
          inactiveColor: Colors.black,
          currentIndex: currentIndex,
          onTap: onTap,
          activeColor: TextThemes.ndGold,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined)),
            BottomNavigationBarItem(icon: Icon(Icons.search_outlined)),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined)),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                    radius: 16,
                    backgroundColor:
                        pageIndex == 3 ? TextThemes.ndGold : Colors.black,
                    child: currentUser.photoUrl != null
                        ? CircleAvatar(
                            radius: 14,
                            backgroundImage: NetworkImage(currentUser.photoUrl))
                        : CircleAvatar(
                            radius: 14,
                            backgroundImage:
                                AssetImage('lib/assets/incognitoPic.jpg')))
                // CircleAvatar(
                //   backgroundImage: NetworkImage(currentUser.photoUrl),
                //   radius: 13)
                ),
          ]),
    );
    // return RaisedButton(
    //   child: Text('Logout'),
    //   onPressed: logout,
    // );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        color: TextThemes.ndBlue,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'lib/assets/landingpage.png',
              scale: .5,
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 300.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'lib/assets/google.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return (isAuth == true) ? buildAuthScreen() : buildUnAuthScreen();
  }
}

class NamedIconMessages extends StatelessWidget {
  final IconData iconData;
  final int messages;
  final VoidCallback onTap;
  int messageCount;

  NamedIconMessages({
    Key key,
    this.onTap,
    this.messages,
    @required this.iconData,
    this.messageCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;

    return StreamBuilder(
        stream: messagesRef
            .where("receiver", isEqualTo: currentUser.id)
            .where('seen', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return CircularProgressIndicator();
          if (!snapshot.hasData) return CircularProgressIndicator();
          int notifs = snapshot.data.docs.length;

          return InkWell(
            onTap: onTap,
            child: Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(iconData, color: Colors.white),
                  notifs != 0
                      ? Positioned(
                          top: 8,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            alignment: Alignment.center,
                            child: Text("$notifs",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final int notifs;
  final VoidCallback onTap;
  int notificationCount;

  NamedIcon({
    Key key,
    this.onTap,
    this.notifs,
    @required this.iconData,
    this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;

    return StreamBuilder(
        stream: notificationFeedRef
            .doc(user.id)
            .collection('feedItems')
            .where('seen', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return CircularProgressIndicator();
          if (!snapshot.hasData) return CircularProgressIndicator();
          int notifs = snapshot.data.docs.length;

          return InkWell(
            onTap: onTap,
            child: Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(iconData, color: Colors.white),
                  notifs != 0
                      ? Positioned(
                          top: 8,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.red),
                            alignment: Alignment.center,
                            child: Text("$notifs",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  SharedPreferencesDemo({Key key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _counter = notificationFeedRef
      .doc(googleSignIn.currentUser.id)
      .collection('feedItems')
      .snapshots()
      .length;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  Future<void> _clearCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) * 0;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    print(notificationFeedRef
        .doc(googleSignIn.currentUser.id)
        .collection('feedItems')
        .snapshots()
        .length);
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Preferences Demo"),
      ),
      body: Column(
        children: [
          Center(
              child: FutureBuilder<int>(
                  future: _counter,
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const CircularProgressIndicator();
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text(
                            'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                            'This should persist across restarts.',
                          );
                        }
                    }
                  })),
          FlatButton(onPressed: _clearCounter, child: Text("HI"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<File> cropImage(File _image) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Croperooni',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Croperooni',
      ));
  return croppedFile;
}
