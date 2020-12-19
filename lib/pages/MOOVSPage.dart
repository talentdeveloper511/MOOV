import 'package:MOOV/main.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/widgets/my_moovs_segment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/pages/notification_page.dart';
import 'PostDepth.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage> {
  final String currentUserId = currentUser?.id;
  bool isLiked = false;
  bool _isPressed;
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    isLiked = false;
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;

    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('lib/assets/ndlogo.png', height: 100),
          ),
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
                print('Leaderboards clicked');
              },
            ),
            IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(Icons.notifications_active),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationFeed()));
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
                  height: 55.0,
                ),
              ],
            ),
          ),
        ),
// .where("liked", arrayContains: strUserId)
        body: MyMoovsSegment()
        // FloatingActionButton.extended(
        //     onPressed: () {
        //       // Add your onPressed code here!
        //     },
        //     label: Text('Find a MOOV',
        //         style: TextStyle(color: Colors.white)),
        //     icon: Icon(Icons.search, color: Colors.white),
        //     backgroundColor: Color.fromRGBO(220, 180, 57, 1.0))
        );
  }

  handleLikePost() {
    if (isLiked == true) {
      isLiked = false;
    } else {
      isLiked = true;
    }
  }
}
