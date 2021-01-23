import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/ProfilePageWithHeader.dart';
import '../pages/other_profile.dart';

class SendMOOV extends StatefulWidget {
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, ownerProPic, ownerName;

  SendMOOV(
    this.ownerId,
    this.previewImg,
    this.moovId,
    this.startDate,
    this.title,
    this.ownerProPic,
    this.ownerName,
  );

  @override
  _SendMOOVState createState() => _SendMOOVState(
        this.ownerId,
        this.previewImg,
        this.moovId,
        this.startDate,
        this.title,
        this.ownerProPic,
        this.ownerName,
      );
}

class _SendMOOVState extends State<SendMOOV> {
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, ownerProPic, ownerName;

  _SendMOOVState(
    this.ownerId,
    this.previewImg,
    this.moovId,
    this.startDate,
    this.title,
    this.ownerProPic,
    this.ownerName,
  );
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .get();
    setState(() {
      searchResultsFuture = users;
    });
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultsFuture = null;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      toolbarHeight: 100,
      leading: IconButton(
          icon: Icon(Icons.arrow_drop_down_circle_outlined,
              color: Colors.white, size: 35),
          onPressed: () {
            Navigator.pop(context);
          }),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(2),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      backgroundColor: TextThemes.ndBlue,
      //pinned: true,
      actions: <Widget>[],
      bottom: PreferredSize(
        preferredSize: null,
        child: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 15),
            contentPadding: EdgeInsets.only(top: 18, bottom: 10),
            hintText: "Search for Users...",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: clearSearch,
            ),
          ),
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      color: Colors.white,
    );
  }

  buildSearchResults() {
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.docs.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(
            user,
            ownerId,
            previewImg,
            moovId,
            startDate,
            title,
            ownerProPic,
            ownerName,
          );
          searchResults.add(searchResult);
        });
        return ListView(
          children: searchResults,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatefulWidget {
  User user;
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, description, address, ownerProPic, ownerName, ownerEmail;

  UserResult(
    this.user,
    this.ownerId,
    this.previewImg,
    this.moovId,
    this.startDate,
    this.title,
    this.ownerProPic,
    this.ownerName,
  );

  @override
  _UserResultState createState() => _UserResultState(
        this.user,
        this.ownerId,
        this.previewImg,
        this.moovId,
        this.startDate,
        this.title,
        this.ownerProPic,
        this.ownerName,
      );
}

class _UserResultState extends State<UserResult> {
  User user;
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, ownerProPic, ownerName;
  bool status = false;

  _UserResultState(
    this.user,
    this.ownerId,
    this.previewImg,
    this.moovId,
    this.startDate,
    this.title,
    this.ownerProPic,
    this.ownerName,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print(user.dorm),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName == null ? "" : user.displayName,
                style: TextStyle(
                    color: TextThemes.ndBlue, fontWeight: FontWeight.bold),
              ),
              trailing: user.id == currentUser.id
                  ? null
                  : status
                      ? RaisedButton(
                          padding: const EdgeInsets.all(2.0),
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          onPressed: () {
                            setState(() {
                              status = false;
                            });
                          },
                          child: Text(
                            "Sent",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          ))
                      : RaisedButton(
                          padding: const EdgeInsets.all(2.0),
                          color: TextThemes.ndBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(3.0))),
                          onPressed: () {
                            Database().sendMOOVNotification(
                              user.id,
                              previewImg,
                              moovId,
                              startDate,
                              title,
                              ownerProPic,
                              ownerName,
                            );
                            setState(() {
                              status = true;
                            });
                          },
                          child: Text(
                            "Send MOOV",
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                            ),
                          )),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
