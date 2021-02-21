import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/direct_message.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:timeago/timeago.dart' as timeago;

class DmPage extends StatefulWidget {
  final String otherId;

  DmPage({
    this.otherId,
  });

  @override
  DmPageState createState() => DmPageState(
        otherId: this.otherId,
      );
}

class DmPageState extends State<DmPage> {
  TextEditingController commentController = TextEditingController();
  final String otherId;

  DmPageState({
    this.otherId,
  });

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: <Widget>[
            Expanded(child: DirectMessage(otherUserId: otherId)),
          ],
        ),
      ),
    );
  }
}

class PostComment extends StatelessWidget {
  final String displayName;
  final String userId;
  final String avatarUrl;
  final String comment;
  final String postId;
  final Timestamp timestamp;
  final String chatId;
  final String millis;

  PostComment(
      {this.displayName,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.postId,
      this.timestamp,
      this.chatId,
      this.millis});

  factory PostComment.fromDocument(DocumentSnapshot doc) {
    return PostComment(
      displayName: doc['displayName'],
      userId: doc['userId'],
      comment: doc['comment'],
      postId: doc['postId'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
      chatId: doc['chatId'],
      millis: doc['millis'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: GestureDetector(
            onTap: () {
              if (userId == currentUser.id) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePageWithHeader()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OtherProfile(userId)));
              }
            },
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(avatarUrl),
            ),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
          trailing: (userId == currentUser.id)
              ? GestureDetector(
                  onTap: () {
                    showAlertDialog(context, chatId, postId, millis);
                  },
                  child: Icon(Icons.more_vert_outlined))
              : Text(''),
        ),
        Divider(),
      ],
    );
  }

  void showAlertDialog(BuildContext context, chatId, postId, millis) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Delete?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nRemove your message?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);

              postsRef
                  .doc(postId)
                  .collection("comments")
                  .doc(millis + " " + currentUser.id)
                  .delete();
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
}
