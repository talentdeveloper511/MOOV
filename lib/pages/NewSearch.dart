import 'dart:async';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/OtherGroup.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcase.dart';
import 'package:showcaseview/showcase_widget.dart';

class AlgoliaApplication {
  static final Algolia algolia = Algolia.init(
    applicationId: 'CUWBHO409I', //ApplicationID
    apiKey:
        '291f55bd5573004cf3e791b3c89d0daa', //search-only api key in flutter code
  );
}

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  GlobalKey _searchKey = GlobalKey();
  bool showTabs = false;
  // TabController to control and switch tabs
  TabController _tabController;
  int _currentIndex = 0;
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;

  Widget getChildWidget() => childWidgets[selectedIndex];

  final TextEditingController searchController = TextEditingController();
  final textFieldFocusNode = FocusNode();
  void _onFocusChange() {
    if (textFieldFocusNode.hasFocus) {
      setState(() {
        showTabs = true;
      });
    } else {
      setState(() {
        showTabs = false;
      });
    }

    // print("Focus: " + textFieldFocusNode.hasFocus.toString());
  }

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation0(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("groups").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  Future<List<AlgoliaObjectSnapshot>> _operation2(String input) async {
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
    textFieldFocusNode.addListener(_onFocusChange);

    _tabController =
        new TabController(vsync: this, length: 3, initialIndex: _currentIndex);
    _tabController.animation
      ..addListener(() {
        setState(() {
          _currentIndex = (_tabController.animation.value).round();
        });
      });

    // Simple declarations
    TextEditingController searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();

    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowCase2() async {
      preferences = await SharedPreferences.getInstance();
      bool showCaseVisibilityStatus = preferences.getBool("displayShowCase2");
      if (showCaseVisibilityStatus == null) {
        preferences.setBool("displayShowCase2", false);
        return true;
      }
      return false;
    }

    displayShowCase2().then((status) {
      if (status) {
        Timer(Duration(seconds: 1), () {
          ShowCaseWidget.of(context).startShowCase([_searchKey]);
        });
      }
    });
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: showTabs == true ? 96 : 50,
              bottom: PreferredSize(
                  preferredSize: null,
                  child: Column(children: <Widget>[
                    Showcase(
                      title: "A DYNAMIC SEARCH",
                      description:
                          "\nSearch for People, Friend Groups, and MOOVs",
                      titleTextStyle: TextStyle(
                          color: TextThemes.ndBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                      descTextStyle: TextStyle(fontStyle: FontStyle.italic),
                      contentPadding: EdgeInsets.all(10),
                      key: _searchKey,
                      child: TextField(
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
                            hintText: 'Search',
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 20),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  clearSearch();
                                  // Unfocus all focus nodes
                                  textFieldFocusNode.unfocus();

                                  // Disable text field's focus node request
                                  textFieldFocusNode.canRequestFocus = false;

                                  //Enable the text field's focus node request after some delay
                                  Future.delayed(Duration(milliseconds: 10),
                                      () {
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
                    ),
                    showTabs == true
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // Sign In Button
                              new FlatButton(
                                splashColor: Colors.white,
                                color: Colors.white,
                                onPressed: () {
                                  _tabController.animateTo(0);
                                  setState(() {
                                    _currentIndex = (_tabController
                                            .animation.value)
                                        .round(); //_tabController.animation.value returns double

                                    _currentIndex = 0;
                                  });
                                },
                                child: _currentIndex == 0
                                    ? GradientText(
                                        '     People  ',
                                        gradient: LinearGradient(colors: [
                                          Colors.blue.shade400,
                                          Colors.blue.shade900,
                                        ]),
                                      )
                                    : Text(
                                        "     People  ",
                                        style: TextStyle(fontSize: 16.5),
                                      ),
                              ),
                              // Sign Up Button
                              new FlatButton(
                                splashColor: Colors.white,
                                color: Colors.white,
                                onPressed: () {
                                  _tabController.animateTo(1);
                                  setState(() {
                                    _currentIndex = 1;
                                  });
                                },
                                child: _currentIndex == 1
                                    ? GradientText(
                                        "    MOOVs",
                                        gradient: LinearGradient(colors: [
                                          Colors.blue.shade400,
                                          Colors.blue.shade900,
                                        ]),
                                      )
                                    : Text(
                                        "    MOOVs",
                                        style: TextStyle(fontSize: 16.5),
                                      ),
                              ),
                              FlatButton(
                                splashColor: Colors.white,
                                color: Colors.white,
                                onPressed: () {
                                  _tabController.animateTo(2);
                                  setState(() {
                                    _currentIndex = 2;
                                  });
                                },
                                child: _currentIndex == 2
                                    ? GradientText(
                                        "Friend Groups",
                                        gradient: LinearGradient(colors: [
                                          Colors.blue.shade400,
                                          Colors.blue.shade900,
                                        ]),
                                      )
                                    : Text(
                                        "Friend Groups",
                                        style: TextStyle(fontSize: 16.5),
                                      ),
                              )
                            ],
                          )
                        : Container(),
                  ])),
            ),
            backgroundColor: Colors.white,
            body: _searchTerm == null
                ? TrendingSegment()
                : StreamBuilder<List<AlgoliaObjectSnapshot>>(
                    stream: Stream.fromFuture(_operation0(_searchTerm)),
                    builder: (context, snapshot0) {
                      // if (!snapshot.hasData)
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // if (snapshot.data.length == 0) {
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // }

                      // if (_searchTerm.length <= 0) {
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // }

                      List<AlgoliaObjectSnapshot> currSearchStuff0 =
                          snapshot0.data;
                      return Container(
                          child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
                              stream:
                                  Stream.fromFuture(_operation(_searchTerm)),
                              builder: (context, snapshot) {
                                // if (!snapshot.hasData)
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // if (snapshot.data.length == 0) {
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // }

                                // if (_searchTerm.length <= 0) {
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // }

                                List<AlgoliaObjectSnapshot> currSearchStuff =
                                    snapshot.data;

                                return StreamBuilder<
                                        List<AlgoliaObjectSnapshot>>(
                                    stream: Stream.fromFuture(
                                        _operation2(_searchTerm)),
                                    builder: (context, snapshot2) {
                                      if (_searchTerm == null) {
                                        return linearProgress();
                                      }
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return LinearProgressIndicator(
                                              backgroundColor:
                                                  TextThemes.ndBlue,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.blue[200]));
                                        default:
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            // if (_searchTerm.length <= 0) {
                                            //   return Container(
                                            //       height: 4000, child: TrendingSegment());
                                            // }

                                            List<AlgoliaObjectSnapshot>
                                                currSearchStuff2 =
                                                snapshot2.data;

                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.90,
                                              child: TabBarView(
                                                  controller: _tabController,
                                                  children: [
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              return _searchTerm !=
                                                                      null
                                                                  ? DisplaySearchResult(
                                                                      displayName:
                                                                          currSearchStuff[index].data[
                                                                              "displayName"],
                                                                      email: currSearchStuff[index]
                                                                              .data[
                                                                          "email"],
                                                                      proPic: currSearchStuff[index]
                                                                              .data[
                                                                          "photoUrl"],
                                                                      userId: currSearchStuff[index]
                                                                              .data[
                                                                          "id"],
                                                                      verifiedStatus:
                                                                          currSearchStuff[index]
                                                                              .data["verifiedStatusador"])
                                                                  : Container();
                                                            },
                                                            childCount:
                                                                currSearchStuff
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              String privacy =
                                                                  currSearchStuff2[
                                                                              index]
                                                                          .data[
                                                                      "privacy"];
                                                              bool hide = false;
                                                              if (privacy ==
                                                                      "Friends Only" ||
                                                                  privacy ==
                                                                      "Invite Only") {
                                                                hide = true;
                                                              }
                                                              return _searchTerm !=
                                                                          null &&
                                                                      hide ==
                                                                          false
                                                                  ? DisplayMOOVResult(
                                                                      title: currSearchStuff2[index]
                                                                              .data[
                                                                          "title"],
                                                                      description:
                                                                          currSearchStuff2[index]
                                                                              .data["description"],
                                                                      type: currSearchStuff2[index]
                                                                              .data[
                                                                          "type"],
                                                                      image: currSearchStuff2[index]
                                                                              .data[
                                                                          "image"],
                                                                      userId: currSearchStuff2[index]
                                                                              .data[
                                                                          "userId"],
                                                                      postId: currSearchStuff2[index]
                                                                              .data[
                                                                          "postId"],
                                                                    )
                                                                  : Container();
                                                            },
                                                            childCount:
                                                                currSearchStuff2
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              return _searchTerm !=
                                                                      null
                                                                  ? DisplayGroupResult(
                                                                      groupName:
                                                                          currSearchStuff0[index]
                                                                              .data["groupName"],
                                                                      groupId: currSearchStuff0[index]
                                                                              .data[
                                                                          "groupId"],
                                                                      groupPic:
                                                                          currSearchStuff0[index]
                                                                              .data["groupPic"],
                                                                      members: currSearchStuff0[index]
                                                                              .data[
                                                                          "members"],
                                                                          sendMOOV: false,
                                                                    )
                                                                  : Container();
                                                            },
                                                            childCount:
                                                                currSearchStuff0
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            );
                                          }
                                      }
                                    });
                              }));
                    })));
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final int verifiedStatus;

  DisplaySearchResult({
    Key key,
    this.email,
    this.displayName,
    this.proPic,
    this.userId,
    this.verifiedStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => userId != currentUser.id
              ? OtherProfile(userId)
              : ProfilePageWithHeader())),
      child: Row(children: <Widget>[
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
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        // isAmbassador
        //     ? Padding(
        //         padding: const EdgeInsets.only(top: 3, left: 3),
        //         child: Image.asset('lib/assets/verif.png', height: 30),
        //       )
        //     : Text(""),
        // Text(
        //   email ?? "",
        //   style: TextStyle(color: Colors.black),
        // ),
        Divider(
          color: Colors.black,
        ),
      ]),
    );
  }
}

class DisplayMOOVResult extends StatelessWidget {
  final String title;
  final String description;
  final String type;
  final String image;
  final String userId;
  final String postId;
  final int verifiedStatus;
  var startDate;

  DisplayMOOVResult(
      {Key key,
      this.description,
      this.title,
      this.type,
      this.image,
      this.userId,
      this.postId,
      this.verifiedStatus,
      this.startDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // bool isToday = false;
    // bool isTomorrow = false;
    // bool isNextWeek = false;
    // final week = DateTime(now.year, now.month, now.day + 6);

    // final today = DateTime(now.year, now.month, now.day);
    // final yesterday = DateTime(now.year, now.month, now.day - 1);
    // final tomorrow = DateTime(now.year, now.month, now.day + 1);

    // final dateToCheck = startDate.toDate();
    // final aDate =
    //     DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    // if (aDate.isAfter(week)) {
    //   isNextWeek = true;
    // }

    // if (aDate == today) {
    //   isToday = true;
    // } else if (aDate == tomorrow) {
    //   isTomorrow = true;
    // }
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
                  MaterialPageRoute(builder: (context) => PostDetail(postId))),
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
              ]),
            ),
          );
        });
  }
}

class DisplayGroupResult extends StatelessWidget {
  final String groupName;
  final String groupId;
  final String groupPic;
  final List<dynamic> members;
  final String postId, title;
  final bool sendMOOV;

  DisplayGroupResult(
      {Key key,
      this.groupName,
      this.groupId,
      this.groupPic,
      this.members,
      this.postId,
      this.title,
      this.sendMOOV})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;
    for (int i = 0; i < members.length; i++) {
      return StreamBuilder(
          stream: usersRef
              .where('friendGroups', arrayContains: groupId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data.docs == null) return Container();
            var length = members.length - 2;
            var course = snapshot.data.docs;

            return Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => members.contains(currentUser.id)
                        ? GroupDetail(groupId)
                        : OtherGroup(groupId))),
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
                          imageUrl: groupPic,
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: EdgeInsets.only(
                          left: 10, top: 0, right: 10, bottom: 0),
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
                            maxWidth: MediaQuery.of(context).size.width * .3),
                        child: Text(
                          groupName,
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
                  Positioned(
                    bottom: isLargePhone ? 0 : 0,
                    right: 55,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(children: [
                          Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: members.length > 1
                                  ? CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: NetworkImage(
                                        course[1]['photoUrl'],
                                      ),
                                    )
                                  : Container()),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 4, left: 25.0),
                              child: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: NetworkImage(
                                  course[0]['photoUrl'],
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 50.0),
                            child: CircleAvatar(
                              radius: 25.0,
                              child: members.length > 2
                                  ? Text(
                                      "+" + (length.toString()),
                                      style: TextStyle(
                                          color: TextThemes.ndGold,
                                          fontWeight: FontWeight.w500),
                                    )
                                  : Text(
                                      (members.length.toString()),
                                      style: TextStyle(
                                          color: TextThemes.ndGold,
                                          fontWeight: FontWeight.w500),
                                    ),
                              backgroundColor: TextThemes.ndBlue,
                            ),
                          ),
                        ])
                      ],
                    ),
                  ),
                sendMOOV ? Positioned(
                    right: MediaQuery.of(context).size.width / 2,
                    bottom: -2.5,
                    child: RaisedButton(
                        padding: const EdgeInsets.all(2.0),
                        color: TextThemes.ndBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0))),
                        onPressed: () {
                          Database().sendMOOVNotification(
                              groupId, groupPic, postId, "", title, "", "");
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Send",
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 12.0,
                          ),
                        )),
                  ) : Container(),
                ]),
              ),
            );
          });
    }
    return Container();
  }
}

class GradientText extends StatelessWidget {
  GradientText(
    this.text, {
    @required this.gradient,
  });

  final String text;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: 16.5,
        ),
      ),
    );
  }
}

class SearchBarWithHeader extends StatefulWidget {
  SearchBarWithHeader({Key key}) : super(key: key);

  @override
  _SearchBarWithHeaderState createState() => _SearchBarWithHeaderState();
}

class _SearchBarWithHeaderState extends State<SearchBarWithHeader>
    with SingleTickerProviderStateMixin {
  // TabController to control and switch tabs
  TabController _tabController;
  int _currentIndex = 0;
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;

  Widget getChildWidget() => childWidgets[selectedIndex];

  final TextEditingController searchController = TextEditingController();
  final textFieldFocusNode = FocusNode();

  final Algolia _algoliaApp = AlgoliaApplication.algolia;
  String _searchTerm;

  Future<List<AlgoliaObjectSnapshot>> _operation0(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("groups").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  Future<List<AlgoliaObjectSnapshot>> _operation(String input) async {
    AlgoliaQuery query = _algoliaApp.instance.index("users").search(input);
    AlgoliaQuerySnapshot querySnap = await query.getObjects();
    List<AlgoliaObjectSnapshot> results = querySnap.hits;
    return results;
  }

  Future<List<AlgoliaObjectSnapshot>> _operation2(String input) async {
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
    _tabController =
        new TabController(vsync: this, length: 3, initialIndex: _currentIndex);
    _tabController.animation
      ..addListener(() {
        setState(() {
          _currentIndex = (_tabController.animation.value).round();
        });
      });

    // Simple declarations
    TextEditingController searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();

    searchController.dispose();
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
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            },
          ),
          backgroundColor: TextThemes.ndBlue,
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
        body: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 96,
              bottom: PreferredSize(
                  preferredSize: null,
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
                          hintText: 'Search',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.black),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Sign In Button
                        new FlatButton(
                          splashColor: Colors.white,
                          color: Colors.white,
                          onPressed: () {
                            _tabController.animateTo(0);
                            setState(() {
                              _currentIndex = (_tabController.animation.value)
                                  .round(); //_tabController.animation.value returns double

                              _currentIndex = 0;
                            });
                          },
                          child: _currentIndex == 0
                              ? GradientText(
                                  '     Users  ',
                                  gradient: LinearGradient(colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade900,
                                  ]),
                                )
                              : Text(
                                  "     Users  ",
                                  style: TextStyle(fontSize: 16.5),
                                ),
                        ),
                        // Sign Up Button
                        new FlatButton(
                          splashColor: Colors.white,
                          color: Colors.white,
                          onPressed: () {
                            _tabController.animateTo(1);
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          child: _currentIndex == 1
                              ? GradientText(
                                  "    MOOVs",
                                  gradient: LinearGradient(colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade900,
                                  ]),
                                )
                              : Text(
                                  "    MOOVs",
                                  style: TextStyle(fontSize: 16.5),
                                ),
                        ),
                        FlatButton(
                          splashColor: Colors.white,
                          color: Colors.white,
                          onPressed: () {
                            _tabController.animateTo(2);
                            setState(() {
                              _currentIndex = 2;
                            });
                          },
                          child: _currentIndex == 2
                              ? GradientText(
                                  "Friend Groups",
                                  gradient: LinearGradient(colors: [
                                    Colors.blue.shade400,
                                    Colors.blue.shade900,
                                  ]),
                                )
                              : Text(
                                  "Friend Groups",
                                  style: TextStyle(fontSize: 16.5),
                                ),
                        )
                      ],
                    ),
                  ])),
            ),
            backgroundColor: Colors.white,
            body: _searchTerm == null
                ? TrendingSegment()
                : StreamBuilder<List<AlgoliaObjectSnapshot>>(
                    stream: Stream.fromFuture(_operation0(_searchTerm)),
                    builder: (context, snapshot0) {
                      // if (!snapshot.hasData)
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // if (snapshot.data.length == 0) {
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // }

                      // if (_searchTerm.length <= 0) {
                      //   return Container(
                      //       height: 4000, child: TrendingSegment());
                      // }

                      List<AlgoliaObjectSnapshot> currSearchStuff0 =
                          snapshot0.data;
                      return Container(
                          child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
                              stream:
                                  Stream.fromFuture(_operation(_searchTerm)),
                              builder: (context, snapshot) {
                                // if (!snapshot.hasData)
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // if (snapshot.data.length == 0) {
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // }

                                // if (_searchTerm.length <= 0) {
                                //   return Container(
                                //       height: 4000, child: TrendingSegment());
                                // }

                                List<AlgoliaObjectSnapshot> currSearchStuff =
                                    snapshot.data;

                                return StreamBuilder<
                                        List<AlgoliaObjectSnapshot>>(
                                    stream: Stream.fromFuture(
                                        _operation2(_searchTerm)),
                                    builder: (context, snapshot2) {
                                      if (_searchTerm == null) {
                                        return Container(
                                            height: 4000,
                                            child: TrendingSegment());
                                      }
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return LinearProgressIndicator(
                                              backgroundColor:
                                                  TextThemes.ndBlue,
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.blue[200]));
                                        default:
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            // if (_searchTerm.length <= 0) {
                                            //   return Container(
                                            //       height: 4000, child: TrendingSegment());
                                            // }

                                            List<AlgoliaObjectSnapshot>
                                                currSearchStuff2 =
                                                snapshot2.data;

                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.90,
                                              child: TabBarView(
                                                  controller: _tabController,
                                                  children: [
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              return _searchTerm !=
                                                                      null
                                                                  ? DisplaySearchResult(
                                                                      displayName:
                                                                          currSearchStuff[index].data[
                                                                              "displayName"],
                                                                      email: currSearchStuff[index]
                                                                              .data[
                                                                          "email"],
                                                                      proPic: currSearchStuff[index]
                                                                              .data[
                                                                          "photoUrl"],
                                                                      userId: currSearchStuff[index]
                                                                              .data[
                                                                          "id"],
                                                                      verifiedStatus:
                                                                          currSearchStuff[index]
                                                                              .data["verifiedStatus"])
                                                                  : Container();
                                                            },
                                                            childCount:
                                                                currSearchStuff
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              return _searchTerm
                                                                              .length !=
                                                                          null &&
                                                                      _searchTerm
                                                                              .length >
                                                                          0
                                                                  ? DisplayMOOVResult(
                                                                      title: currSearchStuff2[index]
                                                                              .data[
                                                                          "title"],
                                                                      description:
                                                                          currSearchStuff2[index]
                                                                              .data["description"],
                                                                      type: currSearchStuff2[index]
                                                                              .data[
                                                                          "type"],
                                                                      image: currSearchStuff2[index]
                                                                              .data[
                                                                          "image"],
                                                                      userId: currSearchStuff2[index]
                                                                              .data[
                                                                          "userId"],
                                                                      postId: currSearchStuff2[index]
                                                                              .data[
                                                                          "postId"],
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          4000,
                                                                      child:
                                                                          TrendingSegment());
                                                            },
                                                            childCount:
                                                                currSearchStuff2
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    CustomScrollView(
                                                      shrinkWrap: true,
                                                      slivers: <Widget>[
                                                        SliverList(
                                                          delegate:
                                                              SliverChildBuilderDelegate(
                                                            (context, index) {
                                                              return _searchTerm
                                                                              .length !=
                                                                          null &&
                                                                      _searchTerm
                                                                              .length >
                                                                          0
                                                                  ? DisplayGroupResult(
                                                                      groupName:
                                                                          currSearchStuff0[index]
                                                                              .data["groupName"],
                                                                      groupId: currSearchStuff0[index]
                                                                              .data[
                                                                          "groupId"],
                                                                      groupPic:
                                                                          currSearchStuff0[index]
                                                                              .data["groupPic"],
                                                                      members: currSearchStuff0[index]
                                                                              .data[
                                                                          "members"],
                                                                          sendMOOV: false,
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          4000,
                                                                      child:
                                                                          TrendingSegment());
                                                            },
                                                            childCount:
                                                                currSearchStuff0
                                                                        .length ??
                                                                    0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ]),
                                            );
                                          }
                                      }
                                    });
                              }));
                    })));
  }
}
