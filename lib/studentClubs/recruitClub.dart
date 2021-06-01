import 'dart:async';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/studentClubs/promoteClub.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/add_users_post.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecruitClub extends StatefulWidget {
  final List<String> existingMembers;
  final String clubId;

  RecruitClub(this.existingMembers, this.clubId);

  @override
  _RecruitClubState createState() => _RecruitClubState();
}

class _RecruitClubState extends State<RecruitClub> {
  bool isUploading = false;
  bool goodCheck = false;
  List<String> invitees = [];

  int id = 0;
  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    //this gets rid of existing members, leaving only invitees
    clubsRef.doc(widget.clubId).get().then((value) {
      invitees = widget.existingMembers;
      for (int i = 0; i < widget.existingMembers.length; i++) {
        if (value['memberNames'].contains(widget.existingMembers[i])) {
          invitees.remove(value['memberNames'][i]);
        }
      }
    });
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "lib/assets/recruit.jpeg",
                  color: Colors.black45,
                  colorBlendMode: BlendMode.darken,
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                "Recruit",
                style: TextThemes.headlineWhite,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 65.0, left: 20, right: 20),
                child: Text("Add your existing members and find new ones!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 13)),
              ),
            ],
          ),
          SizedBox(height: 25),
          (isUploading)
              ? linearProgress()
              : (goodCheck)
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sweet!",
                            style: TextThemes.headline1,
                          ),
                          SizedBox(height: 30),
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddUsersFromCreateGroup(
                                                  widget.existingMembers)))
                                  .then(onGoBack),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search,
                                    size: 35,
                                    color: Colors.blue,
                                  ),
                                  Text("Search"),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          PromoteClub(widget.clubId))),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.campaign,
                                    size: 35,
                                    color: Colors.blue,
                                  ),
                                  Text("Promote"),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: isLargePhone ? 500 : 340,
                          width: MediaQuery.of(context).size.width * .9,
                          decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: (invitees == [])
                              ? Center(
                                  child: Text(
                                  "Your invitees will appear here",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: TextThemes.ndBlue),
                                ))
                              : GridView.builder(
                                  itemCount: invitees.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return FutureBuilder(
                                        future:
                                            usersRef.doc(invitees[index]).get(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return Container();
                                          }
                                          String name =
                                              snapshot.data['displayName'];
                                          String pic =
                                              snapshot.data['photoUrl'];
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OtherProfile(
                                                            invitees[index]))),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                      NetworkImage(pic),
                                                  radius: 30,
                                                ),
                                                SizedBox(height: 5),
                                                Text(name),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                        ),
                      ],
                    ),
          SizedBox(height: 10),
          (isUploading || goodCheck)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 125.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Invite!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (invitees.isEmpty) {
                          return null;
                        }
                        setState(() {
                          isUploading = true;
                        });

                        clubsRef
                            .doc(widget.clubId)
                            .set({
                              "memberNames": invitees,
                              "members": {for (var v in invitees) v: -1},
                            }, SetOptions(merge: true))
                            .then((value) => setState(() {
                                  isUploading = false;
                                }))
                            .then((value) => setState(() {
                                  goodCheck = true;
                                }))
                            .then((value) => Timer(Duration(seconds: 1), () {
                                  Navigator.pop(
                                    context,
                                  );
                                }));
                      }))
        ],
      ),
    );
  }
}
