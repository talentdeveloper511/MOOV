import 'dart:async';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:algolia/algolia.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';

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

class _SearchBarState extends State<SearchBar> {
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
    return SafeArea(
      child: Scaffold(
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
                          icon: Icon(
                        Icons.clear,
                        color: Colors.black,
                      ))),
                )),
            StreamBuilder<List<AlgoliaObjectSnapshot>>(
              stream: Stream.fromFuture(_operation(_searchTerm)),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Container(height: 20000, child: TrendingSegment());
                // return Text(
                //   "Start Typing",
                //   style: TextStyle(color: Colors.black),
                // );
                else {
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
                                      ? DisplaySearchResult(
                                          displayName: currSearchStuff[index]
                                              .data["displayName"],
                                          email: currSearchStuff[index]
                                              .data["email"],
                                          proPic: currSearchStuff[index]
                                              .data["photoUrl"],
                                          userId:
                                              currSearchStuff[index].data["id"],
                                          isAmbassador: currSearchStuff[index]
                                              .data["isAmbassador"])
                                      : Container();
                                },
                                childCount: currSearchStuff.length ?? 0,
                              ),
                            ),
                          ],
                        );
                  }
                }
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class DisplaySearchResult extends StatelessWidget {
  final String displayName;
  final String email;
  final String proPic;
  final String userId;
  final bool isAmbassador;

  DisplaySearchResult(
      {Key key,
      this.email,
      this.displayName,
      this.proPic,
      this.userId,
      this.isAmbassador})
      : super(key: key);

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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 20),
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
    );
  }
}
