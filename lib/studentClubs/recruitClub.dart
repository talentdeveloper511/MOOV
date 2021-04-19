import 'dart:async';

import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/add_users_post.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:flutter/material.dart';

class RecruitClub extends StatefulWidget {
  final List<String> members;
  RecruitClub(this.members);

  @override
  _RecruitClubState createState() => _RecruitClubState();
}

class _RecruitClubState extends State<RecruitClub> {
  bool isUploading = false;
  List<String> invitees = [];

  int id = 0;
  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  
    print(invitees);
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
                                          AddUsersFromCreateGroup(widget.members)))
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
                        Column(
                          children: [
                            Icon(
                              Icons.campaign,
                              size: 35,
                              color: TextThemes.ndGold,
                            ),
                            Text("Promote"),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 500,
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
                          : ListView.builder(
                              itemCount: invitees.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(invitees[index]);
                              },
                            ),
                    ),
                  ],
                ),
          SizedBox(height: 10),
          (isUploading)
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
                        setState(() {
                          isUploading = true;
                        });
                        // invitees.removeWhere((item) => oldInvitees.contains(item));
                      }))
        ],
      ),
    );
  }
}
