import 'dart:async';

import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
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

class SearchSetMOOV extends StatefulWidget {
  List members;
  String gid, groupName;
  SearchSetMOOV(this.members, this.gid, this.groupName);

  @override
  _SearchSetMOOVState createState() =>
      _SearchSetMOOVState(this.members, this.gid, this.groupName);
}

class _SearchSetMOOVState extends State<SearchSetMOOV> {
  List members;
  String gid, groupName;
  _SearchSetMOOVState(this.members, this.gid, this.groupName);

  final TextEditingController searchController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("events").search(input);
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
            icon: Icon(Icons.arrow_drop_down_outlined,
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
                if (!snapshot.hasData ||
                    snapshot.data.length == 0 ||
                    _searchTerm == null)
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink[300], Colors.pink[200]],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(50.0),
                                  child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          style: TextThemes.mediumbody,
                                          children: [
                                            TextSpan(
                                                text: "Suggest the",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w300)),
                                            TextSpan(
                                                text: " MOOV",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            TextSpan(
                                                text: ".",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.w300))
                                          ]))),
                              Image.asset('lib/assets/ff.png')
                            ],
                          ),
                        ),
                      ));

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
                                String privacy =
                                    currSearchStuff[index].data["privacy"];
                                bool hide = false;
                                if (privacy == "Friends Only" ||
                                    privacy == "Invite Only") {
                                  hide = true;
                                }
                                if (currSearchStuff[index].data['userId'] ==
                                    currentUser.id) {
                                  hide = false;
                                }

                                return _searchTerm != null && hide == false
                                    ? SetMOOVResult(
                                        currSearchStuff[index].data["title"],
                                        currSearchStuff[index].data["userId"],
                                        currSearchStuff[index]
                                            .data["description"],
                                        currSearchStuff[index].data["type"],
                                        currSearchStuff[index].data["image"],
                                        members,
                                        currSearchStuff[index].data["postId"],
                                        currSearchStuff[index].data["unix"],
                                        gid,
                                        groupName)
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

class SetMOOVResult extends StatefulWidget {
  final String title;
  final String userId;
  final String description;
  final String type;
  final String image;
  final List members;
  final String moov, gid, groupName;
  final int unix;

  SetMOOVResult(this.title, this.userId, this.description, this.type,
      this.image, this.members, this.moov, this.unix, this.gid, this.groupName);

  @override
  _SetMOOVResultState createState() => _SetMOOVResultState(
      this.title,
      this.userId,
      this.description,
      this.type,
      this.image,
      this.members,
      this.moov,
      this.unix,
      this.gid,
      this.groupName);
}

class _SetMOOVResultState extends State<SetMOOVResult> {
  final String title;
  final String userId;
  final String description;
  final String type;
  final String image;
  final List members;
  final String moov, gid, groupName;
  final int unix;

  _SetMOOVResultState(this.title, this.userId, this.description, this.type,
      this.image, this.members, this.moov, this.unix, this.gid, this.groupName);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return StreamBuilder(
        stream: usersRef.doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          if (snapshot.data == null) return Container();
          String proPic = snapshot.data['photoUrl'];
          return Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PostDetail(moov))),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                SizedBox(
                  width: isLargePhone
                      ? MediaQuery.of(context).size.width * 0.8
                      : MediaQuery.of(context).size.width * 0.8,
                  height: isLargePhone
                      ? MediaQuery.of(context).size.height * 0.15
                      : MediaQuery.of(context).size.height * 0.17,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin:
                        EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
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
                Container(
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .4),
                      child: Text(
                        title,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Solway',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isLargePhone ? 17.0 : 14),
                      ),
                    ),
                  ),
                ),
                // isToday == false
                //     ? Positioned(
                //         top: 0,
                //         right: 0,
                //         child: Container(
                //           height: 30,
                //           padding: EdgeInsets.all(4),
                //           decoration: BoxDecoration(
                //               gradient: LinearGradient(
                //                 colors: [Colors.pink[400], Colors.purple[300]],
                //                 begin: Alignment.centerLeft,
                //                 end: Alignment.centerRight,
                //               ),
                //               borderRadius: BorderRadius.circular(10.0)),
                //           child: isNextWeek ? Text("") : Text(""),
                //         ),
                //       )
                //     : Container(),
                // isToday == true
                //     ? Positioned(
                //         top: 0,
                //         right: 0,
                //         child: Container(
                //           height: 30,
                //           padding: EdgeInsets.all(4),
                //           decoration: BoxDecoration(
                //               gradient: LinearGradient(
                //                 colors: [Colors.red[400], Colors.red[600]],
                //                 begin: Alignment.centerLeft,
                //                 end: Alignment.centerRight,
                //               ),
                //               borderRadius: BorderRadius.circular(10.0)),
                //           child: Text(""),
                //         ),
                //       )
                //     : Text(""),
                Positioned(
                  bottom: 8.5,
                  right: isLargePhone ? 60 : 55,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: TextThemes.ndGold,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20.0,
                          offset: Offset(5.0, 5.0),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                        radius: 27,
                        backgroundColor: TextThemes.ndGold,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(proPic),
                          radius: 25,
                          backgroundColor: TextThemes.ndBlue,
                        )),
                  ),
                ),
                Positioned(
                  bottom: 7.5,
                  child: GestureDetector(
                    onTap: () {
                      Database().suggestMOOV(
                          currentUser.id,
                          gid,
                          moov,
                          unix,
                          currentUser.displayName,
                          members,
                          title,
                          image,
                          groupName);
                      Database().betaActivityTracker(
                          currentUser.displayName, Timestamp.now(), "suggest");

                      Navigator.pop(context, moov);
                    },
                    child: Container(
                      height: 30,
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink[400], Colors.purple[300]],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: Text(
                          "Suggest",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        });
  }
}

class SetMOOV extends StatefulWidget {
  String moov, gid, groupName;
  List members;

  SetMOOV(this.moov, this.gid, this.members, this.groupName);

  @override
  _SetMOOVState createState() =>
      _SetMOOVState(this.moov, this.gid, this.members, this.groupName);
}

class _SetMOOVState extends State<SetMOOV> {
  String moov, gid, groupName;
  List members;

  _SetMOOVState(this.moov, this.gid, this.members, this.groupName);
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  Future<QuerySnapshot> searchResultsEvents;

  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        .where("displayName", isGreaterThanOrEqualTo: query)
        .limit(5)
        .get();
    Future<QuerySnapshot> events =
        postsRef.where("title", isGreaterThanOrEqualTo: query).get();

    setState(() {
      searchResultsFuture = users;
      searchResultsEvents = events;
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
            hintText: "Search for MOOVs...",
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
    List<Widget> results = [];
    return FutureBuilder(
      future: searchResultsEvents,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // List<EventResult> searchResults = [];
        snapshot.data.docs.forEach((doc) {
          var moov = doc;
          EventResult searchResult = EventResult(moov, gid, members, groupName);
          results.add(searchResult);
        });
        return ListView(
          children: results,
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

class EventResult extends StatelessWidget {
  final moov, gid, members;
  String groupName;

  EventResult(this.moov, this.gid, this.members, this.groupName);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('moov tapped'),
            child: ListTile(
              leading: Image.network(moov['image'],
                  fit: BoxFit.cover, height: 50, width: 70),
              title: Text(
                moov['title'] == null ? "" : moov['title'],
                style: TextStyle(
                    color: TextThemes.ndBlue, fontWeight: FontWeight.bold),
              ),
              trailing: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                color: TextThemes.ndBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                onPressed: () {
                  Database().suggestMOOV(
                      currentUser.id,
                      gid,
                      moov['postId'],
                      moov['startDate'],
                      currentUser.displayName,
                      members,
                      moov['title'],
                      moov['image'],
                      groupName);
                  Navigator.pop(context, moov['postId']);
                },
                child: Text(
                  "Set MOOV",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
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

  void setState(Null Function() param0) {}
}
