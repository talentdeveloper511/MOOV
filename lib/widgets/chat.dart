import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  bool messages = false;

  ChatState({
    this.gid,
    this.groupPic,
  });

  buildChat() {
    return StreamBuilder(
        stream: groupsRef
            .doc(gid)
            .collection('chat')
            // .orderBy("timestamp", descending: false)
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
    if (commentController.text.isNotEmpty) {
      groupsRef
          .doc(gid)
          .collection("chat")
          .doc(DateTime.now().millisecondsSinceEpoch.toString() +
              " " +
              currentUser.id)
          .set({
        "displayName": currentUser.displayName,
        "comment": commentController.text,
        "timestamp": timestamp,
        "avatarUrl": currentUser.photoUrl,
        "userId": currentUser.id,
        "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
            " " +
            currentUser.id,
        "gid": gid,
        "millis": DateTime.now().millisecondsSinceEpoch.toString()
      });
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: messages ? 300 : 100,
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
                child: Text("Post", style: TextStyle(color: Colors.blue))),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String displayName;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;
  final String chatId;
  final String gid;
  final String millis;

  Comment(
      {this.displayName,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.chatId,
      this.gid,
      this.millis});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
        displayName: doc['displayName'],
        userId: doc['userId'],
        comment: doc['comment'],
        timestamp: doc['timestamp'],
        avatarUrl: doc['avatarUrl'],
        chatId: doc['chatId'],
        gid: doc['gid'],
        millis: doc['millis']);
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
          trailing: (userId == currentUser.id)
              ? GestureDetector(
                  onTap: () {
                    showAlertDialog(context, chatId, gid, millis);
                  },
                  child: Icon(Icons.more_vert_outlined))
              : Text(''),
        ),
        Divider(),
      ],
    );
  }

  void showAlertDialog(BuildContext context, chatId, gid, millis) {
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

              groupsRef
                  .doc(gid)
                  .collection("chat")
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
