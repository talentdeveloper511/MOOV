import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_group.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';

class FriendGroupsPage extends StatefulWidget {
  @override
  _FriendGroupsState createState() {
    return _FriendGroupsState();
  }
}

class _FriendGroupsState extends State<FriendGroupsPage> {
  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: TextThemes.ndBlue,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.search),
            Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          backgroundColor: TextThemes.ndBlue,
          title: Text(
            "Friend Groups",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection('friendgroups')
                .where('members', arrayContains: currentUser.id)
                .snapshots(),
            builder: (context, snapshot) {
              return Scaffold(
                  backgroundColor: TextThemes.ndBlue,
                  body: ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (_, index) {
                        if (index == 0) {
                          return Container(
                            color: TextThemes.ndBlue,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RaisedButton(
                                              color: TextThemes.ndGold,
                                              textColor: TextThemes.ndBlue,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  side: BorderSide(
                                                      color:
                                                          TextThemes.ndGold)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            CreateGroup()));
                                              },
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0,
                                                          right: 20.0,
                                                          top: 10.0,
                                                          bottom: 10.0),
                                                  child: Text(
                                                      'Create New Friend Group',
                                                      style: TextStyle(
                                                          color:
                                                              TextThemes.ndBlue,
                                                          fontSize: 22)))),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: RaisedButton(
                                      color: Colors.amber[800],
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupDetail(
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['groupPic'],
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['groupName'],
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .data['members'],
                                                        snapshot
                                                            .data
                                                            .documents[index]
                                                            .documentID)));
                                      },
                                      child: Text(
                                          snapshot.data.documents[index]
                                              .data['groupName']
                                              .toString(),
                                          style:
                                              TextStyle(color: Colors.black))),
                                )
                              ],
                            ),
                          );
                        }
                        return Container(
                          color: TextThemes.ndBlue,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: RaisedButton(
                                    color: Colors.amber[800],
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => GroupDetail(
                                                  snapshot.data.documents[index]
                                                      .data['groupPic'],
                                                  snapshot.data.documents[index]
                                                      .data['groupName'],
                                                  snapshot.data.documents[index]
                                                      .data['members'],
                                                  snapshot.data.documents[index]
                                                      .documentID)));
                                    },
                                    child: Text(
                                        snapshot.data.documents[index]
                                            .data['groupName']
                                            .toString(),
                                        style: TextStyle(color: Colors.black))),
                              )
                            ],
                          ),
                        );
                      }));
            }));
  }
}
