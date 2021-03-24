import 'dart:async';
import 'dart:math';

import 'package:MOOV/main.dart';
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
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Chat extends StatefulWidget {
  final String gid, directMessageId, otherPerson;
  final bool isGroupChat;
  final List<dynamic> members;

  Chat(
      {this.gid,
      this.isGroupChat,
      this.directMessageId,
      this.otherPerson,
      this.members});

  @override
  ChatState createState() => ChatState(
      gid: this.gid,
      isGroupChat: this.isGroupChat,
      directMessageId: this.directMessageId,
      otherPerson: this.otherPerson,
      members: this.members);
}

class ChatState extends State<Chat> {
  rebuild() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              MessageDetail(directMessageId, otherPerson, false, " ", []),
          transitionDuration: Duration(seconds: 0),
        ),
      );
    });
  }

  TextEditingController commentController = TextEditingController();
  final String gid, otherPerson;
  String directMessageId;
  final List<dynamic> members;
  final bool isGroupChat;
  final _scrollController = ScrollController();
  bool messages = false;

  ChatState(
      {this.gid,
      this.isGroupChat,
      this.directMessageId,
      this.otherPerson,
      this.members});

  adjustChat() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  buildChat() {
    CollectionReference reference = isGroupChat
        ? messagesRef.doc(gid).collection('chat')
        : messagesRef.doc(directMessageId).collection('chat');
    reference.snapshots().listen((querySnapshot) {
      querySnapshot.docChanges.forEach((change) {
        if (querySnapshot.docs.isNotEmpty) {
          Timer(Duration(milliseconds: 200), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 300));
            }
          });
        }
      });
    });
    return StreamBuilder(
        stream: isGroupChat
            ? messagesRef
                .doc(gid)
                .collection('chat')
                // .orderBy("timestamp", descending: false)
                .snapshots()
            : messagesRef.doc(directMessageId).collection('chat').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return new Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting ||
              !snapshot.hasData) {
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
            List<Comment> chat = [];
            snapshot.data.docs.forEach((doc) {
              chat.add(Comment.fromDocument(doc));
            });
            return ListView(
              controller: _scrollController,
              children: chat,
            );
          }
        });
  }

  addComment() {
    if (directMessageId == null) {
      circularProgress();
    }
    if (directMessageId == "nothing" || directMessageId == null) {
      directMessageId = currentUser.id + otherPerson;
    }
    if (commentController.text.isNotEmpty) {
      isGroupChat
          ? messagesRef
              .doc(gid)
              .collection("chat")
              .doc(DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id)
              .set({
              "seen": false,
              "displayName": currentUser.displayName,
              "comment": commentController.text,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "avatarUrl": currentUser.photoUrl,
              "userId": currentUser.id,
              "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id,
              "gid": gid,
              "millis": DateTime.now().millisecondsSinceEpoch.toString(),
              "directMessageId": "",
              "isGroupChat": true,
              "reactions": {}
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
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "avatarUrl": currentUser.photoUrl,
              "userId": currentUser.id,
              "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id,
              "gid": " ",
              "directMessageId": directMessageId,
              "isGroupChat": false,
              "millis": DateTime.now().millisecondsSinceEpoch.toString(),
              "reactions": {}
            });
      isGroupChat
          ? messagesRef.doc(gid).set({
              "lastMessage": commentController.text,
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": gid,
              "directMessageId": directMessageId,
              "people": members,
              "isGroupChat": true,
            }, SetOptions(merge: true))
          : messagesRef.doc(directMessageId).set({
              "lastMessage": commentController.text,
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": "",
              "directMessageId": directMessageId,
              "people": [currentUser.id, otherPerson],
              "isGroupChat": false,
            }, SetOptions(merge: true));
      Timer(Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 200));
        }
      });
      commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    Timer(Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
    return Container(
      height: isLargePhone ? 500 : 370,
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
                  // if (isGroupChat == false) {
                  //   directMessageId = currentUser.id + otherPerson;
                  //   Timer(
                  //       Duration(milliseconds: 200),
                  //       () => messagesRef.doc(directMessageId).set({
                  //             "lastMessage": commentController.text,
                  //             "seen": false,
                  //             "sender": currentUser.id,
                  //             "receiver": otherPerson,
                  //             "timestamp": timestamp,
                  //             "directMessageId": directMessageId,
                  //             "people": [currentUser.id, otherPerson]
                  //           }));
                  // }

                  isGroupChat
                      ? null
                      : messagesRef
                          .doc(directMessageId)
                          .collection("chat")
                          .get()
                          .then((doc) {
                          if (doc.docs.length <= 1) {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        MessageDetail(directMessageId,
                                            otherPerson, false, " ", []),
                                transitionDuration: Duration(seconds: 0),
                              ),
                            );
                          }
                        });

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

class Comment extends StatefulWidget {
  final String displayName;
  final String userId;
  final String avatarUrl;
  final String comment;
  final int timestamp;
  final String chatId;
  final String gid;
  final String millis;
  final String directMessageId;
  final bool isGroupChat;

  final Map<String, dynamic> reactions;

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
      this.isGroupChat,
      this.reactions});

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
        reactions: doc['reactions']);
  }

  @override
  _CommentState createState() => _CommentState(
      this.displayName,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.chatId,
      this.gid,
      this.millis,
      this.directMessageId,
      this.isGroupChat,
      this.reactions);
}

class _CommentState extends State<Comment> {
  final String displayName;
  final String userId;
  final String avatarUrl;
  final String comment;
  final int timestamp;
  final String chatId;
  final String gid;
  final String millis;
  String directMessageId;
  final bool isGroupChat;
  final Map<String, dynamic> reactions;
  _CommentState(
      this.displayName,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp,
      this.chatId,
      this.gid,
      this.millis,
      this.directMessageId,
      this.isGroupChat,
      this.reactions);

  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var format = new DateFormat('').add_jm();
    var format2 = new DateFormat('EEE').add_jm();

    var date = new DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    String timeAgo = '';

    timeAgo = format.format(date);

    if (1440 <= diff.inMinutes && diff.inMinutes <= 2880) {
      timeAgo = format2.format(date);
    }

    bool middleFinger = false;
    int status = -1;
    List reactionValues = reactions.values.toList();
    // if (reactions.isNotEmpty && reactionValues[0] == 0) {
    //   middleFinger = true;
    // }

    return Column(
      children: <Widget>[
        (userId != currentUser.id)
            ? ListTile(
                // tileColor: Colors.blue[100],
                title: isGroupChat
                    ? ChatBubble(
                        alignment: Alignment.centerLeft,
                        clipper:
                            ChatBubbleClipper5(type: BubbleType.receiverBubble),
                        backGroundColor: Colors.grey[200],
                        margin: EdgeInsets.only(top: 5),
                        child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            child: Text(comment)))
                    : FlutterReactionButtonCheck(
                        onReactionChanged: (reaction, index, isChecked) {
                          // FLIPPED OFF NOTIF HERE
                          // if (reactionValues[0] == 0) {
                          //   setState(() {
                          //     middleFinger = false;
                          //   });
                          // } else
                          //  if (reactionValues[0] == 1) {
                          //   setState(() {
                          //     middleFinger = false;
                          //   });
                          // }
                          // // } else {
                          // //   setState(() {
                          // //     reactionValues[0] = -1;
                          // //   });
                          // // }
                          // Database().chatReaction(currentUser.id,
                          //     directMessageId, chatId, index, false);
                          // setState(() {
                          //   middleFinger = !middleFinger;
                          // });

                          // print(reactionValues[0]);
                          // print(middleFinger);
                        },
                        reactions: [
                            Reaction(
                                previewIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0, top: 6, bottom: 6, left: 8),
                                    child: Text("Coming soon")),
                                // previewIcon: Padding(
                                //   padding: const EdgeInsets.only(
                                //       right: 8.0, top: 4, bottom: 6),
                                //   child: Image.asset(
                                //     'lib/assets/middleFinger.gif',
                                //     height: 40,
                                //   ),
                                // ),
                                // title: Text("Flip 'em off"),
                                icon: Stack(children: [
                                  ChatBubble(
                                      alignment: Alignment.centerLeft,
                                      clipper: ChatBubbleClipper5(
                                          type: BubbleType.receiverBubble),
                                      backGroundColor: Colors.grey[200],
                                      margin: EdgeInsets.only(top: 5),
                                      child: Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                          ),
                                          child: Text(comment))),
                                  Positioned(
                                      left: comment.length < 25
                                          ? comment.length.toDouble() * 8
                                          : comment.length < 40
                                              ? comment.length.toDouble() * 6
                                              : 220,
                                      child: middleFinger
                                          ? Image.asset(
                                              'lib/assets/middleFinger.gif',
                                              height: 40,
                                            )
                                          : Container())
                                ])),
                            // Reaction(
                            //     // previewIcon: Padding(
                            //     //   padding: const EdgeInsets.only(
                            //     //       right: 8.0, top: 4, bottom: 6),
                            //     //   child: Image.asset(
                            //     //     'lib/assets/chens.jpg',
                            //     //     height: 40,
                            //     //   ),
                            //     // ),
                            //     // title: Text("Flip 'em off"),
                            //     icon: Stack(children: [
                            //       ChatBubble(
                            //           alignment: Alignment.centerLeft,
                            //           clipper: ChatBubbleClipper5(
                            //               type: BubbleType.receiverBubble),
                            //           backGroundColor: Colors.grey[200],
                            //           margin: EdgeInsets.only(top: 5),
                            //           child: Container(
                            //               constraints: BoxConstraints(
                            //                 maxWidth: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.7,
                            //               ),
                            //               child: Text(comment))),
                            //       Positioned(
                            //           left: comment.length < 25
                            //               ? comment.length.toDouble() * 8
                            //               : comment.length < 40
                            //                   ? comment.length.toDouble() * 6
                            //                   : 220,
                            //           child: middleFinger
                            //               ? Image.asset(
                            //                   'lib/assets/middleFinger.gif',
                            //                   height: 40,
                            //                 )
                            //               : Container())
                            //     ])),
                          ]),
                leading: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(avatarUrl),
                  ),
                ),
                subtitle: timeAgo == ""
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          timeAgo,
                          style: TextStyle(fontSize: 10),
                        ),
                      ),
                trailing: Text(''),
              )
            : Stack(
                children: [
                  ListTile(
                    // tileColor: Colors.blue[100],
                    title: isGroupChat
                        ? ChatBubble(
                            alignment: Alignment.centerRight,
                            clipper:
                                ChatBubbleClipper5(type: BubbleType.sendBubble),
                            backGroundColor: Colors.blue[200],
                            margin: EdgeInsets.only(top: 5),
                            child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Text(comment)))
                        : GestureDetector(
                            onLongPress: () => {
                                  showAlertDialog(context, chatId, gid, millis,
                                      isGroupChat, directMessageId)
                                },
                            child: Stack(children: [
                              ChatBubble(
                                  alignment: Alignment.centerRight,
                                  clipper: ChatBubbleClipper5(
                                      type: BubbleType.sendBubble),
                                  backGroundColor: Colors.blue[200],
                                  margin: EdgeInsets.only(top: 5),
                                  child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      child: Text(comment))),
                              Positioned(
                                  right: comment.length < 25
                                      ? comment.length.toDouble() * 8
                                      : comment.length < 40
                                          ? comment.length.toDouble() * 6
                                          : 220,
                                  child: status == 0
                                      ? Image.asset(
                                          'lib/assets/middleFinger.gif',
                                          height: 40,
                                        )
                                      : Container())
                            ])),
                    subtitle: timeAgo == ""
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              timeAgo,
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(avatarUrl),
                      ),
                    ),
                  ),
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
        content: Text("\nRegret sending that message?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);
              isGroupChat
                  ? messagesRef
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
