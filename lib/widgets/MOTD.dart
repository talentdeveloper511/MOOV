import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class MOTD extends StatefulWidget {
  final String type, vibeType;

  MOTD(this.type, this.vibeType);

  @override
  _MOTDState createState() => _MOTDState();
}

class _MOTDState extends State<MOTD> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postsRef
            .where(widget.type + widget.vibeType, isEqualTo: true)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.data.docs.length == 0) {
            return FutureBuilder(
                future: postsRef
                    .where("goingCount", isGreaterThanOrEqualTo: 5)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }
                  return _MOTDUI(snapshot);
                });
          }
          return _MOTDUI(snapshot);
        });
  }
}

class _MOTDUI extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const _MOTDUI(this.snapshot);

  @override
  Widget build(BuildContext context) {
    String title;
    String pic;
    bool isTablet = false;
    if (Device.get().isTablet) {
      isTablet = true;
    }
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: isLargePhone
                          ? SizeConfig.blockSizeVertical * 15
                          : isTablet
                              ? 800
                              : SizeConfig.blockSizeVertical * 18,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: OpenContainer(
                          transitionType: ContainerTransitionType.fade,
                          transitionDuration: Duration(milliseconds: 500),
                          openBuilder: (context, _) => PostDetail(course.id),
                          closedElevation: 0,
                          closedBuilder: (context, _) =>
                              Stack(children: <Widget>[
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Container(
                                child: Container(
                                  child: CachedNetworkImage(
                                    imageUrl: pic,
                                    fit: BoxFit.cover,
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
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
                              padding: const EdgeInsets.all(0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment(0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0)),
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
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
