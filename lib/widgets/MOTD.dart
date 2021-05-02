import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:shimmer/shimmer.dart';

class MOTD extends StatefulWidget {
  final int index;

  MOTD(this.index);

  @override
  _MOTDState createState() => _MOTDState();
}

class _MOTDState extends State<MOTD> {
  @override
  Widget build(BuildContext context) {
     bool isTablet = false;
    if (Device.get().isTablet) {
      isTablet = true;
    }
    var title;
    var pic;

    return (widget.index == 0)
        ? FutureBuilder(
            future: postsRef.where("MOTD", isEqualTo: true).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                bool isLargePhone = Screen.diagonal(context) > 766;

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    height: 20.0,
                    width: MediaQuery.of(context).size.width * .9,
                  ),
                );
              } else
                return MediaQuery(
                  data: MediaQuery.of(context).removePadding(removeTop: true),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        bool isLargePhone = Screen.diagonal(context) > 766;

                        DocumentSnapshot course = snapshot.data.docs[index];
                        pic = course['image'];
                        title = course['title'];

                        return Container(
                          alignment: Alignment.center,
                          // width: width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: isLargePhone
                                      ? SizeConfig.blockSizeVertical * 15 : isTablet ? 800
                                      : SizeConfig.blockSizeVertical * 18,
                                  child: OpenContainer(
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    openBuilder: (context, _) =>
                                        PostDetail(course.id),
                                    closedElevation: 0,
                                    closedBuilder: (context, _) =>
                                        Stack(children: <Widget>[
                                      FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Container(
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: CachedNetworkImage(
                                                imageUrl: pic,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
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
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                      fontFamily: 'Solway',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
            })
        : FutureBuilder(
            future: postsRef.where("MOTN", isEqualTo: true).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                bool isLargePhone = Screen.diagonal(context) > 766;

                return Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    height: 20.0,
                    width: MediaQuery.of(context).size.width * .9,
                  ),
                );
              } else
                return MediaQuery(
                  data: MediaQuery.of(context).removePadding(removeTop: true),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        bool isLargePhone = Screen.diagonal(context) > 766;

                        DocumentSnapshot course = snapshot.data.docs[index];
                        pic = course['image'];
                        title = course['title'];

                        return Container(
                          alignment: Alignment.center,
                          // width: width * 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: isLargePhone
                                      ? SizeConfig.blockSizeVertical * 15
                                      : SizeConfig.blockSizeVertical * 18,
                                  child: OpenContainer(
                                    transitionType:
                                        ContainerTransitionType.fade,
                                    transitionDuration:
                                        Duration(milliseconds: 500),
                                    openBuilder: (context, _) =>
                                        PostDetail(course.id),
                                    closedElevation: 0,
                                    closedBuilder: (context, _) =>
                                        Stack(children: <Widget>[
                                      FractionallySizedBox(
                                        widthFactor: 1,
                                        child: Container(
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl: pic,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
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
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
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
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  title,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Solway',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
            });
  }
}
