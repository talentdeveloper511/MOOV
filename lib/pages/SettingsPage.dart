import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/ChangePrivacy.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/home.dart' as home;
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePageWithHeader.dart';
import 'UserData.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
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
    // bool isLargePhone = Screen.diagonal(context) > 766;

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
                  onTap: () async {},

                  //   Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => home.Home()),
                  //     (Route<dynamic> route) => false,
                  //   );
                  // },
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
            child: StreamBuilder(
                stream: home.usersRef.doc(home.currentUser.id).snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasError) {
                    return new Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return linearProgress();
                  } else {
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
                                        Icons.settings,
                                        color: TextThemes.ndBlue,
                                        size: 50,
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text("Settings",
                                        style: TextThemes.headline1),
                                  ),
                                  Text(
                                    "Your MOOV, your way",
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8.0),
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                  //     children: [
                                  //       Icon(Icons.flag, color: Colors.red),
                                  //       Text(
                                  //         " Page and features here are still in development", style: TextStyle(color: Colors.red),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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
                                Card(
                                  elevation: 4.0,
                                  margin: const EdgeInsets.fromLTRB(
                                      32.0, 8.0, 32.0, 16.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(
                                          Icons.lock_outline,
                                          color: TextThemes.ndBlue,
                                        ),
                                        title: Text("Change Privacy"),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          // Database().updateAllDocs();
                                          //open change password
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChangePrivacy()));
                                        },
                                      ),
                                      _buildDivider(),
                                      ListTile(
                                        leading: Icon(
                                          Icons.edit,
                                          color: TextThemes.ndBlue,
                                        ),
                                        title: Text("Edit Profile"),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile()));
                                        },
                                      ),
                                      _buildDivider(),
                                      ListTile(
                                        leading: Icon(
                                          Icons.data_usage_sharp,
                                          color: TextThemes.ndBlue,
                                        ),
                                        title: Text("See Your Data"),
                                        trailing:
                                            Icon(Icons.keyboard_arrow_right),
                                        onTap: () {
                                          //open change location

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserData()));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                NotificationSettings()
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: -20,
                            left: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 00,
                            left: 00,
                            child: IconButton(
                              icon: Icon(
                                Icons.power_off,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showAlertDialog(context);
                              },
                            ),
                          )
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
                home.googleSignIn.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => home.Home()),
                  (Route<dynamic> route) => false,
                );
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
