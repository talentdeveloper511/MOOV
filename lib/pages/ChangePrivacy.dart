import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class ChangePrivacy extends StatefulWidget {
  ChangePrivacy({Key key}) : super(key: key);

  @override
  _ChangePrivacyState createState() => _ChangePrivacyState();
}

class _ChangePrivacyState extends State<ChangePrivacy> {
  bool isSwitch = false;
  bool isSwitch2 = false;
  bool isSwitch3 = false;
  bool isSwitch4 = false;
  bool incognito;
  bool friendsSeeOnly;
  bool friendFinderVisibility;
  bool showDorm;

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return StreamBuilder(
        stream: usersRef.doc(currentUser.id).snapshots(),
        builder: (context, snapshot) {
          // bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();

          incognito = snapshot.data['privacySettings']['incognito'] ?? false;
          friendsSeeOnly =
              snapshot.data['privacySettings']['friendsOnly'] ?? false;
          showDorm = snapshot.data['privacySettings']['showDorm'] ?? true;
          friendFinderVisibility = snapshot.data['privacySettings']
                  ['friendFinderVisibility'] ??
              true;

          return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  },
                ),
                backgroundColor: TextThemes.ndBlue,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(5),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Image.asset(
                          'lib/assets/moovblue.png',
                          fit: BoxFit.cover,
                          height: 50.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: isLargePhone
                    ? EdgeInsets.symmetric(horizontal: 20.0)
                    : EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Column(children: [
                      SizedBox(height: 10),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.lock_outline,
                            color: TextThemes.ndBlue,
                            size: 50,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text("Change Your Privacy",
                            style: TextThemes.headline1),
                      ),
                      Text(
                        "Go as incognito as you want. It's your choice.",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 7.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [],
                        ),
                      ),
                    ]),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Privacy Settings",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Only friends can see my going status",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                          Switch(
                            value: friendsSeeOnly != true
                                ? isSwitch
                                : friendsSeeOnly,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch = val;
                                friendsSeeOnly = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "privacySettings": {"friendsOnly": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Nobody can see my going status (incognito)",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: incognito != true ? isSwitch2 : incognito,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch2 = val;
                                incognito = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "privacySettings": {"incognito": val}
                              }, SetOptions(merge: true));
                              if (incognito == true) {
                                setState(() {
                                  friendsSeeOnly = false;
                                });
                                usersRef.doc(currentUser.id).set({
                                  "privacySettings": {"friendsOnly": false}
                                }, SetOptions(merge: true));
                              }
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Show my dorm and class year on my profile",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: showDorm != true ? isSwitch3 : showDorm,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch3 = val;
                                showDorm = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "privacySettings": {"showDorm": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Friends can see my plans on Friend Finder",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: friendFinderVisibility != true
                                ? isSwitch4
                                : friendFinderVisibility,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch4 = val;
                                friendFinderVisibility = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "privacySettings": {
                                  "friendFinderVisibility": val
                                }
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                  ],
                ),
              ));
        });
  }
}

class NotificationSettings extends StatefulWidget {
  NotificationSettings({Key key}) : super(key: key);

  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool isSwitch = false;
  bool isSwitch2 = false;
  bool isSwitch3 = false;
  bool friendPosts;
  bool going;
  bool hourBefore;
  bool suggestions;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: usersRef.doc(currentUser.id).snapshots(),
        builder: (context, snapshot) {
          // bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();

          friendPosts = snapshot.data['pushSettings']['friendPosts'];
          going = snapshot.data['pushSettings']['going'];
          hourBefore = snapshot.data['pushSettings']['hourBefore'];
          suggestions = snapshot.data['pushSettings']['suggestions'];
          String businessCode;
          if (snapshot.data['isBusiness']) {
            businessCode = snapshot.data['businessCode'];
          }

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(children: [
                Column(
                  children: [
                    currentUser.isBusiness
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("YOUR BUSINESS CODE: "),
                                Text(businessCode,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          )
                        : Container(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Push Notification Settings",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("When a friend posts a MOOV",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: friendPosts != true ? isSwitch : friendPosts,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch = val;
                                friendPosts = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "pushSettings": {"friendPosts": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Going to your MOOV",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: going != true ? isSwitch : going,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch = val;
                                going = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "pushSettings": {"going": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("One hour before MOOV starts",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value: hourBefore != true ? isSwitch2 : hourBefore,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch2 = val;
                                hourBefore = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "pushSettings": {"hourBefore": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Friend Group suggestions",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                          Switch(
                            value:
                                suggestions != true ? isSwitch3 : suggestions,
                            onChanged: (val) {
                              HapticFeedback.lightImpact();

                              setState(() {
                                isSwitch3 = val;
                                suggestions = val;
                              });
                              usersRef.doc(currentUser.id).set({
                                "pushSettings": {"suggestions": val}
                              }, SetOptions(merge: true));
                            },
                            activeTrackColor: Colors.blueGrey[500],
                            activeColor: TextThemes.ndBlue,
                          ),
                        ]),
                  ],
                ),
              ]));
        });
  }
}
