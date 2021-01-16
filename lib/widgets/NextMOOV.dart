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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NextMOOV extends StatefulWidget {
  String selected;

  NextMOOV(this.selected);

  @override
  _NextMOOVState createState() => _NextMOOVState(this.selected);
}

class _NextMOOVState extends State<NextMOOV> {
  String selected;

  _NextMOOVState(this.selected);
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    var title;
    var pic;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .where("postId", isEqualTo: selected)
            .snapshots(),
        builder: (context, snapshot) {
          // title = snapshot.data['title'];
          // pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          return MediaQuery(
            data: MediaQuery.of(context)
                .removePadding(removeTop: true, removeBottom: true),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = snapshot.data.docs[index];
                  pic = course['image'];
                  title = course['title'];

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: isLargePhone
                              ? SizeConfig.blockSizeVertical * 15
                              : SizeConfig.blockSizeVertical * 18,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PostDetail(course.id)));
                            },
                            child: Stack(children: <Widget>[
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: pic,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 20, top: 0, right: 20, bottom: 7.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment(0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
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
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7),
                                        child: Text(
                                          title,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontFamily: 'Solway',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize:
                                                  isLargePhone ? 22.0 : 20),
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
                  );
                }),
          );
        });
  }
}
