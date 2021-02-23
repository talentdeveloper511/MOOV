import 'dart:async';
import 'dart:ui';

import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/edit_group.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/add_users_post.dart';
import 'package:MOOV/widgets/chat.dart';
import 'package:MOOV/widgets/set_moov.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';

class MessagesHub extends StatelessWidget {
  Container buildNoContent() {
    return Container(
      color: TextThemes.ndBlue,
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

    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: messagesRef
                .where('peopleIds', arrayContains: currentUser.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data.docs.length == 0) {
                return Container(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 50.0),
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   SearchBarWithHeader()));
                        //     },
                        //     color: TextThemes.ndBlue,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Icon(Icons.message, color: TextThemes.ndGold),
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text('Message People and Businesses',
                        //                 style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: isLargePhone ? 17 : 14)),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8.0)),
                        //   ),
                        // ),
                        Text(
                          "When added to a Friend Group,\n it will appear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  )),
                );
              }

              return Container(
                // height: (snapshot.data.documents.length <= 3) ? 270 : 400,
                child: Column(
                  children: [
                    Expanded(
                        child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              }),

                          actions: [
                            IconButton(
                                icon: Icon(Icons.more_vert), onPressed: () {}),
                          ],
                          backgroundColor: TextThemes.ndBlue,
                          //pinned: true,
                          floating: false,
                          expandedHeight: 120.0,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Messages Hub',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        // SliverToBoxAdapter(
                        //     child: Padding(
                        //   padding: const EdgeInsets.all(25.0),
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) =>
                        //                   SearchBarWithHeader()));
                        //     },
                        //     color: TextThemes.ndBlue,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: Row(
                        //         mainAxisSize: MainAxisSize.min,
                        //         children: [
                        //           Icon(Icons.people, color: TextThemes.ndGold),
                        //           Padding(
                        //             padding: const EdgeInsets.all(8.0),
                        //             child: Text('Message People and Businesses',
                        //                 style: TextStyle(
                        //                     color: Colors.white,
                        //                     fontSize: isLargePhone ? 17 : 14)),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8.0)),
                        //   ),
                        // )),
                        SliverPadding(
                          padding: EdgeInsets.all(10),
                          sliver: SliverGrid.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                            childAspectRatio: 1.5,
                            children: <Widget>[
                              StreamBuilder(
                                  stream: usersRef
                                      .where("friendArray",
                                          arrayContains: currentUser.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();

                                    for (int i = 0;
                                        i < snapshot.data.docs.length;
                                        i++) {
                                      DocumentSnapshot course4 =
                                          snapshot.data.docs[i];

                                      return Container(
                                          decoration: BoxDecoration(
                                            color: TextThemes.ndBlue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MessageList()));
                                            },
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: new BackdropFilter(
                                                    filter:
                                                        new ImageFilter.blur(
                                                            sigmaX: 10.0,
                                                            sigmaY: 10.0),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Stack(children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        4.0),
                                                                child: currentUser
                                                                            .friendArray
                                                                            .length >
                                                                        1
                                                                    ? CircleAvatar(
                                                                        radius:
                                                                            20.0,
                                                                        backgroundImage: NetworkImage(snapshot
                                                                            .data
                                                                            .docs[0]['photoUrl']),
                                                                      )
                                                                    : Container()),
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 4,
                                                                        left:
                                                                            25.0),
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 20.0,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                    snapshot.data
                                                                            .docs[1]
                                                                        [
                                                                        'photoUrl'],
                                                                  ),
                                                                )),
                                                          ]),
                                                          Text("People",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20)),
                                                          BackdropFilter(
                                                              filter: ImageFilter
                                                                  .blur(
                                                                      sigmaX:
                                                                          3.0,
                                                                      sigmaY:
                                                                          3.0),
                                                              child:
                                                                  new Container(
                                                                decoration: new BoxDecoration(
                                                                    color: Colors
                                                                        .yellow
                                                                        .withOpacity(
                                                                            0.2)),
                                                              )),
                                                        ]))),
                                          ));
                                    }
                                  }),
                              StreamBuilder(
                                  stream: groupsRef
                                      .where("members",
                                          arrayContains: currentUser.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();

                                    for (int i = 0;
                                        i < snapshot.data.docs.length;
                                        i++) {
                                      DocumentSnapshot course4 =
                                          snapshot.data.docs[i];

                                      return Container(
                                          decoration: BoxDecoration(
                                            color: TextThemes.ndBlue,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: new BackdropFilter(
                                                  filter: new ImageFilter.blur(
                                                      sigmaX: 10.0,
                                                      sigmaY: 10.0),
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Stack(children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: currentUser
                                                                          .friendGroups
                                                                          .length >
                                                                      0
                                                                  ? Container(
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(15)),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl:
                                                                              course4['groupPic'],
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height: isLargePhone
                                                                              ? MediaQuery.of(context).size.height * 0.05
                                                                              : MediaQuery.of(context).size.height * 0.06,
                                                                          width: isLargePhone
                                                                              ? MediaQuery.of(context).size.width * 0.22
                                                                              : MediaQuery.of(context).size.width * 0.22,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container()),
                                                        ]),
                                                        Text("Friend Groups",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20)),
                                                        BackdropFilter(
                                                            filter: ImageFilter
                                                                .blur(
                                                                    sigmaX: 3.0,
                                                                    sigmaY:
                                                                        3.0),
                                                            child:
                                                                new Container(
                                                              decoration: new BoxDecoration(
                                                                  color: Colors
                                                                      .yellow
                                                                      .withOpacity(
                                                                          0.2)),
                                                            )),
                                                      ]))));
                                    }
                                  }),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10.0)),
                              height: 150,
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Last Active Conversation',
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 10),
                          sliver: SliverToBoxAdapter(
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: TextThemes.ndBlue),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: new BackdropFilter(
                                        filter: new ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Stack(children: [
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: CircleAvatar(
                                                        radius: 20.0,
                                                        child: Icon(
                                                            Icons.person,
                                                            color:
                                                                Colors.white),
                                                        backgroundColor:
                                                            TextThemes.ndGold,
                                                      ))
                                                ]),
                                                Text("Make A Friend",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                                BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 3.0,
                                                        sigmaY: 3.0),
                                                    child: new Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                              color: Colors
                                                                  .yellow
                                                                  .withOpacity(
                                                                      0.2)),
                                                    )),
                                              ]),
                                        )))),
                          ),
                        ),
                        SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              if (snapshot.data.docs.length == 0) {
                                return Container();
                              }

                              DocumentSnapshot course =
                                  snapshot.data.docs[index];
                              var length = course['members'].length - 2;
                              String groupId = course['groupId'];

                              // var rng = new Random();
                              // var l = rng.nextInt(course['members'].length);
                              // print(l);
                              // print(course['groupName']);

                              return StreamBuilder(
                                  stream: usersRef
                                      .where('friendGroups',
                                          arrayContains: groupId)
                                      .snapshots(),
                                  builder: (context, snapshot3) {
                                    if (!snapshot3.hasData)
                                      return CircularProgressIndicator();
                                    if (snapshot3.hasError ||
                                        snapshot3.data == null)
                                      return CircularProgressIndicator();

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        // color: Colors.white,
                                        clipBehavior: Clip.none,
                                        child: Stack(
                                          children: <Widget>[
                                            InkWell(
                                              // onTap: () {
                                              //   Navigator.push(
                                              //       context,
                                              //       MaterialPageRoute(
                                              //           builder: (context) =>
                                              //               MessageDetail(
                                              //                   groupId)));
                                              // },
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 5.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          border: Border.all(
                                                            width: 3,
                                                          )),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: course[
                                                              'groupPic'],
                                                          fit: BoxFit.cover,
                                                          height: isLargePhone
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.11
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.13,
                                                          width: isLargePhone
                                                              ? MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.35
                                                              : MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.35,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.5),
                                                    child: Center(
                                                      child: FittedBox(
                                                        child: Text(
                                                          course['groupName']
                                                              .toString(),
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  isLargePhone
                                                                      ? 20.0
                                                                      : 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              bottom: isLargePhone ? 80 : 70,
                                              right: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(4.0),
                                                        child: course['members']
                                                                    .length >
                                                                1
                                                            ? CircleAvatar(
                                                                radius: 20.0,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  snapshot3.data
                                                                          .docs[1]
                                                                      [
                                                                      'photoUrl'],
                                                                ),
                                                              )
                                                            : Container()),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 4,
                                                                left: 20.0),
                                                        child: CircleAvatar(
                                                          radius: 20.0,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            snapshot3.data
                                                                    .docs[0]
                                                                ['photoUrl'],
                                                          ),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              left: 40.0),
                                                      child: CircleAvatar(
                                                        radius: 20.0,
                                                        child: course['members']
                                                                    .length >
                                                                2
                                                            ? Text(
                                                                "+" +
                                                                    (length
                                                                        .toString()),
                                                                style: TextStyle(
                                                                    color: TextThemes
                                                                        .ndGold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              )
                                                            : Text(
                                                                (course['members']
                                                                    .length
                                                                    .toString()),
                                                                style: TextStyle(
                                                                    color: TextThemes
                                                                        .ndGold,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                        backgroundColor:
                                                            TextThemes.ndBlue,
                                                      ),
                                                    ),
                                                  ])
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }, childCount: snapshot.data.docs.length),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            )),
                      ],
                    )),
                  ],
                ),
              );
            }));
  }
}

class MessageList extends StatelessWidget {
  const MessageList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: StreamBuilder(
          stream: messagesRef //featured
              .where("people", arrayContains: currentUser.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.docs.length == 0)
              return Center(
                child: Text(
                    "No featured MOOVs. \n\n Got a feature? Email admin@whatsthemoov.com.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
              );

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot course = snapshot.data.docs[index];

                // if (aDate == today) {
                //   isToday = true;
                // }

                return GestureDetector(
                  onTap: () {
                    Chat(
                        gid: "",
                        groupPic: course['people'],
                        directMessageId: course['directMessageId']);
                  },
                  child: Container(
                    height: 140,
                    child: Row(
                      children: [
                        Text("",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}

// class MessageDetail extends StatefulWidget {
//   String directMessageId;

//   MessageDetail(this.directMessageId);

//   @override
//   State<StatefulWidget> createState() {
//     return _MessageDetailState(this.directMessageId);
//   }
// }

// class _MessageDetailState extends State<MessageDetail> {
//   String directMessageId, groupName, groupPic, nextMOOV;
//   List<dynamic> members;

//   bool member;
//   final dbRef = FirebaseFirestore.instance;

//   _MessageDetailState(this.directMessageId);

//   sendChat() {
//     Database().sendChat(currentUser.displayName, chatController.text, directMessageId);
//   }

//   bool requestsent = false;
//   TextEditingController chatController = TextEditingController();
//   bool sendRequest = false;
//   bool friends;

//   var userRequests;
//   final GoogleSignInAccount userMe = googleSignIn.currentUser;
//   final strUserId = currentUser.id;
//   final strPic = currentUser.photoUrl;
//   final strUserName = currentUser.displayName;
//   var profilePic;
//   var otherDisplay;
//   int id = 0;
//   var iter = 1;
//   int status = 0;

//   void refreshData() {
//     id++;
//   }

//   FutureOr onGoBack(dynamic value) {
//     refreshData();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     Map<String, dynamic> voters = {};

//     bool isLargePhone = Screen.diagonal(context) > 766;

//     return StreamBuilder(
//         stream: messagesRef.where('people', arrayContains: currentUser.id).snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return CircularProgressIndicator();
//           if (snapshot.data == null) return Container();

//           return StreamBuilder(
//               stream: groupsRef.doc(directMessageId).snapshots(),
//               builder: (context, snapshot2) {
//                 if (!snapshot2.hasData) return CircularProgressIndicator();
//                 if (snapshot2.data == null) return Container();

//                 DocumentSnapshot course = snapshot2.data;

//                 return
//                    Scaffold(
//                         backgroundColor: Colors.white,
//                         appBar: AppBar(
//                             leading: IconButton(
//                               icon: Icon(
//                                 Icons.arrow_back,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             backgroundColor: TextThemes.ndBlue,
//                             flexibleSpace: FlexibleSpaceBar(
//                               titlePadding: EdgeInsets.all(15),
//                               title: ConstrainedBox(
//                                 constraints: BoxConstraints(maxWidth: 210),
//                                 child: Text(
//                                   groupName,
//                                   style: TextStyle(
//                                       fontSize: isLargePhone ? 30.0 : 22,
//                                       color: Colors.white),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                             ),
//                             actions: <Widget>[

//                               FocusedMenuHolder(
//                                 menuWidth:
//                                     MediaQuery.of(context).size.width * 0.50,
//                                 blurSize: 5.0,
//                                 menuItemExtent: 45,
//                                 menuBoxDecoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.all(
//                                         Radius.circular(15.0))),
//                                 duration: Duration(milliseconds: 100),
//                                 animateMenuItems: true,
//                                 blurBackgroundColor: Colors.black54,
//                                 openWithTap:
//                                     true, // Open Focused-Menu on Tap rather than Long Press
//                                 menuOffset:
//                                     10.0, // Offset value to show menuItem from the selected item
//                                 bottomOffsetHeight:
//                                     80.0, // Offset height to consider, for showing the menu item ( for Suggestions bottom navigation bar), so that the popup menu will be shown on top of selected item.
//                                 menuItems: <FocusedMenuItem>[
//                                   // Add Each FocusedMenuItem  for Menu Options

//                                   FocusedMenuItem(
//                                       title: Text("Add Friends"),
//                                       trailingIcon: Icon(Icons.person_add),
//                                       onPressed: () {
//                                         Navigator.push(
//                                             context,
//                                             PageTransition(
//                                                 type: PageTransitionType
//                                                     .bottomToTop,
//                                                 child: SearchUsersGroup(
//                                                     groupName,
//                                                     gid,
//                                                     groupPic,
//                                                     nextMOOV,
//                                                     members)));
//                                       }),

//                                   FocusedMenuItem(
//                                       title: Text("Share"),
//                                       trailingIcon: Icon(Icons.send),
//                                       onPressed: () {
//                                         // Share.share(
//                                         //     "You found the Easter Egg! 🥚");
//                                       }),
//                                   FocusedMenuItem(
//                                       title: Text("Edit Group"),
//                                       trailingIcon: Icon(Icons.edit),
//                                       onPressed: () {
//                                         //edit group
//                                       }),
//                                   FocusedMenuItem(
//                                       title: Text(
//                                         "Leave Group",
//                                         style:
//                                             TextStyle(color: Colors.redAccent),
//                                       ),
//                                       trailingIcon: Icon(
//                                         Icons.directions_walk,
//                                         color: Colors.redAccent,
//                                       ),
//                                       onPressed: () {
//                                       }),
//                                 ],
//                                 onPressed: () {},
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(
//                                     Icons.more_vert,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ),
//                             ]),
//                         body: SingleChildScrollView(
//                           child: Container(
//                             child: Column(
//                               children: [
//                                 Stack(children: [
//                                   Container(
//                                       height: 200,
//                                       width: MediaQuery.of(context).size.width,
//                                       child: Image.network(groupPic,
//                                           fit: BoxFit.cover)),
//                                   Container(
//                                       child: Column(children: [
//                                     Container(
//                                       height: 200,
//                                       child: ListView.builder(
//                                           scrollDirection: Axis.horizontal,
//                                           physics:
//                                               AlwaysScrollableScrollPhysics(),
//                                           itemCount: members.length,
//                                           itemBuilder: (_, index) {
//                                             DocumentSnapshot course =
//                                                 snapshot2.data;

//                                             return Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 8.0, right: 8),
//                                               child: Container(
//                                                 height: 200,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.start,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: <Widget>[
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               top: 30.0,
//                                                               bottom: 10),
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           if (snapshot.data
//                                                                           .docs[
//                                                                       index]
//                                                                   ['id'] ==
//                                                               strUserId) {
//                                                             Navigator.of(
//                                                                     context)
//                                                                 .push(MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             ProfilePageWithHeader()));
//                                                           } else {
//                                                             Navigator.of(context).push(
//                                                                 MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             OtherProfile(
//                                                                               snapshot.data.docs[index]['id'],
//                                                                             )));
//                                                           }
//                                                         },
//                                                         child: CircleAvatar(
//                                                           radius: 54,
//                                                           backgroundColor:
//                                                               TextThemes.ndGold,
//                                                           child: CircleAvatar(
//                                                             // backgroundImage: snapshot.data
//                                                             //     .documents[index].data['photoUrl'],
//                                                             backgroundImage:
//                                                                 NetworkImage(snapshot
//                                                                             .data
//                                                                             .docs[
//                                                                         index][
//                                                                     'photoUrl']),
//                                                             radius: 50,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Container(
//                                                       alignment:
//                                                           Alignment(0.0, 0.0),
//                                                       child: Container(
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           20)),
//                                                           gradient:
//                                                               LinearGradient(
//                                                             begin: Alignment
//                                                                 .topCenter,
//                                                             end: Alignment
//                                                                 .bottomCenter,
//                                                             colors: <Color>[
//                                                               Colors.black
//                                                                   .withAlpha(0),
//                                                               Colors.black,
//                                                               Colors.black12,
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         child: Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(4.0),
//                                                           child: Text(
//                                                             snapshot.data
//                                                                     .docs[index]
//                                                                 ['displayName'],
//                                                             style: TextStyle(
//                                                                 fontFamily:
//                                                                     'Solway',
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold,
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 16.0),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           }),
//                                     )
//                                   ])),
//                                 ]);}
