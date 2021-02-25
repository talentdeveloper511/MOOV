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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class MOTD extends StatefulWidget {
  @override
  _MOTDState createState() => _MOTDState();
}

class _MOTDState extends State<MOTD> {
  @override
  Widget build(BuildContext context) {
    var title;
    var pic;

    return StreamBuilder(
        stream: postsRef.where("MOTD", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          bool isLargePhone = Screen.diagonal(context) > 766;
          if (!snapshot.hasData || snapshot.data.docs.length == 0)
            return Container(
              height: isLargePhone
                  ? SizeConfig.blockSizeVertical * 15
                  : SizeConfig.blockSizeVertical * 18,
              child: Stack(alignment: Alignment.center, children: <Widget>[
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'lib/assets/motd.jpg',
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
                          offset: Offset(0, 3), // changes position of shadow
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
                          "YOUR MOOV",
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
              ]),
            );

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

                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: <Widget>[
                        Bounce(
                          duration: Duration(milliseconds: 300),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PostDetail(course.id)));
                          },
                          child: Container(
                            height: isLargePhone
                                ? SizeConfig.blockSizeVertical * 15
                                : SizeConfig.blockSizeVertical * 18,
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
                                          BorderRadius.all(Radius.circular(20)),
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
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (_) => CupertinoAlertDialog(
                                            title: Text("Your MOOV."),
                                            content: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                  "Do you have the MOOV of the Day? Email admin@whatsthemoov.com."),
                                            ),
                                          ),
                                      barrierDismissible: true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "MOOV of the Day",
                                    style: TextStyle(
                                        fontFamily: 'Open Sans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 16.0),
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  );
                }),
          );
        });
  }
}
