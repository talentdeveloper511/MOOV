import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/CategoryFeed.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/create_group.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/NextMOOV.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HottestMOOV extends StatelessWidget {
  const HottestMOOV({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder(
          stream: postsRef.orderBy("goingCount", descending: true).limit(1).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.docs.length == 0)
              return Center(
                child: Text("Nothing doing, right now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
              );

            return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                itemBuilder: (context, index) {
                  DocumentSnapshot course = snapshot.data.docs[index];
                  Timestamp startDate = course["startDate"];
                  String privacy = course['privacy'];
                  Map<String, dynamic> statuses =
                      (snapshot.data.docs[index]['statuses']);

                  int status = 0;
                  List<dynamic> statusesIds = statuses.keys.toList();

                  List<dynamic> statusesValues = statuses.values.toList();

                  if (statuses != null) {
                    for (int i = 0; i < statuses.length; i++) {
                      if (statusesIds[i] == currentUser.id) {
                        if (statusesValues[i] == 3) {
                          status = 3;
                        }
                      }
                    }
                  }

                  bool hide = false;

                  if (startDate.millisecondsSinceEpoch <
                      Timestamp.now().millisecondsSinceEpoch - 3600000) {
                    print("Expired. See ya later.");
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Database().deletePost(
                          course['postId'], course['userId'], course['title'], course['statuses'], course['posterName']);
                    });
                  }
                  final now = DateTime.now();
                  bool isToday = false;
                  bool isTomorrow = false;

                  final today = DateTime(now.year, now.month, now.day);
                  final yesterday = DateTime(now.year, now.month, now.day - 1);
                  final tomorrow = DateTime(now.year, now.month, now.day + 1);

                  final dateToCheck = startDate.toDate();
                  final aDate = DateTime(
                      dateToCheck.year, dateToCheck.month, dateToCheck.day);

                  if (aDate == today) {
                    isToday = true;
                  } else if (aDate == tomorrow) {
                    isTomorrow = true;
                  }

                  if (privacy == "Friends Only" || privacy == "Invite Only") {
                    hide = true;
                  }
                  bool isLargePhone = Screen.diagonal(context) > 766;

                  return (hide == false)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Stack(children: [
                            PostOnFeed(course),
                            Positioned(
                              top: 140,
                              left: 25,
                              // left: isLargePhone ? 145 : 118,
                              child: Container(
                                height: 30,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.orange,
                                        Colors.red[300],
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.fire_extinguisher,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "HOTTEST MOOV",
                                      textAlign: TextAlign.center,
                                      style: isLargePhone
                                          ? TextStyle(
                                              color: Colors.white, fontSize: 18)
                                          : TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        )
                      : Container();
                });
          }),
    );
  }
}
