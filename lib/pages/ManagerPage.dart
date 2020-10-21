import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/create_account/create_account.dart';

import 'package:MOOV/pages/upload.dart';
import 'package:MOOV/widgets/bottom_navigation.dart';
import 'package:MOOV/widgets/segmented_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/home/HomePage.dart';
import 'package:MOOV/pages/post/MOOVSPage.dart';
import 'package:MOOV/pages/profile/ProfilePage.dart';
import 'package:MOOV/pages/pages.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home/home.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final StorageReference storageRef = FirebaseStorage.instance.ref();
final usersRef = Firestore.instance.collection('users');
final postsRef = Firestore.instance.collection('posts');
final DateTime timestamp = DateTime.now();
User currentUser;

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  bool isSignedIn = false;
  int getPageIndex = 0;
  PageController pageController;

  void initState() {
    super.initState();

    pageController = PageController();

    googleSignIn.onCurrentUserChanged.listen((account) {
      controlSignIn(account);
    }, onError: (err) {
      print("Error Message: $err");
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      controlSignIn(account);
    }).catchError((err) {
      print("Error Message: $err");
    });
  }

  controlSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUserInFirestore();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  createUserInFirestore() async {
    //check if user exists in users collection in database according to their id
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.document(user.id).get();

    //if user doesnt exist, take them to create account page
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateAccount()));
      print('alive');

      //get username from create account, use it to make new doc in users collection
      usersRef.document(user.id).setData({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "timestamp": timestamp
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

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }

  Scaffold buildHomeScreen() {
    // Upload();
    return Scaffold(
        body: PageView(
          children: <Widget>[Upload(), MOOVSPage(), ProfilePage()],
          controller: pageController,
          onPageChanged: whenPageChanges,
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: getPageIndex,
          onTap: onTapChangePage,
          activeColor: TextThemes.ndGold,
          inactiveColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(
                title: Text("Home"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text("My MOOVs"), icon: Icon(Icons.directions_run)),
            BottomNavigationBarItem(
                title: Text("Profile"), icon: Icon(Icons.person)),
          ],
        ));
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      backgroundColor: TextThemes.ndGold,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Image.asset('lib/assets/appicon.png'),
            Spacer(flex: 3),
            GestureDetector(
              onTap: loginUser,
              child: Container(
                width: 300.0,
                height: 50.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('lib/assets/google.png'),
                      fit: BoxFit.fitHeight),
                ),
              ),
            ),
            Spacer(flex: 3),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => buildHomeScreen(),
              ));
        },
        child: Icon(Icons.arrow_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isSignedIn ? buildSignInScreen() : buildHomeScreen();
  }
}
