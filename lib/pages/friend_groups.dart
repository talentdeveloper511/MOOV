import 'dart:math';

import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_group.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePageWithHeader.dart';

class FriendGroupsPage extends StatefulWidget {
  @override
  _FriendGroupsState createState() {
    return _FriendGroupsState();
  }
}

class _FriendGroupsState extends State<FriendGroupsPage>
    with AutomaticKeepAliveClientMixin {
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   backgroundColor: TextThemes.ndBlue,
        //   title: Text(
        //     "Friend Groups",
        //     style: TextStyle(color: Colors.white, fontSize: 25),
        //   ),
        // ),
        body: StreamBuilder(
            stream: groupsRef
                .where('members', arrayContains: currentUser.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data.docs.length == 0) {
                return Container(
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        SizedBox(height: 75),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50.0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupForm()));
                            },
                            color: TextThemes.ndBlue,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.people, color: TextThemes.ndGold),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Create Friend Group',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),
                                ],
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                          ),
                        ),
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

              return CustomScrollView(
                slivers: [
              SliverToBoxAdapter(
                  child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupForm()));
                  },
                  color: TextThemes.ndBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.people, color: TextThemes.ndGold),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Create Friend Group',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22)),
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
              )),
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
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupDetail(
                                                      groupId)));
                                    },
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
                                                  color: TextThemes
                                                      .ndBlue,
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
              );
            }));
  }
}
