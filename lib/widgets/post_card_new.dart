
import 'dart:async';

import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/Friends_List.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MessagesHub.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/edit_post.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/pointAnimation.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/send_moov.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'dart:math';

import 'package:MOOV/helpers/themes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/home.dart';
import 'package:like_button/like_button.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:page_transition/page_transition.dart';

class PostOnFeedNew extends StatefulWidget {
  final DocumentSnapshot course;
  PostOnFeedNew(this.course);

  @override
  _PostOnFeedNewState createState() => _PostOnFeedNewState();
}

class _PostOnFeedNewState extends State<PostOnFeedNew> {
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    int goingCount = widget.course['going'].length ?? 0;
    Timestamp startDate = widget.course["startDate"];
    String privacy = widget.course['privacy'];
    int venmo = widget.course['venmo'];
    int maxOccupancy = widget.course['maxOccupancy'];
    if (startDate.millisecondsSinceEpoch <
        Timestamp.now().millisecondsSinceEpoch - 3600000) {
      print("Expired. See ya later.");
      Future.delayed(const Duration(milliseconds: 1000), () {
        Database().deletePost(
            widget.course['postId'],
            widget.course['userId'],
            widget.course['title'],
            widget.course['statuses'],
            widget.course['posterName']);
      });
    }
    final now = DateTime.now();
    bool isToday = false;
    bool isTomorrow = false;

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    final dateToCheck = startDate.toDate();
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    if (aDate == today) {
      isToday = true;
    } else if (aDate == tomorrow) {
      isTomorrow = true;
    }

    return Column(
      children: [
        Stack(alignment: Alignment.center, children: <Widget>[
          OpenContainer(
            transitionType: ContainerTransitionType.fade,
            transitionDuration: Duration(milliseconds: 500),
            openBuilder: (context, _) => PostDetail(widget.course.id),
            closedElevation: 0,
            closedBuilder: (context, _) => ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 200,
                  maxHeight: 300,
                  minWidth: MediaQuery.of(context).size.width),
              child: Container(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: widget.course['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin:
                      EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 7.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
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
                    widget.course['title'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Solway',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 22.5,
            child: ElevatedButton(
                onPressed: widget.course['userId'] == currentUser.id
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePageWithHeader()))
                    : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OtherProfile(widget.course['userId']))),
                child: StreamBuilder(
                    stream: usersRef.doc(widget.course['userId']).snapshots(),
                    builder: (context, snapshot2) {
                      bool isLargePhone = Screen.diagonal(context) > 766;
                      bool isPostOwner = false;

                      if (snapshot2.hasError)
                        return CircularProgressIndicator();
                      if (!snapshot2.hasData)
                        return CircularProgressIndicator();

                      int verifiedStatus = snapshot2.data['verifiedStatus'];
                      String userYear = snapshot2.data['year'];
                      String userDorm = snapshot2.data['dorm'];
                      String displayName = snapshot2.data['displayName'];
                      String email = snapshot2.data['email'];
                      String proPic = snapshot2.data['photoUrl'];

                      if (currentUser.id == widget.course['userId']) {
                        isPostOwner = true;
                      }

                      return Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            Row(
                              children: [
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 4, 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (widget.course['userId'] ==
                                            currentUser.id) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePageWithHeader()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtherProfile(
                                                        widget.course['userId'],
                                                      )));
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage:
                                            CachedNetworkImageProvider(proPic),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    )),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 130,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.course['userId'] ==
                                          currentUser.id) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePageWithHeader()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherProfile(
                                                      widget.course['userId'],
                                                    )));
                                      }
                                    },
                                    child: Column(
                                      //  mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: 130,
                                            ),
                                            child: SizedBox(
                                              child: Row(
                                                children: [
                                                  Text(displayName,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              TextThemes.ndBlue,
                                                          decoration:
                                                              TextDecoration
                                                                  .none)),
                                                  verifiedStatus == 3
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 2.5,
                                                          ),
                                                          child: Icon(
                                                              Icons.store,
                                                              size: 20,
                                                              color:
                                                                  Colors.blue),
                                                        )
                                                      : verifiedStatus == 2
                                                          ? Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              child: Image.asset(
                                                                  'lib/assets/verif2.png',
                                                                  height: 15),
                                                            )
                                                          : verifiedStatus == 1
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2.5,
                                                                          top:
                                                                              0),
                                                                  child: Image.asset(
                                                                      'lib/assets/verif.png',
                                                                      height:
                                                                          22),
                                                                )
                                                              : Text("")
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Text(
                                              userYear + " in " + userDorm,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: TextThemes.ndBlue,
                                                  decoration:
                                                      TextDecoration.none)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ]));
                    }),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blueGrey[50]),
                    elevation: MaterialStateProperty.all(10),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )))),
          ),
          isToday == true
              ? Positioned(
                  top: 5,
                  right: 25,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.pink[400], Colors.purple[300]],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      "Today!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                )
              : isTomorrow == true
                  ? Positioned(
                      top: 5,
                      right: 25,
                      child: Container(
                        height: 30,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.pink[400], Colors.purple[300]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          "Tomorrow!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )
                  : Text(""),
          venmo != null && venmo != 0
              ? Positioned(
                  top: 5,
                  left: 25,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromRGBO(061, 149, 206, 1.0),
                            Color.fromRGBO(061, 149, 215, 1.0),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Image.asset('lib/assets/venmo-icon.png'),
                        Text(
                          "\$$venmo",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(""),
          maxOccupancy != null && maxOccupancy != 8000000 && maxOccupancy != 0
              ? Positioned(
                  top: 37.5,
                  left: 25,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange,
                            Colors.orange[300],
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.supervisor_account,
                          color: Colors.white,
                        ),
                        Text(
                          "$goingCount/$maxOccupancy",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              : Text(""),
        ]),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  FutureBuilder(
                      future: postsRef.doc(widget.course['postId']).get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData ||
                            snapshot.connectionState != ConnectionState.done) {
                          return circularProgress();
                        }
                        DocumentSnapshot course = snapshot.data;

                        List going = course['going'];
                        // for (String person in going) {
                        //   if (!currentUser.friendArray.contains(person)) {
                        //     going.remove(person);
                        //   }
                        // }
                        return Container(
                          height: 50,
                          width: 200,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: going.length++,
                              itemBuilder: (_, index) {
                                int friendGoingCount = 0;
                                going.forEach((element) {
                                  if (currentUser.friendArray
                                      .contains(element)) {
                                    friendGoingCount++;
                                  }
                                });

                                if (index == 0) {
                                  return Center(
                                    child: Text("Friends Going: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  );
                                } 
                                // else if (index == 0 &&
                                //     friendGoingCount == 1) {
                                //   return Center(
                                //     child: Text("Friend Going: ",
                                //         style: TextStyle(
                                //             fontWeight: FontWeight.bold)),
                                //   );
                                // }
                                bool hide = false;
                                return FutureBuilder(
                                    future: usersRef.doc(going[index]).get(),
                                    builder: (context, snapshot2) {
                                      if (!snapshot2.hasData ||
                                          snapshot2.connectionState !=
                                              ConnectionState.done) {
                                        return circularProgress();
                                      }
                                      DocumentSnapshot course2 = snapshot2.data;
                                      if (!currentUser.friendArray
                                          .contains(going[index])) {
                                        hide = true;
                                      }
                                      return (hide == false)
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0, right: 4),
                                              child: Container(
                                                height: 50,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5.0, bottom: 5),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if (going[index] ==
                                                          currentUser.id) {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfilePageWithHeader()));
                                                      } else {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherProfile(
                                                                          going[
                                                                              index],
                                                                        )));
                                                      }
                                                    },
                                                    child: CircleAvatar(
                                                      radius: 18,
                                                      backgroundColor:
                                                          TextThemes.ndGold,
                                                      child: CircleAvatar(
                                                        // backgroundImage: snapshot.data
                                                        //     .documents[index].data['photoUrl'],
                                                        backgroundImage:
                                                            NetworkImage(course2[
                                                                'photoUrl']),
                                                        radius: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container();
                                    });
                              }),
                        );
                      }),
                ],
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                            DateFormat('MMMd')
                                .add_jm()
                                .format(widget.course['startDate'].toDate()),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TextThemes.ndBlue)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(widget.course['address'],
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: TextThemes.ndBlue,
          height: 20,
          thickness: .5,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  void showMax(BuildContext context) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("This MOOV is currently full",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nHate to see it"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Fuck me", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.pop(context);

              // Database().deletePost(postId, userId);
            },
          ),
          // CupertinoDialogAction(
          //   child: Text("Cancel"),
          //   onPressed: () => Navigator.of(context).pop(true),
          // )
        ],
      ),
    );
  }
}