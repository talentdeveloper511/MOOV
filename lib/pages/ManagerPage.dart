import 'package:MOOV3/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV3/pages/HomePage.dart';
import 'package:MOOV3/pages/MOOVSPage.dart';
import 'package:MOOV3/pages/ProfilePage.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  bool isSignedIn = false;
  PageController pageController;
  int currentIndex = 0;
  bool isActive = false;

  void initState() {
    super.initState();
    pageController = PageController();
  }
  //   gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
  //     controlSignIn(gSigninAccount);
  //   }, onError: (gError) {
  //     print("Error Message " + gError);
  //   });

  //   gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
  //     controlSignIn(gSignInAccount);
  //   }).catchError((gError) {
  //     print("Error Message " + gError);
  //   });
  // }

  // controlSignIn(GoogleSignInAccount signInAccount) async {
  //   if (signInAccount != null) {
  //     setState(() {
  //       isSignedIn = true;
  //     });
  //   } else {
  //     isSignedIn = false;
  //   }
  // }

  // loginUser() {
  //   gSignIn.signIn();
  // }

  // logoutUser() {
  //   gSignIn.signOut();
  // }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.currentIndex = pageIndex;
      this.isActive = true;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
    setState(() {
      currentIndex = pageIndex;
    });
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
        body: PageView(
          children: <Widget>[
            HomePage(),
            MOOVSPage(),
            ProfilePage(),
          ],
          controller: pageController,
          onPageChanged: whenPageChanges,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          currentIndex: currentIndex,
          onTap: onTapChangePage,
          backgroundColor: CupertinoColors.extraLightBackgroundGray,
          activeColor: currentIndex == 0
              ? Color.fromRGBO(220, 180, 57, 1.0)
              : Color.fromRGBO(220, 180, 57, 1.0),
          inactiveColor: Colors.blueGrey,
          items: [
            BottomNavigationBarItem(
                title: Text('Home'), icon: Icon(CupertinoIcons.home)),
            BottomNavigationBarItem(
                title: Text('My MOOVs'), icon: Icon(CupertinoIcons.heart)),
            BottomNavigationBarItem(
                title: Text('Profile'),
                icon: Icon(CupertinoIcons.profile_circled)),
          ],
        ));

    // return RaisedButton.icon(
    //     onPressed: logoutUser(),
    //     icon: Icon(Icons.close),
    //     label: Text("Sign out"));
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
              onTap: null,
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
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
