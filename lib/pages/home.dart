import 'dart:math';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:MOOV/pages/ProfilePage.dart';
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
import 'package:random_string/random_string.dart';
import 'create_account.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('food');
final groupsRef = Firestore.instance.collection('friendGroups');

final notificationFeedRef = Firestore.instance.collection('notificationFeed');
final DateTime timestamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  dynamic startDate, moovId;
  List<dynamic> likedArray;
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
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page
      final result = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));

      final String dorm = result[0];
      final String year = result[2];
      final String gender = result[1];
      final String referral = result[3];

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "Create a bio here",
        "header":
            "https://firebasestorage.googleapis.com/v0/b/moov4-4d3c4.appspot.com/o/images%2Fheadermoosekev%201?alt=media&token=61dc4828-8eca-4d1f-8078-3a837cb95fef",
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
        "venmo": "",
        "likedMoovs": [],
        "friendGroups": []
      });
      doc = await usersRef.document(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  @override
  void dispose() {
    pageController.dispose();
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

  Scaffold buildAuthScreen() {
    Future<String> randomPostMaker() async {
      String randomPost;
      print(randomAlpha(1));

      final QuerySnapshot result = await postsRef
          .where("postId", isGreaterThanOrEqualTo: randomAlpha(1))
          .orderBy("postId")
          .limit(1)
          .getDocuments();
      if (result.documents != null)
        randomPost = await result.documents.first['postId'];

      if (result.documents == null) {
        final QuerySnapshot result2 = await postsRef
            .where("postId", isGreaterThanOrEqualTo: "")
            .orderBy("postId")
            .limit(1)
            .getDocuments();
        randomPost = await result.documents.first['postId'];
      }
      // print(randomPost);
      return randomPost;
    }

    Future navigateToCategoryFeed(context, type) async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CategoryFeed(type: type)));
    }

    // Upload(currentUser: currentUser);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
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
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 2),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            // onPageChanged: callbackFunction,
            scrollDirection: Axis.horizontal,
          ),
          items: [
            Image.asset('lib/assets/ndlogo.png', height: 35),
            Text(
              " What's the MOOV?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
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
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.insert_chart),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              // Implement navigation to leaderboard page here...
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LeaderBoardPage()));
            },
          ),
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.notifications_active),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationFeed()));
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
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        children: <Widget>[
          // Timeline(),
          HomePage(),
          Search(),
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
