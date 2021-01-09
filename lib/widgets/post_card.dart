import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/edit_post.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/post_card.dart';
import 'package:MOOV/widgets/send_moov.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'dart:math';

import 'package:MOOV/helpers/themes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/home.dart';
import 'package:like_button/like_button.dart';
import 'package:list_tile_more_customizable/list_tile_more_customizable.dart';
import 'package:page_transition/page_transition.dart';

class PostCard extends StatefulWidget {
  String title, description, address, userId, postId, image;
  dynamic startDate;
  List<dynamic> likerArray;
  PostCard(this.title, this.description, this.address, this.startDate,
      this.userId, this.image, this.postId, this.likerArray);

  @override
  _PostCardState createState() => _PostCardState(
      this.title,
      this.description,
      this.address,
      this.startDate,
      this.userId,
      this.image,
      this.postId,
      this.likerArray);
}

class _PostCardState extends State<PostCard> {
  String title, description, address, userId, postId, image;
  dynamic startDate;
  List<dynamic> likerArray;
  _PostCardState(this.title, this.description, this.address, this.startDate,
      this.userId, this.image, this.postId, this.likerArray);

  @override
  Widget build(BuildContext context) {
    String strUserId = currentUser.id;
    String strUserPic = currentUser.photoUrl;
    bool isAmbassador;
    return Container(
        child: Card(
      color: Colors.white,
      shadowColor: Colors.grey[200],
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PostDetail(postId)));
        },
        child: Column(
          children: [
            Card(
              color: Colors.white,
              child: Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0.0, right: 5, bottom: 5),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                color: Color(0xff000000),
                                width: 1,
                              )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(image,
                                fit: BoxFit.cover, height: 140, width: 50),
                          ),
                        ))),
                Expanded(
                    child: Column(children: <Widget>[
                  Padding(padding: const EdgeInsets.all(8.0)),
                  Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(title.toString(),
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      description.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12.0, color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(5.0)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(Icons.timer,
                                color: TextThemes.ndGold, size: 20),
                          ),
                          Text('WHEN: ',
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold)),
                          Text(
                              DateFormat('MMMd')
                                  .add_jm()
                                  .format(startDate.toDate()),
                              style: TextStyle(
                                fontSize: 12.0,
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 0.0),
                              child: Icon(Icons.place,
                                  color: TextThemes.ndGold, size: 20),
                            ),
                            Text(' WHERE: ',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold)),
                            Text(address,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                  fontSize: 12.0,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]))
              ]),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //       horizontal: 1.0),
            //   child: Container(
            //     height: 1.0,
            //     width: 500.0,
            //     color: Colors.grey[300],
            //   ),
            // ),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(userId)
                    .snapshots(),
                builder: (context, snapshot2) {
                  Future<bool> likePost() async {
                    Future<DocumentSnapshot> docSnapshot = Firestore.instance
                        .collection('food')
                        .document(postId)
                        .get(); // i need to get the postId here, but cant pass it in
                    DocumentSnapshot doc = await docSnapshot;
                    likerArray = doc['liker'];
                    if (doc['liker'].contains(currentUser.id)) {
                      Database().removeLike(userId, postId);

                      return Future.value(true);
                    } else if (!doc['liker'].contains(currentUser.id)) {
                      Database().addLike(userId, postId);

                      return Future.value(false);
                    }
                  }

                  Future<bool> onLikeButtonTapped(bool isLiked) async {
                    await likePost();

                    /// send your request here
                    // final bool success = await likePost();

                    /// if failed, you can do nothing
                    // return success? !isLiked:isLiked;
                    if (await likePost() == true)
                      return !isLiked;
                    else
                      return !isLiked;
                  }

                  var userYear;
                  var userDorm;
                  var userPic;
                  var userName;
                  var userEmail;
                  bool isLargePhone = Screen.diagonal(context) > 766;

                  if (snapshot2.hasError) return CircularProgressIndicator();
                  if (!snapshot2.hasData)
                    return CircularProgressIndicator();
                  else
                    userDorm = snapshot2.data['dorm'];
                  userName = snapshot2.data["displayName"];
                  userPic = snapshot2.data['photoUrl'];
                  isAmbassador = snapshot2.data['isAmbassador'];
                  userYear = snapshot2.data['year'];
                  userEmail = snapshot2.data['email'];

                  return Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (userId == strUserId) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  } else {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => OtherProfile(
                                                  userPic,
                                                  userName,
                                                  userId,
                                                )));
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      CachedNetworkImageProvider(userPic),
                                  backgroundColor: Colors.transparent,
                                ),
                              )),
                          Container(
                            width: 120,
                            height: 30,
                            child: GestureDetector(
                              onTap: () {
                                if (userId == strUserId) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ProfilePage()));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => OtherProfile(
                                          userPic, userName, userId)));
                                }
                              },
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(userName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(userYear + " in " + userDorm,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      userId == currentUser.id
                          ? RaisedButton(
                              color: Colors.red,
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => EditPost(postId))),

                              // showAlertDialog(context, postId, userId),
                              child: Text(
                                "Edit",
                                style: TextStyle(color: Colors.white),
                              ))
                          : Text(''),
                      Row(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 5.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: SendMOOV(
                                                postId,
                                                userId,
                                                userPic,
                                                postId,
                                                startDate,
                                                title,
                                                description,
                                                address,
                                                userPic,
                                                userName,
                                                userEmail,
                                                likerArray)));
                                  },
                                  child: Icon(Icons.send_rounded,
                                      color: Colors.blue[500], size: 30),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Text(
                                  'Send',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, right: 2.0, left: 20, bottom: 10),
                                child: LikeButton(
                                  onTap:
                                      onLikeButtonTapped, //this is where the trouble is
                                  size: 30,
                                  circleColor: CircleColor(
                                      start: Color(0xff00ddff),
                                      end: Color(0xff0099cc)),
                                  bubblesColor: BubblesColor(
                                      dotPrimaryColor: TextThemes.ndGold,
                                      dotSecondaryColor: TextThemes.ndGold),
                                  likeBuilder: (bool isLiked) {
                                    return Column(
                                      children: [
                                        Icon(
                                          Icons.directions_run,
                                          color: isLiked
                                              ? Colors.green
                                              : Colors.grey,
                                          size: 30,
                                        ),
                                        // Text(
                                        //   'Going?',
                                        //   style: TextStyle(fontSize: 12),
                                        // ),
                                      ],
                                    );
                                  },

                                  likeCount: likerArray.length,
                                  countPostion: CountPostion.bottom,
                                  countBuilder:
                                      (int count, bool isLiked, String text) {
                                    var color = isLiked
                                        ? TextThemes.ndGold
                                        : Colors.grey;
                                    Widget result;
                                    if (count == 0) {
                                      result = Text(
                                        "0",
                                        style: TextStyle(color: color),
                                      );
                                    } else
                                      result = Text(
                                        text,
                                        style: TextStyle(color: color),
                                      );
                                    return result;
                                  },
                                ),
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(
                              //       left: 5, right: 6.0, bottom: 4.0),
                              //   child: Text(
                              //     'Going?',
                              //     style: TextStyle(fontSize: 12),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ));
                }),
          ],
        ),
      ),
    ));
  }

  void showAlertDialog(BuildContext context, postId, userId) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Delete?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nMOOV to trash can?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Database().deletePost(postId, userId);
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
