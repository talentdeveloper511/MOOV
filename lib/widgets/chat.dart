import 'dart:async';
import 'dart:math';

import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MessagesHub.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
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
  final String gid, directMessageId, otherPerson;
  final bool isGroupChat;

  Chat({this.gid, this.isGroupChat, this.directMessageId, this.otherPerson});

  @override
  ChatState createState() => ChatState(
      gid: this.gid,
      isGroupChat: this.isGroupChat,
      directMessageId: this.directMessageId,
      otherPerson: this.otherPerson);
}

class ChatState extends State<Chat> {
  rebuild() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              MessageDetail(directMessageId, otherPerson),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    });
  }

  TextEditingController commentController = TextEditingController();
  final String gid, otherPerson;
  String directMessageId;
  final bool isGroupChat;
  final _scrollController = ScrollController();
  bool messages = false;

  ChatState(
      {this.gid, this.isGroupChat, this.directMessageId, this.otherPerson});

  adjustChat() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 100),
      curve: Curves.fastOutSlowIn,
    );
  }

  buildChat() {
    CollectionReference reference = isGroupChat
        ? groupsRef.doc(gid).collection('chat')
        : messagesRef.doc(directMessageId).collection('chat');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        // Do something with change
        Timer(
            Duration(milliseconds: 200),
            () => _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 300)));
      });
    });
    return StreamBuilder(
        stream: isGroupChat
            ? groupsRef
                .doc(gid)
                .collection('chat')
                // .orderBy("timestamp", descending: false)
                .snapshots()
            : messagesRef.doc(directMessageId).collection('chat').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          List<Comment> chat = [];
          snapshot.data.docs.forEach((doc) {
            chat.add(Comment.fromDocument(doc));
          });
          return ListView(
            controller: _scrollController,
            children: chat,
          );
        });
  }

  addComment() {
    // adjustChat();

    if (commentController.text.isNotEmpty) {
      isGroupChat
          ? groupsRef
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
              "millis": DateTime.now().millisecondsSinceEpoch.toString(),
              "directMessageId": "",
              "isGroupChat": true
            })
          : messagesRef
              .doc(directMessageId)
              .collection("chat")
              .doc(DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id)
              .set({
              "seen": false,
              "displayName": currentUser.displayName,
              "comment": commentController.text,
              "timestamp": timestamp,
              "avatarUrl": currentUser.photoUrl,
              "userId": currentUser.id,
              "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id,
              "directMessageId": directMessageId,
              "isGroupChat": false,
              "gid": "",
              "millis": DateTime.now().millisecondsSinceEpoch.toString()
            });
      isGroupChat
          ? null
          : messagesRef.doc(directMessageId).update({
              "lastMessage": commentController.text,
              "timestamp": timestamp,
              "sender": currentUser.id,
              "seen": false
            });
      Timer(
          Duration(milliseconds: 200),
          () => _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 200)));
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
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
                onPressed: () {
                  if (isGroupChat == false && directMessageId == "nothing") {
                    directMessageId = currentUser.id + otherPerson;
                    messagesRef.doc(directMessageId).set({
                      "lastMessage": commentController.text,
                      "seen": false,
                      "sender": currentUser.id,
                      "timestamp": timestamp,
                      "directMessageId": directMessageId,
                      "people": [currentUser.id, otherPerson]
                    });
                  }
                  // isGroupChat
                  //     ? null
                  //     : Navigator.pushReplacement(
                  //         context,
                  //         PageRouteBuilder(
                  //           pageBuilder: (context, animation1, animation2) =>
                  //               MessageDetail(directMessageId, otherPerson),
                  //           transitionDuration: Duration(seconds: 0),
                  //         ),
                  //       );

                  addComment();
                  // adjustChat();
                },
                borderSide: BorderSide.none,
                child: Text("Send", style: TextStyle(color: Colors.blue))),
          ),
        ],
      ),
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
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
  String directMessageId;
  final bool isGroupChat;

  Comment(
      {this.displayName,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.chatId,
      this.gid,
      this.millis,
      this.directMessageId,
      this.isGroupChat});

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      displayName: doc['displayName'],
      userId: doc['userId'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
      avatarUrl: doc['avatarUrl'],
      chatId: doc['chatId'],
      gid: doc['gid'],
      millis: doc['millis'],
      directMessageId: doc['directMessageId'],
      isGroupChat: doc['isGroupChat'],
    );
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
                          showAlertDialog(context, chatId, gid, millis,
                              isGroupChat, directMessageId);
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
                  Positioned(
                    left: 20,
                    top: 30,
                    child: GestureDetector(
                        onTap: () {
                          showAlertDialog(context, chatId, gid, millis,
                              isGroupChat, directMessageId);
                        },
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: Colors.grey,
                        )),
                  )
                ],
              ),
      ],
    );
  }

  void showAlertDialog(
      BuildContext context, chatId, gid, millis, isGroupChat, directMessageId) {
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
              isGroupChat
                  ? groupsRef
                      .doc(gid)
                      .collection("chat")
                      .doc(millis + " " + currentUser.id)
                      .delete()
                  : messagesRef
                      .doc(directMessageId)
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
