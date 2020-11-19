// import 'package:MOOV/pages/ManagerPage.dart';

import 'package:MOOV/pages/auth/google_sign_in.dart';
import 'package:MOOV/utils/AssetStrings.dart';
import 'package:flutter/material.dart';
import '../home/HomePage.dart';
import '../my_moovs/MOOVSPage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/cupertino.dart';
import '../profile/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;

  void initState() {
    super.initState();

    pageController = PageController();
  }

  void autoLogIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('email');
    String imageUrl = prefs.getString('imageUrl');

    if (email != null && imageUrl != null) {
      setState(() {
        isSignedIn = true;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          setState(() {
            isSignedIn = true;
          });
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white, width: 5),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(AssetStrings.logoGoogleSignin), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        color: TextThemes.ndGold,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('lib/assets/appicon.png'),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
        body: PageView(
          children: <Widget>[HomePage(), MOOVSPage(), ProfilePage()],
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
}
