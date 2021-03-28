import 'dart:async';
import 'dart:math';
import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/MessagesHub.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/home.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  final String gid, directMessageId, otherPerson;
  final bool isGroupChat;
  final List<dynamic> members;
  Map<String, String> sendingPost;

  Chat(
      {this.gid,
      this.isGroupChat,
      this.directMessageId,
      this.otherPerson,
      this.members,
      this.sendingPost});

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
              MessageDetail(directMessageId, otherPerson, false, " ", [], {}),
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
    Map<String, dynamic> livePosts = {}; //for moovs sent in chats

    if (directMessageId == null) {
      circularProgress();
    }
    if (directMessageId == "nothing" || directMessageId == null) {
      //if this is first message in conversation, we set the message ID
      directMessageId = currentUser.id + otherPerson;
    }

    if (widget.sendingPost != null && widget.sendingPost.isNotEmpty) {
      //if someone is sending the MOOV
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
              "comment": widget.sendingPost['postId'],
              "timestamp": 0,
              "avatarUrl": currentUser.photoUrl,
              "userId": currentUser.id,
              "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id,
              "gid": gid,
              "millis": DateTime.now().millisecondsSinceEpoch.toString(),
              "directMessageId": "",
              "isGroupChat": true,
              "postId": widget.sendingPost['postId']
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
              "comment": widget.sendingPost['postId'],
              "timestamp": 0,
              "avatarUrl": currentUser.photoUrl,
              "userId": currentUser.id,
              "chatId": DateTime.now().millisecondsSinceEpoch.toString() +
                  " " +
                  currentUser.id,
              "gid": " ",
              "directMessageId": directMessageId,
              "isGroupChat": false,
              "millis": DateTime.now().millisecondsSinceEpoch.toString(),
              "postId": widget.sendingPost['postId']
            });

      if (commentController.text.isNotEmpty) {
        //the message "Caption" sent with a MOOV accompanies a moov
        isGroupChat
            ? messagesRef
                .doc(gid)
                .collection("chat")
                .doc(DateTime.now()
                        .add(Duration(milliseconds: 1))
                        .millisecondsSinceEpoch
                        .toString() +
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
                "postId": null
              })
            : messagesRef
                .doc(directMessageId)
                .collection("chat")
                .doc(DateTime.now()
                        .add(Duration(milliseconds: 1))
                        .millisecondsSinceEpoch
                        .toString() +
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
                "postId": null
              });
      }
      if (!livePosts.containsKey(widget.sendingPost['postId'])) {
        livePosts[widget.sendingPost['postId']] = currentUser.id;
      }

      isGroupChat
          ? messagesRef.doc(gid).set({
              "lastMessage": "Sent a MOOV",
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": gid,
              "directMessageId": directMessageId,
              "people": members,
              "isGroupChat": true,
              "livePosts": livePosts
            }, SetOptions(merge: true))
          : messagesRef.doc(directMessageId).set({
              "lastMessage": "Sent a MOOV",
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": "",
              "directMessageId": directMessageId,
              "people": [currentUser.id, otherPerson],
              "isGroupChat": false,
              "livePosts": livePosts
            }, SetOptions(merge: true));

      setState(() {
        widget.sendingPost = null;
      });

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

    if (commentController.text.isNotEmpty && widget.sendingPost.isEmpty) {
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
              "postId": null
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
              "postId": null
            });
      isGroupChat
          ? messagesRef.doc(gid).set({
              "lastMessage": widget.sendingPost.isNotEmpty
                  ? "Sent a MOOV"
                  : commentController.text,
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": gid,
              "directMessageId": directMessageId,
              "people": members,
              "isGroupChat": true,
              "livePosts": livePosts
            }, SetOptions(merge: true))
          : messagesRef.doc(directMessageId).set({
              "lastMessage": widget.sendingPost.isNotEmpty
                  ? "Sent a MOOV"
                  : commentController.text,
              "seen": false,
              "sender": currentUser.id,
              "receiver": otherPerson,
              "timestamp": DateTime.now().millisecondsSinceEpoch,
              "gid": "",
              "directMessageId": directMessageId,
              "people": [currentUser.id, otherPerson],
              "isGroupChat": false,
              "livePosts": livePosts
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
          widget.sendingPost != null && widget.sendingPost.isNotEmpty
              ? ChatMOOV(widget.sendingPost['postId'],
                  widget.sendingPost['pic'], widget.sendingPost['title'])
              : Container(),
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
                                            otherPerson, false, " ", [], {}),
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
  final String directMessageId, postId;
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
      this.isGroupChat,
      this.postId});

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
      postId: doc['postId'],
    );
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
      this.postId);
}

class _CommentState extends State<Comment> {
  final String displayName;
  final String userId;
  final String avatarUrl;
  final String comment;
  final int timestamp;
  final String chatId;
  final String gid;
  final String millis, postId;
  String directMessageId;
  final bool isGroupChat;

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
      this.postId);

  final Map<String, dynamic> chatPostResponses = {};

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
    // List reactionValues = reactions.values.toList();
    // if (reactions.isNotEmpty && reactionValues[0] == 0) {
    //   middleFinger = true;
    // }
    if (timestamp == 0) {
      timeAgo = "";
    }

    String chatStatus = "";
    String title = "";

    if (postId != null) {
      postId.contains("goingxxx")
          ? chatStatus = " is GOING to"
          : postId.contains("undecidedxxx")
              ? chatStatus = " is UNDECIDED on"
              : postId.contains("notxxx")
                  ? chatStatus = " is NOT GOING to"
                  : chatStatus = "";
      title = postId
          .replaceAll("goingxxx", "")
          .replaceAll("undecidedxxx", "")
          .replaceAll("notxxx", "");
    }

    return Column(
      children: <Widget>[
        Container(
          child: comment == "thisWillTurnIntoAStatus"
              ? Column(children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(text: "——— "),
                          TextSpan(
                            text: displayName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text: chatStatus,
                              style: TextStyle(
                                  color: chatStatus == " is GOING to"
                                      ? Colors.green[600]
                                      : chatStatus == " is UNDECIDED on"
                                          ? Colors.yellow[600]
                                          : Colors.red[600],
                                  fontWeight: FontWeight.bold)),
                          TextSpan(
                            text: title,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(text: " ———"),
                        ]),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: ExpandablePanel(
                          // controller: _expandableController,
                          theme: const ExpandableThemeData(
                            hasIcon: false,
                            tapHeaderToExpand: true,
                            headerAlignment:
                                ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                "View all statuses",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 12),
                              ),
                            ),
                          ),
                          expanded: ChatStatuses(avatarUrl, gid)))
                ])
              : Container(
                  child: (userId != currentUser.id)
                      ? Container(
                          child: postId != null &&
                                  !postId.contains("goingxxx") &&
                                  !postId.contains("undecidedxxx") &&
                                  !postId.contains("notxxx")
                              ? FutureBuilder(
                                  future: postsRef.doc(postId).get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.connectionState !=
                                            ConnectionState.done) {
                                      circularProgress();
                                    }
                                    return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ChatMOOV(
                                                  postId,
                                                  snapshot.data['image'],
                                                  snapshot.data['title']),
                                              timeAgo == ""
                                                  ? Container()
                                                  : Text(
                                                      timeAgo,
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0, right: 8),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      avatarUrl),
                                            ),
                                          ),
                                        ]);
                                  })
                              : ListTile(
                                  // tileColor: Colors.blue[100],
                                  title: ChatBubble(
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
                                  // :
                                  // FlutterReactionButtonCheck(
                                  //     onReactionChanged: (reaction, index, isChecked) {
                                  //       // FLIPPED OFF NOTIF HERE
                                  //       // if (reactionValues[0] == 0) {
                                  //       //   setState(() {
                                  //       //     middleFinger = false;
                                  //       //   });
                                  //       // } else
                                  //       //  if (reactionValues[0] == 1) {
                                  //       //   setState(() {
                                  //       //     middleFinger = false;
                                  //       //   });
                                  //       // }
                                  //       // // } else {
                                  //       // //   setState(() {
                                  //       // //     reactionValues[0] = -1;
                                  //       // //   });
                                  //       // // }
                                  //       // Database().chatReaction(currentUser.id,
                                  //       //     directMessageId, chatId, index, false);
                                  //       // setState(() {
                                  //       //   middleFinger = !middleFinger;
                                  //       // });

                                  //       // print(reactionValues[0]);
                                  //       // print(middleFinger);
                                  //     },
                                  //     reactions: [
                                  //         Reaction(
                                  //             previewIcon: Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     right: 8.0, top: 6, bottom: 6, left: 8),
                                  //                 child: Text("Coming soon")),
                                  //             // previewIcon: Padding(
                                  //             //   padding: const EdgeInsets.only(
                                  //             //       right: 8.0, top: 4, bottom: 6),
                                  //             //   child: Image.asset(
                                  //             //     'lib/assets/middleFinger.gif',
                                  //             //     height: 40,
                                  //             //   ),
                                  //             // ),
                                  //             // title: Text("Flip 'em off"),
                                  //             icon: Stack(children: [
                                  //               ChatBubble(
                                  //                   alignment: Alignment.centerLeft,
                                  //                   clipper: ChatBubbleClipper5(
                                  //                       type: BubbleType.receiverBubble),
                                  //                   backGroundColor: Colors.grey[200],
                                  //                   margin: EdgeInsets.only(top: 5),
                                  //                   child: Container(
                                  //                       constraints: BoxConstraints(
                                  //                         maxWidth: MediaQuery.of(context)
                                  //                                 .size
                                  //                                 .width *
                                  //                             0.7,
                                  //                       ),
                                  //                       child: Text(comment))),
                                  //               Positioned(
                                  //                   left: comment.length < 25
                                  //                       ? comment.length.toDouble() * 8
                                  //                       : comment.length < 40
                                  //                           ? comment.length.toDouble() * 6
                                  //                           : 220,
                                  //                   child: middleFinger
                                  //                       ? Image.asset(
                                  //                           'lib/assets/middleFinger.gif',
                                  //                           height: 40,
                                  //                         )
                                  //                       : Container())
                                  //             ])
                                  //             ),
                                  //         // Reaction(
                                  //         //     // previewIcon: Padding(
                                  //         //     //   padding: const EdgeInsets.only(
                                  //         //     //       right: 8.0, top: 4, bottom: 6),
                                  //         //     //   child: Image.asset(
                                  //         //     //     'lib/assets/chens.jpg',
                                  //         //     //     height: 40,
                                  //         //     //   ),
                                  //         //     // ),
                                  //         //     // title: Text("Flip 'em off"),
                                  //         //     icon: Stack(children: [
                                  //         //       ChatBubble(
                                  //         //           alignment: Alignment.centerLeft,
                                  //         //           clipper: ChatBubbleClipper5(
                                  //         //               type: BubbleType.receiverBubble),
                                  //         //           backGroundColor: Colors.grey[200],
                                  //         //           margin: EdgeInsets.only(top: 5),
                                  //         //           child: Container(
                                  //         //               constraints: BoxConstraints(
                                  //         //                 maxWidth: MediaQuery.of(context)
                                  //         //                         .size
                                  //         //                         .width *
                                  //         //                     0.7,
                                  //         //               ),
                                  //         //               child: Text(comment))),
                                  //         //       Positioned(
                                  //         //           left: comment.length < 25
                                  //         //               ? comment.length.toDouble() * 8
                                  //         //               : comment.length < 40
                                  //         //                   ? comment.length.toDouble() * 6
                                  //         //                   : 220,
                                  //         //           child: middleFinger
                                  //         //               ? Image.asset(
                                  //         //                   'lib/assets/middleFinger.gif',
                                  //         //                   height: 40,
                                  //         //                 )
                                  //         //               : Container())
                                  //         //     ])),
                                  //       ]),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(avatarUrl),
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
                                ),
                        )
                      : Container(
                          child: postId != null &&
                                  !postId.contains("going") &&
                                  !postId.contains("undecided") &&
                                  !postId.contains("notGoing")
                              ? FutureBuilder(
                                  future: postsRef.doc(postId).get(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.connectionState !=
                                            ConnectionState.done ||
                                        snapshot.data == null) {
                                      return circularProgress();
                                    }
                                    return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              ChatMOOV(
                                                  postId,
                                                  snapshot.data['image'],
                                                  snapshot.data['title']),
                                              timeAgo == ""
                                                  ? Container()
                                                  : Text(
                                                      timeAgo,
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12.0, left: 8),
                                            child: CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      avatarUrl),
                                            ),
                                          ),
                                        ]);
                                  })
                              : Stack(
                                  children: [
                                    ListTile(
                                      // tileColor: Colors.blue[100],
                                      title: GestureDetector(
                                          onLongPress: () => {
                                                showAlertDialog(
                                                    context,
                                                    chatId,
                                                    gid,
                                                    millis,
                                                    isGroupChat,
                                                    directMessageId)
                                              },
                                          child: Stack(children: [
                                            ChatBubble(
                                                alignment:
                                                    Alignment.centerRight,
                                                clipper: ChatBubbleClipper5(
                                                    type:
                                                        BubbleType.sendBubble),
                                                backGroundColor:
                                                    Colors.blue[200],
                                                margin: EdgeInsets.only(top: 5),
                                                child: Container(
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                    ),
                                                    child: Text(comment))),
                                            Positioned(
                                                right: comment.length < 25
                                                    ? comment.length
                                                            .toDouble() *
                                                        8
                                                    : comment.length < 40
                                                        ? comment.length
                                                                .toDouble() *
                                                            6
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
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Text(
                                                timeAgo,
                                                textAlign: TextAlign.right,
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                      trailing: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  avatarUrl),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )),
        )
      ],
    );
  }

  void showAlertDialog(
      BuildContext context, chatId, gid, millis, isGroupChat, directMessageId) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
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

class ChatMOOV extends StatelessWidget {
  final String postId, pic, title;
  ChatMOOV(this.postId, this.pic, this.title);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Container(
      //this is for sending a MOOV or image message
      // width: width * 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Container(
              height: isLargePhone
                  ? SizeConfig.blockSizeVertical * 09
                  : SizeConfig.blockSizeVertical * 10,
              width: 200,
              child: OpenContainer(
                transitionType: ContainerTransitionType.fade,
                transitionDuration: Duration(milliseconds: 500),
                openBuilder: (context, _) => PostDetail(postId),
                closedElevation: 0,
                closedBuilder: (context, _) => Stack(children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: pic,
                            fit: BoxFit.cover,
                          ),
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment(0.0, 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.black.withAlpha(0),
                                Colors.black,
                                Colors.black12,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Solway',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Buttons(postId)
          ],
        ),
      ),
    );
  }
}

class ChatStatuses extends StatelessWidget {
  final String postId, gid;
  const ChatStatuses(this.postId, this.gid);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: postsRef.doc(postId).snapshots(),
        builder: (context, snapshot) {
          Map<String, dynamic> statuses = snapshot.data['statuses'];
          print(statuses.keys.where((element) => false));

          return Center(
            child: Container(
                height: 100.0,
                width: MediaQuery.of(context).size.width * .95,
                color: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 75,
                          width: MediaQuery.of(context).size.width * .3,
                          decoration: BoxDecoration(
                              color: Colors.red[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        Container(
                          height: 75,
                          width: MediaQuery.of(context).size.width * .3,
                          decoration: BoxDecoration(
                              color: Colors.yellow[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        Container(
                          height: 75,
                          width: MediaQuery.of(context).size.width * .3,
                          decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        )
                      ],
                    ))),
          );
        });
  }
}
