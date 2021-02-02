import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/sign_in.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePageWithHeader.dart';

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
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream:
              usersRef.orderBy('score', descending: true).limit(50).snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notreDame')
                      .doc('data')
                      .collection('leaderboard')
                      .doc('prizes')
                      .snapshots(),
                  builder: (context, snapshot2) {
                    if (!snapshot2.hasData) return CircularProgressIndicator();

                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      if (snapshot.data.docs[i]['id'] == currentUser.id) {
                        myIndex = i;
                      }
                    }

                    var prize = snapshot2.data['prize'];
                    return 
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Icon(
                    //             Icons.settings,
                    //             color: TextThemes.ndBlue,
                    //             size: 50,
                    //           )),
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 8.0),
                    //         child:
                    //             Text("Settings", style: TextThemes.headline1),
                    //       ),
                    //       Text(
                    //         "Your MOOV, your way",
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(15.0),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             ClipOval(
                    //                 child: Material(
                    //                     child: InkWell(
                    //                         splashColor: TextThemes
                    //                             .ndGold, // inkwell color
                    //                         child: SizedBox(
                    //                           width: 20,
                    //                           height: 10,
                    //                         )))),
                    //           ],
                    //         ),
                    //       ),]))
                          Scaffold(
                            body: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.settings,
                                color: TextThemes.ndBlue,
                                size: 50,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child:
                                Text("Settings", style: TextThemes.headline1),
                          ),
                          Text(
                            "Your MOOV, your way",
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 7.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               
                              ],
                            ),
                          ),])),
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
                                              trailing: Icon(
                                                  Icons.keyboard_arrow_right),
                                              onTap: () {
                                                //open change password
                                              },
                                            ),
                                            _buildDivider(),
                                            ListTile(
                                              leading: Icon(
                                                Icons.language,
                                                color: TextThemes.ndBlue,
                                              ),
                                              title: Text("Change Language"),
                                              trailing: Icon(
                                                  Icons.keyboard_arrow_right),
                                              onTap: () {
                                                //open change language
                                              },
                                            ),
                                            _buildDivider(),
                                            ListTile(
                                              leading: Icon(
                                                Icons.location_on,
                                                color: TextThemes.ndBlue,
                                              ),
                                              title: Text("See Your Data"),
                                              trailing: Icon(
                                                  Icons.keyboard_arrow_right),
                                              onTap: () {
                                                //open change location
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20.0),
                                      Text(
                                        "Notification Settings",
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
                                        title: Text("Pause All"),
                                        onChanged: (val) {},
                                      ),
                                      SwitchListTile(
                                        activeColor: TextThemes.ndBlue,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: true,
                                        title: Text("Going to your MOOV"),
                                        onChanged: (val) {},
                                      ),
                                      SwitchListTile(
                                        activeColor: TextThemes.ndBlue,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: true,
                                        title:
                                            Text("Hour before MOOV starts"),
                                        onChanged: (val) {},
                                      ),
                                      SwitchListTile(
                                        activeColor: TextThemes.ndBlue,
                                        contentPadding: const EdgeInsets.all(0),
                                        value: true,
                                        title: Text("Friend Group Suggestions"),
                                        onChanged:  (val) {},
                                      ),
                                      const SizedBox(height: 60.0),
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
                                      color: TextThemes.ndBlue,
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
                                      //log out
                                    },
                                  ),
                                )
                              ],
                            ),
                          
                       
                    );
                  });
            }
          },
        ),
      ),
    );
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

