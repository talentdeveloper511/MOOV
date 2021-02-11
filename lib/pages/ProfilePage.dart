import 'dart:async';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/Friends_List.dart';
import 'package:MOOV/pages/MOOVSPage.dart';
import 'package:MOOV/pages/SettingsPage.dart';
import 'package:MOOV/pages/contactsPage.dart';
import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey _settingsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool bigHeight = true;
    SharedPreferences preferences;

    displayShowCase4() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus = preferences.getBool("displayShowCase4");
      if (showCaseVisibilityStatus == null) {
        preferences.setBool("displayShowCase4", false);
        bigHeight = false;
        return true;
      }
      return false;
    }


    displayShowCase4().then((status) {
      if (status) {
        Timer(Duration(seconds: 1), () {
          ShowCaseWidget.of(context).startShowCase([_settingsKey]);
        });
      }
    });

    var strUserPic = currentUser.photoUrl;
    var userYear = currentUser.year;
    var userDorm = currentUser.dorm;
    var userBio;
    var userHeader = currentUser.header;
    var userFriends = currentUser.friendArray;
    // var userMoovs = currentUser.likedMoovs;
    var userGroups = currentUser.friendGroups;
    // var userFriendsLength = "0";
    int verifiedStatus = currentUser.verifiedStatus;

    return StreamBuilder(
        stream: usersRef.doc(currentUser.id).snapshots(),
        builder: (context, snapshot) {
          bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();
          userBio = snapshot.data['bio'];
          int score = snapshot.data['score'];
          userDorm = snapshot.data['dorm'];
          userHeader = snapshot.data['header'];
          strUserPic = snapshot.data['photoUrl'];
          verifiedStatus = snapshot.data['verifiedStatus'];
          userFriends = snapshot.data['friendArray'];
          // userMoovs = snapshot.data['likedMoovs'];
          userGroups = snapshot.data['friendGroups'];
          String venmo = snapshot.data['venmoUsername'];
          bool showDorm = snapshot.data['privacySettings']['showDorm'];

          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(children: [
                Container(
                  height: 130,
                  child: GestureDetector(
                    onTap: () {},
                    child: Stack(children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: isLargePhone ? 1.17 : 1.34,
                        child: Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfile()));
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: userHeader == ""
                                  ? Image.asset('lib/assets/header.jpg',
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      userHeader,
                                      fit: BoxFit.fitWidth,
                                    ),
                            ),
                          ),
                          margin: EdgeInsets.only(
                              left: 20, top: 0, right: 20, bottom: 7.5),
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: TextThemes.ndGold,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: TextThemes.ndBlue,
                              child: CircleAvatar(
                                backgroundImage: (strUserPic == null)
                                    ? AssetImage('images/user-avatar.png')
                                    : NetworkImage(strUserPic),
                                // backgroundImage: NetworkImage(currentUser.photoUrl),
                                radius: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            height: bigHeight ? 24 : 18,
                            child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => SettingsPage())),
                                child: Showcase(
                                    key: _settingsKey,
                                    title: "MOOV OFF THE GRID",
                                    description:
                                        "\nHere's where you can completely \ncustomize your privacy settings",
                                    titleTextStyle: TextStyle(
                                        color: TextThemes.ndBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                    descTextStyle:
                                        TextStyle(fontStyle: FontStyle.italic),
                                    contentPadding: EdgeInsets.all(10),
                                    child: Icon(Icons.settings))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.displayName != ""
                                  ? currentUser.displayName
                                  : "Username not found",
                              style: TextThemes.extraBold,
                            ),
                            verifiedStatus == 3
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      left: 5,
                                      top: 2.5,
                                    ),
                                    child: Icon(
                                      Icons.store,
                                      size: 25,
                                      color: TextThemes.ndGold,
                                    ),
                                  )
                                : verifiedStatus == 2
                                    ? Padding(
                                        padding:
                                            EdgeInsets.only(left: 5, top: 5),
                                        child: Image.asset(
                                            'lib/assets/verif2.png',
                                            height: 20),
                                      )
                                    : verifiedStatus == 1
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 2.5, top: 0),
                                            child: Image.asset(
                                                'lib/assets/verif.png',
                                                height: 30),
                                          )
                                        : Text("")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
                        child: showDorm == false
                            ? Text(
                                "Top secret year and dorm",
                                style: TextStyle(fontSize: 15),
                              )
                            : Text(
                                userYear != "" && userDorm != ""
                                    ? userYear + ' in ' + userDorm
                                    : "",
                                style: TextStyle(fontSize: 15),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LeaderBoardPage()));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    score.toString(),
                                    style: TextThemes.extraBold,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      '       Score       ',
                                      style: TextThemes.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        FriendsList(id: currentUser.id)));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    userFriends.length == null ||
                                            userFriends.length == 0
                                        ? "0"
                                        : userFriends.length.toString(),
                                    style: TextThemes.extraBold,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: userFriends.length == 1
                                        ? Text(
                                            '     Friend     ',
                                            style: TextThemes.bodyText1,
                                          )
                                        : Text(
                                            '     Friends     ',
                                            style: TextThemes.bodyText1,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => FriendGroupsPage()));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    userGroups.length == null ||
                                            userGroups.length == 0
                                        ? "0"
                                        : userGroups.length.toString(),
                                    style: TextThemes.extraBold,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: userGroups.length == 1
                                        ? Text(
                                            'Friend Group',
                                            style: TextThemes.bodyText1,
                                          )
                                        : Text(
                                            'Friend Groups',
                                            style: TextThemes.bodyText1,
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      venmo != null && venmo != ""
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('lib/assets/venmo-icon.png',
                                      height: 35),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "@" + venmo,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(""),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, bottom: 20, top: 10),
                          color: TextThemes.ndBlue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 2, top: 8),
                                child: RichText(
                                  textScaleFactor: 1.75,
                                  text: TextSpan(
                                      style: TextThemes.mediumbody,
                                      children: [
                                        TextSpan(
                                            text: "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                color: TextThemes.ndGold)),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 35),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: RichText(
                                      textScaleFactor: 1.3,
                                      text: TextSpan(
                                          style: TextThemes.mediumbody,
                                          children: [
                                            TextSpan(
                                                text: "\"" + userBio + "\"",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SeeContactsButton(),
                      ),
                    ],
                  ),
                )
              ]),
            ),
          );
        });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Sign out?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nWhere you goin'?"),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child:
                  Text("Yes, sign me out", style: TextStyle(color: Colors.red)),
              onPressed: () {
                googleSignIn.signOut();
                Navigator.of(context).pop(true);
              }),
          CupertinoDialogAction(
            child: Text("Nah, my bad"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
}
