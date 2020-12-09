import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationFeed extends StatefulWidget {
  @override
  _NotificationFeedState createState() => _NotificationFeedState();
}

class _NotificationFeedState extends State<NotificationFeed> {
  getNotificationFeed() async {
    QuerySnapshot snapshot = await notificationFeedRef
        .document(currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<NotificationFeedItem> feedItems = [];
    snapshot.documents.forEach((doc) {
      feedItems.add(NotificationFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return feedItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TextThemes.ndBlue,
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
        //pinned: true,

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
      body: Container(
          child: FutureBuilder(
        future: getNotificationFeed(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          return ListView(
            children: snapshot.data,
          );
        },
      )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class NotificationFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  final String previewImg;
  final String postId;
  final String userProfilePic;
  final String userEmail;

  // final String commentData;
  final Timestamp timestamp;
  dynamic startDate, address, moovId;
  List<dynamic> likedArray;

  var ownerName;
  var ownerEmail;
  var ownerPic;
  var title;
  var description;
  var location;

  getdata() {
    Firestore.instance.collection('food').snapshots().listen((snapshot) {
      for (var i = 0; i < snapshot.documents.length; i++) {
        DocumentSnapshot course = snapshot.documents[i];
        ownerName = course['userName'];
        ownerEmail = course['userEmail'];
        ownerPic = course['profilePic'];
        title = course['title'];
        description = course['description'];
        startDate = course['startDate'];
        location = course['location'];
        address = course['address'];
        likedArray = course['liked'];
      }
    });
  }

  NotificationFeedItem(
      {this.title,
      this.username,
      this.userEmail,
      this.userId,
      this.type,
      this.previewImg,
      this.postId,
      this.userProfilePic,
      // this.commentData,
      this.timestamp,
      this.startDate,
      this.address,
      this.likedArray});

  factory NotificationFeedItem.fromDocument(DocumentSnapshot doc) {
    return NotificationFeedItem(
      username: doc['username'],
      userEmail: doc['userEmail'],
      userId: doc['userId'],
      type: doc['type'],
      postId: doc['postId'],
      userProfilePic: doc['userProfilePic'],
      // commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      previewImg: doc['previewImg'],
    );
  }

  showPost(context) {
    getdata();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostDetail(
                previewImg,
                title,
                description,
                startDate,
                location,
                address,
                ownerPic,
                ownerName,
                ownerEmail,
                likedArray,
                userId)));
  }

  configureMediaPreview(context) {
    if (type == 'going' || type == 'comment') {
      mediaPreview = GestureDetector(
        onTap: () => showPost(context),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(previewImg),
                  ),
                ),
              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'going') {
      activityItemText = "is going to your MOOV!";
    } else if (type == 'follow') {
      activityItemText = "is following you";
      // } else if (type == 'comment') {
      //   activityItemText = 'replied: $commentData';
    } else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: GestureDetector(
            onTap: () => showProfile(context),
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(userProfilePic),
            ),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }

  showProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProfilePage()));
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            OtherProfile(userProfilePic, username, userId, userEmail, username)));
  }
}
