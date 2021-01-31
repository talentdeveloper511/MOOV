import 'dart:math';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/map_test.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/pages/search.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_account.dart';

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
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  Future<void> initState() {
    super.initState();
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
    getAllSavedData();
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
      configurePushNotifications();
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  configurePushNotifications() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    if (Platform.isIOS) getiOSPermission();

    _fcm.getToken().then((token) {
      print('token: $token/n');
      usersRef.doc(user.id).update({'androidNotificationToken': token});
    });

    _fcm.configure(onLaunch: (Map<String, dynamic> message) async {
      print('on message: $message');
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if (recipientId == user.id) {
        print('Notification shown');
        SnackBar snackbar =
            SnackBar(content: Text(body, overflow: TextOverflow.ellipsis));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
      print('Notification not shown :(');
    }, onResume: (Map<String, dynamic> message) async {
      print('message: $message');
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if (recipientId == user.id) {
        print('Notification shown');
        SnackBar snackbar =
            SnackBar(content: Text(body, overflow: TextOverflow.ellipsis));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
      print('Notification not shown :(');
    }, onMessage: (Map<String, dynamic> message) async {
      print('message: $message');
      final String recipientId = message['data']['recipient'];
      final String body = message['notification']['body'];
      if (recipientId == user.id) {
        print('Notification shown');
        SnackBar snackbar =
            SnackBar(content: Text(body, overflow: TextOverflow.ellipsis));
        _scaffoldKey.currentState.showSnackBar(snackbar);
      }
      print('Notification not shown :(');
    });
  }

  getiOSPermission() {
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(alert: true, badge: true, sound: true));
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
      final result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

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
        "isAmbassador": false,
        "friendArray": [],
        "friendRequests": [],
        "friendGroups": [],
        "venmoUsername": venmoUsername,
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
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
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  getAllSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool value = prefs.getBool("youKey");

    // For first time you get null data so no value
    // is assigned so it will not assign anything
    if (value != null) stringValue = value.toString();

    setState(() {});
  }

  Scaffold buildAuthScreen() {
    // Future<int> notifCount() async {
    //   int notifCount;

    //   final QuerySnapshot result = await notificationFeedRef
    //       .doc(currentUser.id)
    //       .collection('feedItems')
    //       .get();
    //   if (result.docs != null) notifCount = await result.docs.length;

    //   // print(randomPost);
    //   return notifCount;
    // }

    Future<String> randomPostMaker() async {
      String randomPost;
      print(randomAlpha(1));

      final QuerySnapshot result = await postsRef
          .where("postId", isGreaterThanOrEqualTo: randomAlpha(1))
          .orderBy("postId")
          .limit(1)
          .get();
      if (result.docs != null) randomPost = await result.docs.first['postId'];

      if (result.docs == null) {
        final QuerySnapshot result2 = await postsRef
            .where("postId", isGreaterThanOrEqualTo: "")
            .orderBy("postId")
            .limit(1)
            .get();
        randomPost = await result.docs.first['postId'];
      }
      // print(randomPost);
      return randomPost;
    }

    Future navigateToCategoryFeed(context, type) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CategoryFeed(type: type)));
    }

    int hi = 2;
    if (hi != 0) {
      isSelected = true;
    }
    // notificationFeedRef
    //     .doc(currentUser.id)
    //     .collection('feedItems')
    //     .orderBy('timestamp', descending: true)
    //     .limit(50)
    //     .get();

    // Upload(currentUser: currentUser);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leadingWidth: 100,
        leading: CarouselSlider(
          options: CarouselOptions(
            height: 400,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            // scrollPhysics: NeverScrollableScrollPhysics(),
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
            GestureDetector(
              onTap: () async {
                var randomPost = await randomPostMaker();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PostDetail(randomPost)));
              },
              child: Container(
                margin: const EdgeInsets.all(7.0),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  "Surprise",
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ),
            FocusedMenuHolder(
              menuWidth: MediaQuery.of(context).size.width * .95,

              blurSize: 5.0,
              menuItemExtent: 200,
              menuBoxDecoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              duration: Duration(milliseconds: 100),
              animateMenuItems: true,
              blurBackgroundColor: Colors.black54,
              openWithTap:
                  true, // Open Focused-Menu on Tap rather than Long Press
              menuOffset:
                  10.0, // Offset value to show menuItem from the selected item
              bottomOffsetHeight:
                  80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
              menuItems: <FocusedMenuItem>[
                // Add Each FocusedMenuItem  for Menu Options

                FocusedMenuItem(
                    title: Center(
                        child: Text(
                      "     Lowkey / Chill",
                      style: GoogleFonts.robotoSlab(fontSize: 40),
                    )),
                    // trailingIcon: Icon(Icons.edit),
                    onPressed: () {
                      navigateToCategoryFeed(context, "Shows");
                    }),
                FocusedMenuItem(
                    backgroundColor: Colors.red[50],
                    title: Text("          Rage",
                        style: GoogleFonts.yeonSung(
                            fontSize: 50, color: Colors.red)),
                    onPressed: () {
                      navigateToCategoryFeed(context, "Pregames & Parties");
                    }),
              ],
              onPressed: () {},
              child: Container(
                margin: const EdgeInsets.all(7.0),
                padding: const EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(7)),
                child: Text(
                  "Mood",
                  style: TextStyle(fontSize: 14.0, color: Colors.white),
                ),
              ),
            ),
            Image.asset('lib/assets/ndlogo.png', height: 35),
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
          IconButton(
            padding: EdgeInsets.only(left: 5.0),
            icon: Icon(Icons.insert_chart),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () async {
              // Implement navigation to leaderboard page here...
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LeaderBoardPage()));
            },
          ),
          NamedIcon(
              iconData: Icons.notifications_active,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationFeed()));
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
          MOOVSPage(),
          ProfilePage()
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: TextThemes.ndGold,
          items: [
            BottomNavigationBarItem(
                title: Text("Home"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text("Search"), icon: Icon(Icons.search)),
            BottomNavigationBarItem(
                title: Text("My MOOVs"), icon: Icon(Icons.directions_run)),
            BottomNavigationBarItem(
                title: Text("Profile"), icon: Icon(Icons.person_outline)
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
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
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
        title: const Text("SharedPreferences Demo"),
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
