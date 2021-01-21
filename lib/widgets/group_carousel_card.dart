import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/create_group.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/NextMOOV.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class GroupCarousel extends StatelessWidget {
  String userId;
  GroupCarousel({Key key}) : super(key: key);

  int i = 0;

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount user = googleSignIn.currentUser;
    userId = user.id;

    bool isLargePhone = Screen.diagonal(context) > 766;

    return (currentUser.friendGroups.isEmpty)
        ? Container(
            height: 110,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
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
                ],
              ),
            )))
        : Container(
            child: StreamBuilder(
                stream: groupsRef
                    .where('members', arrayContains: user.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  if (snapshot.data.docs.length == 0 ||
                      currentUser.friendGroups.length == 0) {
                    return Container();
                  }
                  DocumentSnapshot course = snapshot.data.docs[0];
                  int length = course['members'].length - 2;

                  return StreamBuilder(
                      stream: usersRef
                          .where('friendGroups',
                              arrayContains: course['groupId'])
                          .snapshots(),
                      builder: (context, snapshot3) {
                        if (!snapshot3.hasData)
                          return CircularProgressIndicator();
                        if (snapshot3.hasError || snapshot3.data == null)
                          return CircularProgressIndicator();

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
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
                                                        course['groupId'])));
                                      },
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 5.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20)),
                                                  border: Border.all(
                                                    color: TextThemes.ndBlue,
                                                    width: 3,
                                                  )),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                child: CachedNetworkImage(
                                                  imageUrl: course['groupPic'],
                                                  fit: BoxFit.cover,
                                                  height: isLargePhone
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.08
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.12,
                                                  width: isLargePhone
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.33
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(7.5),
                                            child: Center(
                                              child: FittedBox(
                                                child: Text(
                                                  course['groupName']
                                                      .toString(),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: isLargePhone
                                                          ? 20.0
                                                          : 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: isLargePhone ? 65 : 60,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Stack(children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child:
                                                    course['members'].length > 1
                                                        ? CircleAvatar(
                                                            radius: 15.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                              snapshot3.data
                                                                      .docs[1]
                                                                  ['photoUrl'],
                                                            ),
                                                          )
                                                        : Container()),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, left: 20.0),
                                                child: CircleAvatar(
                                                  radius: 15.0,
                                                  backgroundImage: NetworkImage(
                                                    snapshot3.data.docs[0]
                                                        ['photoUrl'],
                                                  ),
                                                )),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4, left: 40.0),
                                              child: CircleAvatar(
                                                radius: 15.0,
                                                child: course['members']
                                                            .length >
                                                        2
                                                    ? Text(
                                                        "+" +
                                                            (length.toString()),
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
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            course['nextMOOV'] == "" ?
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: Text(
                                "needs a MOOV \ntonight!",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ):
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: Text(
                                "needs you to vote \non tonight's MOOV!",
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      });
                }));
  }
}
