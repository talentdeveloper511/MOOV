import 'dart:async';

import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/home.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_2.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
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
  final _scrollController = ScrollController();
  bool messages = false;

  ChatState({
    this.gid,
    this.groupPic,
  });

  adjustChat() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

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
            controller: _scrollController,
            // reverse: true,
            children: chat,
          );
        });
  }

  addComment() {
    adjustChat();
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
      Timer(
          Duration(milliseconds: 200),
          () => _scrollController
              .jumpTo(_scrollController.position.maxScrollExtent));
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 200),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
    return Container(
      height: 500,
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
                onPressed: () => {addComment(), adjustChat()},
                borderSide: BorderSide.none,
                child: Text("Send", style: TextStyle(color: Colors.blue))),
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
        (userId != currentUser.id)
            ? ListTile(
                // tileColor: Colors.blue[100],
                title: ChatBubble(
                    alignment: Alignment.centerLeft,
                    clipper:
                        ChatBubbleClipper5(type: BubbleType.receiverBubble),
                    backGroundColor: Colors.grey[200],
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.7,
                        ),
                        child: Text(comment))),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(avatarUrl),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(timeago.format(timestamp.toDate())),
                ),
                trailing: (userId == currentUser.id)
                    ? GestureDetector(
                        onTap: () {
                          showAlertDialog(context, chatId, gid, millis);
                        },
                        child: Icon(Icons.more_vert_outlined))
                    : Text(''),
              )
            : Stack(
                children: [
                  ListTile(
                    // tileColor: Colors.blue[100],
                    title: ChatBubble(
                        alignment: Alignment.centerRight,
                        clipper:
                            ChatBubbleClipper5(type: BubbleType.sendBubble),
                        backGroundColor: Colors.blue[200],
                        margin: EdgeInsets.only(top: 20),
                        child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(comment))),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(timeago.format(timestamp.toDate()),
                          textAlign: TextAlign.right),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(avatarUrl),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   left: 20,
                  //   top: 30,
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         showAlertDialog(context, chatId, gid, millis);
                  //       },
                  //       child: Icon(Icons.more_vert_outlined)),
                  // )
                ],
              ),
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
