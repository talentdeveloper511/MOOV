import 'dart:ui';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/home.dart';

import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/chat.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: messagesRef
                .where('people', arrayContains: currentUser.id)
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
                              child: Stack(children: [
                                StreamBuilder(
                                    stream: messagesRef
                                        .where('people',
                                            arrayContains: currentUser.id)
                                        .orderBy("timestamp")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) return Container();
                                      if (snapshot.data.docs.length == 0) {
                                        return Container();
                                      }
                                      for (int i = 0;
                                          i < snapshot.data.docs.length;
                                          i++) {
                                        DocumentSnapshot course =
                                            snapshot.data.docs[i];
                                        List people = course['people'];
                                        people.removeWhere(
                                            (item) => item == currentUser.id);
                                        String otherPerson = people[0];
                                        return Container(
                                          height: 100,
                                          child: Chat(
                                            gid: "",
                                            directMessageId:
                                                course['directMessageId'],
                                            otherPerson: otherPerson,
                                          ),
                                        );
                                      }
                                      return Container();
                                    }),
                                Text('Last Active Conversation',
                                    style: TextStyle(fontSize: 18)),
                              ]),
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
                        // SliverGrid(
                        //     delegate: SliverChildBuilderDelegate(
                        //         (BuildContext context, int index) {
                        //       if (!snapshot.hasData)
                        //         return CircularProgressIndicator();
                        //       if (snapshot.data.docs.length == 0) {
                        //         return Container();
                        //       }

                        //       DocumentSnapshot course =
                        //           snapshot.data.docs[index];
                        //       var length = course['members'].length - 2;
                        //       String groupId = course['groupId'];

                        //       // var rng = new Random();
                        //       // var l = rng.nextInt(course['members'].length);
                        //       // print(l);
                        //       // print(course['groupName']);

                        //       return StreamBuilder(
                        //           stream: usersRef
                        //               .where('friendGroups',
                        //                   arrayContains: groupId)
                        //               .snapshots(),
                        //           builder: (context, snapshot3) {
                        //             if (!snapshot3.hasData)
                        //               return CircularProgressIndicator();
                        //             if (snapshot3.hasError ||
                        //                 snapshot3.data == null)
                        //               return CircularProgressIndicator();

                        //             return Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: Container(
                        //                 // color: Colors.white,
                        //                 clipBehavior: Clip.none,
                        //                 child: Stack(
                        //                   children: <Widget>[
                        //                     InkWell(
                        //                       // onTap: () {
                        //                       //   Navigator.push(
                        //                       //       context,
                        //                       //       MaterialPageRoute(
                        //                       //           builder: (context) =>
                        //                       //               MessageDetail(
                        //                       //                   groupId)));
                        //                       // },
                        //                       child: Column(
                        //                         children: [
                        //                           Padding(
                        //                             padding:
                        //                                 const EdgeInsets.only(
                        //                                     bottom: 5.0),
                        //                             child: Container(
                        //                               decoration: BoxDecoration(
                        //                                   borderRadius:
                        //                                       BorderRadius.all(
                        //                                           Radius
                        //                                               .circular(
                        //                                                   20)),
                        //                                   border: Border.all(
                        //                                     width: 3,
                        //                                   )),
                        //                               child: ClipRRect(
                        //                                 borderRadius:
                        //                                     BorderRadius.all(
                        //                                         Radius.circular(
                        //                                             15)),
                        //                                 child:
                        //                                     CachedNetworkImage(
                        //                                   imageUrl: course[
                        //                                       'groupPic'],
                        //                                   fit: BoxFit.cover,
                        //                                   height: isLargePhone
                        //                                       ? MediaQuery.of(
                        //                                                   context)
                        //                                               .size
                        //                                               .height *
                        //                                           0.11
                        //                                       : MediaQuery.of(
                        //                                                   context)
                        //                                               .size
                        //                                               .height *
                        //                                           0.13,
                        //                                   width: isLargePhone
                        //                                       ? MediaQuery.of(
                        //                                                   context)
                        //                                               .size
                        //                                               .width *
                        //                                           0.35
                        //                                       : MediaQuery.of(
                        //                                                   context)
                        //                                               .size
                        //                                               .width *
                        //                                           0.35,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                           Padding(
                        //                             padding:
                        //                                 const EdgeInsets.all(
                        //                                     12.5),
                        //                             child: Center(
                        //                               child: FittedBox(
                        //                                 child: Text(
                        //                                   course['groupName']
                        //                                       .toString(),
                        //                                   maxLines: 2,
                        //                                   style: TextStyle(
                        //                                       color:
                        //                                           Colors.black,
                        //                                       fontSize:
                        //                                           isLargePhone
                        //                                               ? 20.0
                        //                                               : 18,
                        //                                       fontWeight:
                        //                                           FontWeight
                        //                                               .bold),
                        //                                   textAlign:
                        //                                       TextAlign.center,
                        //                                   overflow: TextOverflow
                        //                                       .ellipsis,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ),
                        //                     Positioned(
                        //                       bottom: isLargePhone ? 80 : 70,
                        //                       right: 20,
                        //                       child: Row(
                        //                         mainAxisAlignment:
                        //                             MainAxisAlignment.center,
                        //                         children: [
                        //                           Stack(children: [
                        //                             Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                         .all(4.0),
                        //                                 child: course['members']
                        //                                             .length >
                        //                                         1
                        //                                     ? CircleAvatar(
                        //                                         radius: 20.0,
                        //                                         backgroundImage:
                        //                                             NetworkImage(
                        //                                           snapshot3.data
                        //                                                   .docs[1]
                        //                                               [
                        //                                               'photoUrl'],
                        //                                         ),
                        //                                       )
                        //                                     : Container()),
                        //                             Padding(
                        //                                 padding:
                        //                                     const EdgeInsets
                        //                                             .only(
                        //                                         top: 4,
                        //                                         left: 20.0),
                        //                                 child: CircleAvatar(
                        //                                   radius: 20.0,
                        //                                   backgroundImage:
                        //                                       NetworkImage(
                        //                                     snapshot3.data
                        //                                             .docs[0]
                        //                                         ['photoUrl'],
                        //                                   ),
                        //                                 )),
                        //                             Padding(
                        //                               padding:
                        //                                   const EdgeInsets.only(
                        //                                       top: 4,
                        //                                       left: 40.0),
                        //                               child: CircleAvatar(
                        //                                 radius: 20.0,
                        //                                 child: course['members']
                        //                                             .length >
                        //                                         2
                        //                                     ? Text(
                        //                                         "+" +
                        //                                             (length
                        //                                                 .toString()),
                        //                                         style: TextStyle(
                        //                                             color: TextThemes
                        //                                                 .ndGold,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w500),
                        //                                       )
                        //                                     : Text(
                        //                                         (course['members']
                        //                                             .length
                        //                                             .toString()),
                        //                                         style: TextStyle(
                        //                                             color: TextThemes
                        //                                                 .ndGold,
                        //                                             fontWeight:
                        //                                                 FontWeight
                        //                                                     .w500),
                        //                                       ),
                        //                                 backgroundColor:
                        //                                     TextThemes.ndBlue,
                        //                               ),
                        //                             ),
                        //                           ])
                        //                         ],
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ),
                        //             );
                        //           });
                        //     }, childCount: snapshot.data.docs.length),
                        //     gridDelegate:
                        //         SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 2,
                        //     )),
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
      body: StreamBuilder(
          stream: messagesRef //featured
              .where("people", arrayContains: currentUser.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.docs.length == 0)
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 75.0),
                child: RaisedButton(
                  onPressed: () => null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "New Conversation",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              );

            return ListView.builder(
              itemCount: snapshot.data.docs.length + 1,
              itemBuilder: (context, index) {
                //adding da button
                if (index == snapshot.data.docs.length) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75.0),
                    child: RaisedButton(
                      onPressed: () => null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "New Conversation",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                DocumentSnapshot course = snapshot.data.docs[index];
                // print(course['people']);
                List people = course['people'];
                people.removeWhere((item) => item == currentUser.id);
                String otherPerson = people[0];
                Timestamp timestamp = course['timestamp'];

                return StreamBuilder(
                    stream: usersRef.doc(otherPerson).snapshots(),
                    builder: (context, snapshot) {
                      print(index);
                      if (!snapshot.hasData || snapshot.data == null) {
                        return circularProgress();
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessageDetail(
                                      course['directMessageId'], otherPerson)));
                        },
                        child: Container(
                          height: 140,
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 20.0, right: 20),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                      snapshot.data['photoUrl'],
                                    ),
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .46,
                                child: Text(course['lastMessage'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.grey[700])),
                              ),
                              Text(
                                timeago.format(timestamp.toDate()),
                                style: TextStyle(fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }),
    );
  }
}

class MessageDetail extends StatelessWidget {
  final String otherPerson, directMessageId;
  MessageDetail(this.directMessageId, this.otherPerson);

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
                  child: StreamBuilder(
                      stream: usersRef.doc(otherPerson).snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return circularProgress();
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    NetworkImage(snapshot.data['photoUrl']),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapshot.data['displayName'],
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        );
                      })),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Chat(
                  gid: "",
                  isGroupChat: false,
                  directMessageId: directMessageId,
                  otherPerson: otherPerson),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      "Welcome to MOOV DM's.",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "\nHave a funny conversation? Get someone's number? Screenshot it (phone number's blurred), and submit it here for a chance to get featured and win \$20!",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 75.0),
                      child: RaisedButton(
                        onPressed: () => null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Submit",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
