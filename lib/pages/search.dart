import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
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
  bool get wantKeepAlive => true;
  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .getDocuments();
    Future<QuerySnapshot> events =
        postsRef.where("title", isGreaterThanOrEqualTo: query).getDocuments();
    setState(() {
      searchResultsFuture = users;
      searchResultsEvents = events;
    });
  }

  clearSearch() {
    searchController.clear();
    setState(() {
      searchResultsFuture = null;
      searchResultsEvents = null;
    });
  }

  AppBar buildSearchField() {
    return AppBar(
      toolbarHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(2),
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
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 50.0,
                ),
              ),
            ),
          ],
        ),
      ),
      leading: GestureDetector(
        onTap: () {
         Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('lib/assets/ndlogo.png'),
        ),
      ),
      backgroundColor: TextThemes.ndBlue,
      //pinned: true,
      actions: <Widget>[
        IconButton(
          padding: EdgeInsets.all(5.0),
          icon: Icon(Icons.insert_chart),
          color: Colors.white,
          splashColor: Color.fromRGBO(220, 180, 57, 1.0),
          onPressed: () {
            // Implement navigation to leaderboard page here...
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LeaderBoardPage()));
          },
        ),
        IconButton(
          padding: EdgeInsets.all(5.0),
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Icon(Icons.notifications_active),
          ),
          color: Colors.white,
          splashColor: Color.fromRGBO(220, 180, 57, 1.0),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationFeed()));
          },
        )
      ],
      bottom: PreferredSize(
        preferredSize: null,
        child: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 15),
            contentPadding: EdgeInsets.only(top: 18, bottom: 10),
            hintText: "Search for Users or MOOVs...",
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
    return TrendingSegment();
  }

  buildSearchResults() {
    // List<Widget> results = [];
    // return FutureBuilder(
    //   future: searchResultsEvents,
    //   builder: (context, snapshot) {
    //     if (!snapshot.hasData) {
    //       return circularProgress();
    //     }
    //     // List<EventResult> searchResults = [];
    //     snapshot.data.documents.forEach((doc) {
    //       print(doc);
    //       var moov = doc;
    //       EventResult searchResult = EventResult(moov);
    //       results.add(searchResult);
    //     });
    //     return ListView(
    //       children: results,
    //     );
    //   },
    // );
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        List<UserResult> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          User user = User.fromDocument(doc);
          UserResult searchResult = UserResult(user);
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
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white12,
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
            onTap: () => print('tapped'),
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
              trailing: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                color: TextThemes.ndBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                onPressed: () {
                  if (user.id == strUserId) {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OtherProfile(
                            user.photoUrl, user.displayName, user.id)));
                  }
                },
                child: Text(
                  "View Profile",
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
            onTap: () => print('moov tapped'),
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
                  // if (moov.id == strUserId) {
                  //   Navigator.of(context).push(
                  //       MaterialPageRoute(builder: (context) => ProfilePage()));
                  // } else {
                  //   Navigator.of(context).push(MaterialPageRoute(
                  //       builder: (context) => OtherProfile(
                  //           user.photoUrl, user.displayName, user.id)));
                  // }
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
