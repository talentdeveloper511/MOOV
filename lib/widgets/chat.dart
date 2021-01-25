import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/home.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chat extends StatefulWidget {
  final String gid;
  final String groupPic;

  Chat({
    this.gid,
    this.groupPic,
  });

  @override
  ChatState createState() => ChatState(
        gid: this.gid,
        groupPic: this.groupPic,
      );
}

class ChatState extends State<Chat> {
  TextEditingController commentController = TextEditingController();
  final String gid;
  final String groupPic;

  ChatState({
    this.gid,
    this.groupPic,
  });

  buildChat() {
    return StreamBuilder(
        stream: chatRef
            .doc(gid)
            .collection('chat')
            .orderBy("timestamp", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          List<Comment> chat = [];
          snapshot.data.docs.forEach((doc) {
            chat.add(Comment.fromDocument(doc));
          });
          return ListView(
            children: chat,
          );
        });
  }

  addComment() {
    chatRef.doc(gid).collection("chat").add({
      "username": currentUser.displayName,
      "comment": commentController.text,
      "timestamp": timestamp,
      "avatarUrl": currentUser.photoUrl,
      "userId": currentUser.id,
    });
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
          Expanded(child: buildChat()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentController,
              decoration: InputDecoration(labelText: "Talk to 'em..."),
            ),
            trailing: OutlineButton(
              onPressed: addComment,
              borderSide: BorderSide.none,
              child: Text("Post", style: TextStyle(color: Colors.blue))
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.avatarUrl,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(avatarUrl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider(),
      ],
    );
  }
}
