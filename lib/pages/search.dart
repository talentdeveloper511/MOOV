import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ProfilePage.dart';
import 'other_profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  Future<QuerySnapshot> searchResultsEvents;
  Future<QuerySnapshot> searchResultsGroups;
  bool get wantKeepAlive => true;
  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .limit(5)
        .getDocuments();
    Future<QuerySnapshot> events = postsRef
        .where("title", isGreaterThanOrEqualTo: query)
        .limit(5)
        .getDocuments();
    Future<QuerySnapshot> groups = groupsRef
        .where("groupName", isGreaterThanOrEqualTo: query)
        .limit(5)
        .getDocuments();
    setState(() {
      searchResultsFuture = users;
      searchResultsEvents = events;
      searchResultsGroups = groups;
    });
  }

  clearSearch() {
    searchController.clear();

    setState(() {
      searchResultsFuture = null;
      searchResultsEvents = null;
      searchResultsGroups = null;
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

  AppBar buildSearchField() {
    return AppBar(
      toolbarHeight: 50,
      bottom: PreferredSize(
        preferredSize: null,
        child: TextFormField(
          onChanged: (value) {
            handleSearch(value);
          },
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 15),
            contentPadding: EdgeInsets.only(top: 18, bottom: 10),
            hintText: "Search Users, Friend Groups, or MOOVs...",
            filled: true,
            prefixIcon: Icon(
              Icons.account_box,
              size: 28.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                clearSearch();
              },
            ),
          ),
          onFieldSubmitted: handleSearch,
        ),
      ),
    );
  }

  buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return TrendingSegment();
  }

  buildSearchResults() {
    return FutureBuilder(
      future: Future.wait(
          [searchResultsFuture, searchResultsGroups, searchResultsEvents]),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<Widget> searchResults = [];
        snapshot.data[0].documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user);
          searchResults.add(searchResult);
        });
        snapshot.data[1].documents.forEach((doc) {
          var group = doc;
          GroupResult searchResult = GroupResult(group);
          searchResults.add(searchResult);
        });
        snapshot.data[2].documents.forEach((doc) {
          var moov = doc;
          EventResult searchResult = EventResult(moov);
          searchResults.add(searchResult);
        });
        return ListView(children: searchResults);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildSearchField(),
      body:
          searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount userMe = googleSignIn.currentUser;
    final strUserId = userMe.id;
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (user.id == strUserId) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => OtherProfile(
                        user.photoUrl, user.displayName, user.id)));
              }
            },
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
              trailing: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LeaderBoardPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0),
                  child: Text(
                    "Score: ${user.score}",
                    style: new TextStyle(
                      color: TextThemes.ndBlue,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ),
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

class EventResult extends StatelessWidget {
  final moov;

  EventResult(this.moov);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostDetail(moov.data['postId'])))
            },
            child: ListTile(
              leading: Image.network(moov.data['image'],
                  fit: BoxFit.cover, height: 50, width: 70),
              title: Text(
                moov.data['title'] == null ? "" : moov.data['title'],
                style: TextStyle(
                    color: TextThemes.ndBlue, fontWeight: FontWeight.bold),
              ),
              trailing: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                color: TextThemes.ndBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PostDetail(moov.data['postId'])));
                },
                child: Text(
                  "View MOOV",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
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

class GroupResult extends StatelessWidget {
  final group;

  GroupResult(this.group);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('moov tapped'),
            child: ListTile(
              leading: Image.network(group.data['groupPic'],
                  fit: BoxFit.cover, height: 50, width: 70),
              title: Text(
                group.data['groupName'] == null ? "" : group.data['groupName'],
                style: TextStyle(
                    color: TextThemes.ndBlue, fontWeight: FontWeight.bold),
              ),
              trailing: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                color: TextThemes.ndBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                onPressed: () {
                  print(group.data);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GroupDetail(
                          group.data['groupPic'],
                          group.data['groupName'],
                          group.data['members'],
                          group.data['gid'],
                          group.data['nextMOOV'])));
                },
                child: Text(
                  "View Group",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
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
