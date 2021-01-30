import 'dart:async';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:algolia/algolia.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:intl/intl.dart';

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
    return SafeArea(
        child: Scaffold(
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
                          hintText: 'Search MOOV',
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
                : Container(
                    child: StreamBuilder<List<AlgoliaObjectSnapshot>>(
                        stream: Stream.fromFuture(_operation(_searchTerm)),
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

                          return StreamBuilder<List<AlgoliaObjectSnapshot>>(
                              stream:
                                  Stream.fromFuture(_operation2(_searchTerm)),
                              builder: (context, snapshot2) {
                                if (_searchTerm == null ||
                                    _searchTerm.length < 0) {
                                  return Container(
                                      height: 4000, child: TrendingSegment());
                                }
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return LinearProgressIndicator(
                                        backgroundColor: TextThemes.ndBlue,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.blue[200]));
                                  default:
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // if (_searchTerm.length <= 0) {
                                      //   return Container(
                                      //       height: 4000, child: TrendingSegment());
                                      // }

                                      List<AlgoliaObjectSnapshot>
                                          currSearchStuff2 = snapshot2.data;

                                      return Container(
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                        return _searchTerm.length !=
                                                                    null &&
                                                                _searchTerm.length >
                                                                    0
                                                            ? DisplaySearchResult(
                                                                displayName: currSearchStuff[index]
                                                                        .data[
                                                                    "displayName"],
                                                                email: currSearchStuff[index]
                                                                        .data[
                                                                    "email"],
                                                                proPic: currSearchStuff[index]
                                                                        .data[
                                                                    "photoUrl"],
                                                                userId: currSearchStuff[index]
                                                                    .data["id"],
                                                                isAmbassador:
                                                                    currSearchStuff[index]
                                                                            .data[
                                                                        "isAmbassador"])
                                                            : Container(
                                                                height: 4000,
                                                                child: TrendingSegment());
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
                                                                title: currSearchStuff2[
                                                                            index]
                                                                        .data[
                                                                    "title"],
                                                                description: currSearchStuff2[
                                                                            index]
                                                                        .data[
                                                                    "description"],
                                                                type: currSearchStuff2[
                                                                        index]
                                                                    .data["type"],
                                                                image: currSearchStuff2[
                                                                            index]
                                                                        .data[
                                                                    "image"],
                                                                userId: currSearchStuff2[
                                                                            index]
                                                                        .data[
                                                                    "userId"],
                                                                postId: currSearchStuff2[
                                                                            index]
                                                                        .data[
                                                                    "postId"],
                                                              )
                                                            : Container(
                                                                height: 4000,
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
                                              Container()
                                            ]),
                                      );
                                    }
                                }
                              });
                        }))));
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final bool isAmbassador;

  DisplaySearchResult({
    Key key,
    this.email,
    this.displayName,
    this.proPic,
    this.userId,
    this.isAmbassador,
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
  final bool isAmbassador;
  var startDate;

  DisplayMOOVResult(
      {Key key,
      this.description,
      this.title,
      this.type,
      this.image,
      this.userId,
      this.postId,
      this.isAmbassador,
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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostDetail(postId))),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          SizedBox(
            width: isLargePhone
                ? MediaQuery.of(context).size.width * 0.7
                : MediaQuery.of(context).size.width * 0.7,
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
              margin: EdgeInsets.only(left: 10, top: 0, right: 10, bottom: 0),
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
        ]),
      ),
    );
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
        style: TextStyle(
          // The color must be set to white for this to work
          color: Colors.white,
          fontSize: 16.5,
        ),
      ),
    );
  }
}
