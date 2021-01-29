import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../pages/ProfilePageWithHeader.dart';
import '../pages/other_profile.dart';

class SearchUsersPost extends StatefulWidget {
  List<String> invitees;
  SearchUsersPost(this.invitees);

  @override
  _SearchUsersPostState createState() => _SearchUsersPostState(this.invitees);
}

class _SearchUsersPostState extends State<SearchUsersPost> {
  List<String> invitees;
  _SearchUsersPostState(this.invitees);

  final TextEditingController searchController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  clearSearch() {
    searchController.clear();

    setState(() {
      _searchTerm = null;
    });
  }

  @override
  void initState() {
    super.initState();

    // Simple declarations
    TextEditingController searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_drop_up_outlined,
                color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: TextThemes.ndBlue,
        //pinned: true,

        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          TextField(
              style: TextStyle(fontSize: 20),
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  _searchTerm = val;
                });
              },
              // Set Focus Node
              focusNode: textFieldFocusNode,
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20),
                border: InputBorder.none,
                hintText: 'Search MOOV',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: GestureDetector(
                    onTap: () {
                      clearSearch();
                      // Unfocus all focus nodes
                      textFieldFocusNode.unfocus();

                      // Disable text field's focus node request
                      textFieldFocusNode.canRequestFocus = false;

                      //Enable the text field's focus node request after some delay
                      Future.delayed(Duration(milliseconds: 10), () {
                        textFieldFocusNode.canRequestFocus = true;
                      });
                    },
                    child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))),
              )),
          StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(height: 2000, child: TrendingSegment());
                if (snapshot.data.length == 0) {
                  return Container(height: 2000, child: TrendingSegment());
                }
                if (_searchTerm == null) {
                  return Container(height: 2000, child: TrendingSegment());
                }

                List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _searchTerm.length > 0
                                    ? UserPostResult(
                                        currSearchStuff[index]
                                            .data["displayName"],
                                        currSearchStuff[index].data["email"],
                                        currSearchStuff[index].data["photoUrl"],
                                        currSearchStuff[index].data["id"],
                                        currSearchStuff[index]
                                            .data["isAmbassador"],
                                        invitees)
                                    : Container();
                              },
                              childCount: currSearchStuff.length ?? 0,
                            ),
                          ),
                        ],
                      );
                }
              }),
        ]),
      ),
    );
  }
}

class UserPostResult extends StatefulWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final bool isAmbassador;
  List<String> invitees;

  UserPostResult(this.displayName, this.email, this.proPic, this.userId,
      this.isAmbassador, this.invitees);

  @override
  _UserPostResultState createState() => _UserPostResultState(this.displayName,
      this.email, this.proPic, this.userId, this.isAmbassador, this.invitees);
}

class _UserPostResultState extends State<UserPostResult> {
  String displayName;
  String email;
  String proPic;
  String userId;
  bool isAmbassador;
  List<String> invitees;
  bool status = false;

  _UserPostResultState(this.displayName, this.email, this.proPic, this.userId,
      this.isAmbassador, this.invitees);

  @override
  Widget build(BuildContext context) {
    invitees.contains(userId) ? status = true : false;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => userId != currentUser.id
              ? OtherProfile(userId)
              : ProfilePageWithHeader())),
      child: Stack(children: [
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
            child: CircleAvatar(
                radius: 27,
                backgroundColor: TextThemes.ndGold,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(proPic),
                  radius: 25,
                  backgroundColor: TextThemes.ndBlue,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Text(
              displayName ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          isAmbassador
              ? Padding(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: Image.asset('lib/assets/verif.png', height: 30),
                )
              : Text(""),
          // Text(
          //   email ?? "",
          //   style: TextStyle(color: Colors.black),
          // ),
          Divider(
            color: Colors.black,
          ),
        ]),
        status
            ? Positioned(
                right: 20,
                top: 10,
                child: RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    onPressed: () {
                      invitees.remove(userId);
                      setState(() {
                        status = false;
                      });
                    },
                    child: Text(
                      "Added",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    )),
              )
            : Positioned(
                right: 20,
                top: 10,
                child: RaisedButton(
                    padding: const EdgeInsets.all(2.0),
                    color: TextThemes.ndBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(3.0))),
                    onPressed: () {
                      invitees.add(userId);
                      print(invitees);
                      setState(() {
                        status = true;
                      });
                    },
                    child: Text(
                      "Add",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    )),
              ),
      ]),
    );
  }
}

class SearchUsersGroup extends StatefulWidget {

  String gname, gid, pic, moov;
  List<dynamic> members;
  SearchUsersGroup(

      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);

  @override
  _SearchUsersGroupState createState() => _SearchUsersGroupState(
  
      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);
}

class _SearchUsersGroupState extends State<SearchUsersGroup> {

  String gname, gid, pic, moov;
  List<dynamic> members;
  _SearchUsersGroupState(
  
      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);

  final TextEditingController searchController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  clearSearch() {
    searchController.clear();

    setState(() {
      _searchTerm = null;
    });
  }

  @override
  void initState() {
    super.initState();

    // Simple declarations
    TextEditingController searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_drop_up_outlined,
                color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: TextThemes.ndBlue,
        //pinned: true,

        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          TextField(
              style: TextStyle(fontSize: 20),
              controller: searchController,
              onChanged: (val) {
                setState(() {
                  _searchTerm = val;
                });
              },
              // Set Focus Node
              decoration: InputDecoration(
                labelStyle: TextStyle(fontSize: 20),
                border: InputBorder.none,
                hintText: 'Search MOOV',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: GestureDetector(
                    onTap: () {
                      clearSearch();
                      // Unfocus all focus nodes

                      // Disable text field's focus node request

                      //Enable the text field's focus node request after some delay
                
                    },
                    child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.clear,
                          color: Colors.black,
                        ))),
              )),
          StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(height: 2000, child: TrendingSegment());
                if (snapshot.data.length == 0) {
                  return Container(height: 2000, child: TrendingSegment());
                }
                if (_searchTerm == null) {
                  return Container(height: 2000, child: TrendingSegment());
                }

                List<AlgoliaObjectSnapshot> currSearchStuff = snapshot.data;

                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Container();
                  default:
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    else
                      return CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return _searchTerm.length > 0
                                    ? UserGroupResult(
                                        currSearchStuff[index]
                                            .data["displayName"],
                                        currSearchStuff[index].data["email"],
                                        currSearchStuff[index].data["photoUrl"],
                                        currSearchStuff[index].data["id"],
                                        currSearchStuff[index]
                                            .data["isAmbassador"],
                                        currSearchStuff[index]
                                            .data["friendGroups"],
                                        gname,
                                        gid,
                                        pic,
                                        moov,
                                        members)
                                    : Container();
                              },
                              childCount: currSearchStuff.length ?? 0,
                            ),
                          ),
                        ],
                      );
                }
              }),
        ]),
      ),
    );
  }
}

class UserGroupResult extends StatefulWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final bool isAmbassador;
  final List<dynamic> friendGroups;
  String gname, gid, pic, moov;
  List<dynamic> members;

  UserGroupResult(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.isAmbassador,
      this.friendGroups,
      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);

  @override
  _UserGroupResultState createState() => _UserGroupResultState(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.isAmbassador,
      this.friendGroups,
      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);
}

class _UserGroupResultState extends State<UserGroupResult> {
  String displayName;
  String email;
  String proPic;
  String userId;
  bool isAmbassador;
  String gname, gid, pic, moov;
  List<dynamic> members, friendGroups;
  bool status = false;

  _UserGroupResultState(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.isAmbassador,
      this.friendGroups,
      this.gname,
      this.gid,
      this.pic,
      this.moov,
      this.members);

  @override
  Widget build(BuildContext context) {
    friendGroups.contains(gid) ? status = true : false;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => userId != currentUser.id
              ? OtherProfile(userId)
              : ProfilePageWithHeader())),
      child: Stack(children: [
        Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
            child: CircleAvatar(
                radius: 27,
                backgroundColor: TextThemes.ndGold,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(proPic),
                  radius: 25,
                  backgroundColor: TextThemes.ndBlue,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.5),
            child: Text(
              displayName ?? "",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
          ),
          isAmbassador
              ? Padding(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  child: Image.asset('lib/assets/verif.png', height: 30),
                )
              : Text(""),
          // Text(
          //   email ?? "",
          //   style: TextStyle(color: Colors.black),
          // ),
          Divider(
            color: Colors.black,
          ),
        ]),
        status
            ? Positioned(
                right: 20,
                top: 10,
                child: RaisedButton(
                      padding: const EdgeInsets.all(2.0),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0))),
                      onPressed: () {
                        setState(() {
                          status = false;
                        });
                      },
                      child: Text(
                        "Added",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ))
                  
              )
            : Positioned(
                right: 20,
                top: 10,
                child:RaisedButton(
                      padding: const EdgeInsets.all(2.0),
                      color: TextThemes.ndBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3.0))),
                      onPressed: () {
                        Database().addUser(userId, gname, gid);
                        Database().addedToGroup(userId, gname, gid, pic);
                        setState(() {
                          status = true;
                        });
                      },
                      child: Text(
                        "Add to Group",
                        style: new TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      )),
              ),
      ]),
    );
  }
}
