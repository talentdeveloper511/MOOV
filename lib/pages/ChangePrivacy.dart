import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/home.dart' as home;
import 'package:MOOV/pages/sign_in.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MOOV/helpers/themes.dart';
import 'ChangePrivacy.dart';
import 'HomePage.dart';
import 'ProfilePageWithHeader.dart';
import 'UserData.dart';

class ChangePrivacy extends StatefulWidget {
  @override
  _ChangePrivacyState createState() {
    return _ChangePrivacyState();
  }
}

class _ChangePrivacyState extends State<ChangePrivacy> {
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;

    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.search),
            Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    var myIndex = 0;
    var score;
    var pic;
    return Scaffold(
        backgroundColor: Colors.white,
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
                      MaterialPageRoute(builder: (context) => home.Home()),
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
        body: Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: home.usersRef
                    .orderBy('score', descending: true)
                    .limit(50)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Loading..."),
                          SizedBox(
                            height: 50.0,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    );
                  } else {
                    var prize;

                    return Scaffold(
                      body: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          SingleChildScrollView(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    child: Column(children: [
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [],
                                    ),
                                  ),
                                ])),
                                const SizedBox(height: 10.0),
                                const SizedBox(height: 20.0),
                                Text(
                                  "Privacy Settings",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SwitchListTile(
                                  activeColor: TextThemes.ndBlue,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: false,
                                  title: Text(
                                      "Only friends can see my going status"),
                                  onChanged: (val) {},
                                ),
                                SwitchListTile(
                                  activeColor: TextThemes.ndBlue,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: false,
                                  title: Text(
                                      "Nobody can see my going status (incognito)"),
                                  onChanged: (val) {},
                                ),
                                SwitchListTile(
                                  activeColor: TextThemes.ndBlue,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: true,
                                  title: Text(
                                      "Show my dorm and class year on my profile"),
                                  onChanged: (val) {},
                                ),
                                SwitchListTile(
                                  activeColor: TextThemes.ndBlue,
                                  contentPadding: const EdgeInsets.all(0),
                                  value: true,
                                  title: Text(
                                      "Friends can see my plans on the friend finder"),
                                  onChanged: (val) {},
                                ),
                                const SizedBox(height: 60.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })));
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
