import 'package:MOOV/main.dart';
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

class SendMOOVSearch extends StatefulWidget {
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, ownerProPic, ownerName;
  SendMOOVSearch(this.ownerId, this.previewImg, this.startDate, this.moovId,
      this.title, this.ownerName, this.ownerProPic);

  @override
  _SendMOOVSearchState createState() => _SendMOOVSearchState(
      this.ownerId,
      this.previewImg,
      this.startDate,
      this.moovId,
      this.title,
      this.ownerName,
      this.ownerProPic);
}

class _SendMOOVSearchState extends State<SendMOOVSearch>
    with SingleTickerProviderStateMixin {
  String ownerId, previewImg;
  TabController _tabController;
  int _currentIndex = 0;

  dynamic startDate, moovId;
  String title, ownerProPic, ownerName;
  _SendMOOVSearchState(this.ownerId, this.previewImg, this.startDate,
      this.moovId, this.title, this.ownerName, this.ownerProPic);

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
        new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
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
    searchController.dispose();
    _tabController.dispose();
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
                              "People",
                              gradient: LinearGradient(colors: [
                                Colors.blue.shade400,
                                Colors.blue.shade900,
                              ]),
                            )
                          : Text(
                              "People",
                              style: TextStyle(fontSize: 16.5),
                            ),
                    ),
                    // Sign Up Button

                    FlatButton(
                      splashColor: Colors.white,
                      color: Colors.white,
                      onPressed: () {
                        _tabController.animateTo(1);
                        setState(() {
                          _currentIndex =
                              (_tabController.animation.value).round();
                          _currentIndex = 1;
                        });
                      },
                      child: _currentIndex == 1
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
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
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
                                                  text: "Send the",
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
                                  return _searchTerm.length > 0
                                      ? SendMOOVResult(
                                          currSearchStuff[index]
                                              .data["displayName"],
                                          currSearchStuff[index].data["email"],
                                          currSearchStuff[index]
                                              .data["photoUrl"],
                                          currSearchStuff[index].data["id"],
                                          currSearchStuff[index]
                                              .data["verifiedStatus"],
                                          ownerId,
                                          previewImg,
                                          startDate,
                                          moovId,
                                          title,
                                          ownerName,
                                          ownerProPic)
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
      ),
    );
  }
}

class SendMOOVResult extends StatefulWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final int verifiedStatus;
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, description, address, ownerProPic, ownerName, ownerEmail;

  SendMOOVResult(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.verifiedStatus,
      this.ownerId,
      this.previewImg,
      this.startDate,
      this.moovId,
      this.title,
      this.ownerName,
      this.ownerProPic);

  @override
  _SendMOOVResultState createState() => _SendMOOVResultState(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.verifiedStatus,
      this.ownerId,
      this.previewImg,
      this.startDate,
      this.moovId,
      this.title,
      this.ownerName,
      this.ownerProPic);
}

class _SendMOOVResultState extends State<SendMOOVResult> {
  String displayName;
  String email;
  String proPic;
  String userId;
  int verifiedStatus;
  String ownerId, previewImg;
  dynamic startDate, moovId;
  String title, description, address, ownerProPic, ownerName, ownerEmail;
  bool status = false;

  _SendMOOVResultState(
      this.displayName,
      this.email,
      this.proPic,
      this.userId,
      this.verifiedStatus,
      this.ownerId,
      this.previewImg,
      this.startDate,
      this.moovId,
      this.title,
      this.ownerName,
      this.ownerProPic);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => userId != currentUser.id
              ? OtherProfile(userId)
              : ProfilePageWithHeader())),
      child: Stack(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * .72,
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
              child: SizedBox(
                child: Text(
                  displayName ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: isLargePhone
                      ? TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 18)
                      : TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                ),
              ),
            ),
            verifiedStatus == 3
                ? Padding(
                    padding: EdgeInsets.only(
                      left: 2.5,
                    ),
                    child: Icon(
                      Icons.store,
                      size: 20,
                      color: TextThemes.ndGold,
                    ),
                  )
                : verifiedStatus == 2
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: 5,
                        ),
                        child: Image.asset('lib/assets/verif2.png', height: 15),
                      )
                    : verifiedStatus == 1
                        ? Padding(
                            padding: EdgeInsets.only(
                              left: 2.5,
                            ),
                            child:
                                Image.asset('lib/assets/verif.png', height: 25),
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
        ),
        userId == currentUser.id
            ? Container()
            : status
                ? Positioned(
                    right: 20,
                    top: 10,
                    child: RaisedButton(
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
                        )),
                  )
                : Positioned(
                    right: 20,
                    top: 10,
                    child: RaisedButton(
                        padding: const EdgeInsets.all(2.0),
                        color: TextThemes.ndBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(3.0))),
                        onPressed: () {
                          Database().sendMOOVNotification(
                            userId,
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
      ]),
    );
  }
}

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
    Future<QuerySnapshot> users =
        usersRef.where("displayName", isGreaterThanOrEqualTo: query).get();
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
