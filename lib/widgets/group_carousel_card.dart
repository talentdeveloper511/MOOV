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

    return Container(
      height: 120,
      child: Card(
          color: Colors.white,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('friendGroups')
                  .where('members', arrayContains: user.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data.docs.length == 0 ||
                    currentUser.friendGroups.length == 0) {
                  return Container(
                    height: 120,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
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
                                    Icon(Icons.people,
                                        color: TextThemes.ndGold),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Create Friend Group',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20)),
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
                    )),
                  );
                }
                DocumentSnapshot course = snapshot.data().docs[i];

                return Container(
                    height: 150,
                    // height: (snapshot.data.docs.length <= 3) ? 270 : 400,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('friendGroups',
                                arrayContains: course['groupName'])
                            .snapshots(),
                        builder: (context, snapshot3) {
                          if (!snapshot3.hasData)
                            return CircularProgressIndicator();
                          if (snapshot3.hasError)
                            return CircularProgressIndicator();

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 120,
                              // color: Colors.white,
                              clipBehavior: Clip.none,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Stack(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupDetail(
                                                          course['groupPic'],
                                                          course['groupName'],
                                                          course['members'],
                                                          snapshot
                                                              .data
                                                              .docs[i]
                                                              .documentID,
                                                          course['nextMOOV'])));
                                        },
                                        child: Container(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 0.0),
                                                child: Container(
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      border: Border.all(
                                                        color:
                                                            TextThemes.ndBlue,
                                                        width: 3,
                                                      )),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          course['groupPic'],
                                                      fit: BoxFit.cover,
                                                      height: isLargePhone
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.1
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
                                                              0.3
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Center(
                                                  child: FittedBox(
                                                    child: Text(
                                                      course['groupName']
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: isLargePhone
                                                              ? 17.0
                                                              : 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: isLargePhone ? 22.5 : 25,
                                        right: 0,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: course['members']
                                                              .length >
                                                          1
                                                      ? CircleAvatar(
                                                          radius: isLargePhone
                                                              ? 20.0
                                                              : 15,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            snapshot3
                                                                    .data
                                                                    .docs[1]
                                                                    .data[
                                                                'photoUrl'],
                                                          ),
                                                        )
                                                      : Container()),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, left: 20.0),
                                                  child: CircleAvatar(
                                                    radius: isLargePhone
                                                        ? 20.0
                                                        : 15,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      snapshot3
                                                          .data
                                                          .docs[0]
                                                          .data['photoUrl'],
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, left: 40.0),
                                                child: CircleAvatar(
                                                  radius:
                                                      isLargePhone ? 20.0 : 15,
                                                  child: course['members']
                                                              .length >
                                                          2
                                                      ? Text(
                                                          "+" +
                                                              (course['members']
                                                                  .length
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
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "Going to",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        top: 5.0,
                                        bottom: 0,
                                        right: 0,
                                      ),
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('food')
                                              .where("postId",
                                                  isEqualTo: course['nextMOOV'])
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            // title = snapshot.data['title'];
                                            // pic = snapshot.data['pic'];
                                            if (!snapshot.hasData)
                                              return Text('Loading data...');

                                            return Column(children: [
                                              Container(
                                                width:
                                                    isLargePhone ? 135.0 : 120,
                                                child: MediaQuery(
                                                  data: MediaQuery.of(context)
                                                      .removePadding(
                                                          removeTop: true,
                                                          removeBottom: true),
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: 1,
                                                      itemBuilder:
                                                          (context, index) {
                                                        DocumentSnapshot
                                                            course = snapshot
                                                                    .data()
                                                                    .docs[
                                                                index];
                                                        String pic =
                                                            course['image'];
                                                        String title =
                                                            course['title'];
                                                        Timestamp startDate =
                                                            course['startDate'];

                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  bottom: 0),
                                                          child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                width: 200,
                                                                height: isLargePhone
                                                                    ? SizeConfig
                                                                            .blockSizeVertical *
                                                                        8.45
                                                                    : SizeConfig
                                                                            .blockSizeVertical *
                                                                        12,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                PostDetail(course.id)));
                                                                  },
                                                                  child: Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        SizedBox(
                                                                          width:
                                                                              150,
                                                                          height:
                                                                              120,
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: pic,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Colors.grey.withOpacity(0.5),
                                                                                  spreadRadius: 5,
                                                                                  blurRadius: 7,
                                                                                  offset: Offset(0, 3), // changes position of shadow
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            alignment:
                                                                                Alignment(0.0, 0.0),
                                                                            child:
                                                                                Container(
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                gradient: LinearGradient(
                                                                                  begin: Alignment.topCenter,
                                                                                  end: Alignment.bottomCenter,
                                                                                  colors: <Color>[
                                                                                    Colors.black.withAlpha(15),
                                                                                    Colors.black,
                                                                                    Colors.black12,
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: ConstrainedBox(
                                                                                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .7),
                                                                                  child: Text(
                                                                                    title,
                                                                                    maxLines: 2,
                                                                                    textAlign: TextAlign.center,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    style: TextStyle(fontFamily: 'Solway', fontWeight: FontWeight.bold, color: Colors.white, fontSize: isLargePhone ? 16.0 : 14),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                    "On " +
                                                                        DateFormat('EEEE')
                                                                            .format(course['startDate']
                                                                                .toDate())
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize: isLargePhone
                                                                            ? 17
                                                                            : 14)),
                                                              )
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                ),
                                              ),
                                            ]);
                                          })),
                                ],
                              ),
                            ),
                          );
                        }));
              })),
    );
  }
}
