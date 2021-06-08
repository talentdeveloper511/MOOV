import 'package:MOOV/main.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:shimmer/shimmer.dart';
import 'create_group.dart';

class FriendGroupsPage extends StatefulWidget {
  @override
  _FriendGroupsState createState() {
    return _FriendGroupsState();
  }
}

class _FriendGroupsState extends State<FriendGroupsPage>
    with AutomaticKeepAliveClientMixin {
  Container buildNoContent() {
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //   ),
        //   backgroundColor: TextThemes.ndBlue,
        //   title: Text(
        //     "Friend Groups",
        //     style: TextStyle(color: Colors.white, fontSize: 25),
        //   ),
        // ),
        body: StreamBuilder(
            stream: groupsRef
                .where('members', arrayContains: currentUser.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data.docs.length == 0) {
                return Container(
                  child: Center(
                      child: Column(
                    children: [
                      Stack(alignment: Alignment.center, children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: SizedBox(
                            height: isLargePhone
                                ? MediaQuery.of(context).size.height * 0.175
                                : MediaQuery.of(context).size.height * .2,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: ClipRRect(
                                child: Image.asset(
                                  'lib/assets/fg.jpeg',
                                  color: Colors.black12,
                                  colorBlendMode: BlendMode.darken,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              margin: EdgeInsets.only(
                                  left: 0, top: 0, right: 0, bottom: 7.5),
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: isLargePhone ? 30 : 25,
                            right: 20,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupForm())),
                              child: Text(
                                "Create one",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
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
                                  child: Text(
                                    "Friend Groups",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Solway',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 24),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Text(
                        "\n\nWhen added to Friend Groups,\n they will appear here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )),
                );
              }

              return CustomScrollView(
                physics: ClampingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                      child:
                          Stack(alignment: Alignment.center, children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: SizedBox(
                        height: isLargePhone
                            ? MediaQuery.of(context).size.height * 0.175
                            : MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          child: ClipRRect(
                            child: Image.asset(
                              'lib/assets/fg.jpeg',
                              color: Colors.black12,
                              colorBlendMode: BlendMode.darken,
                              fit: BoxFit.cover,
                            ),
                          ),
                          margin: EdgeInsets.only(
                              left: 0, top: 0, right: 0, bottom: 7.5),
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: isLargePhone ? 30 : 25,
                        right: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GroupForm())),
                          child: Text(
                            "Create another",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                              child: Text(
                                "Friend Groups",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Solway',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
                  SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        if (snapshot.data.docs.length == 0) {
                          return Container();
                        }

                        DocumentSnapshot course = snapshot.data.docs[index];
                        var length = course['members'].length - 2;
                        String groupId = course['groupId'];

                        // var rng = new Random();
                        // var l = rng.nextInt(course['members'].length);
                        // print(l);
                        // print(course['groupName']);

                        return StreamBuilder(
                            stream: usersRef
                                .where('friendGroups', arrayContains: groupId)
                                .snapshots(),
                            builder: (context, snapshot3) {
                              if (!snapshot3.hasData)
                                return CircularProgressIndicator();
                              if (snapshot3.hasError || snapshot3.data == null)
                                return CircularProgressIndicator();

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // color: Colors.white,
                                  clipBehavior: Clip.none,
                                  child: Stack(
                                    children: <Widget>[
                                      InkWell(
                                        highlightColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        child: Bounce(
                                          duration: Duration(milliseconds: 110),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        GroupDetail(groupId)));
                                          },
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black,
                                                        blurRadius: 12.0,
                                                        offset:
                                                            Offset(0.0, 5.0),
                                                      ),
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                    child: CachedNetworkImage(
                                                      placeholder:
                                                          (context, url) {
                                                        return Container(
                                                          child: Shimmer
                                                              .fromColors(
                                                            baseColor: Colors
                                                                .grey[300],
                                                            highlightColor:
                                                                Colors
                                                                    .grey[100],
                                                            child: Container(
                                                              height: 60.0,
                                                              width: 60.0,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ),
                                                          color: Colors.red,
                                                        );
                                                      },
                                                      imageUrl:
                                                          course['groupPic'],
                                                      fit: BoxFit.cover,
                                                      height: isLargePhone
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.11
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.13,
                                                      width: isLargePhone
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.5),
                                                child: Center(
                                                  child: FittedBox(
                                                    child: Text(
                                                      course['groupName']
                                                          .toString(),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: isLargePhone
                                                              ? 20.0
                                                              : 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: isLargePhone ? 80 : 70,
                                        right: 20,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Stack(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: course['members']
                                                              .length >
                                                          1
                                                      ? CircleAvatar(
                                                          radius: 20.0,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            snapshot3.data
                                                                    .docs[1]
                                                                ['photoUrl'],
                                                          ),
                                                        )
                                                      : Container()),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4, left: 20.0),
                                                  child: CircleAvatar(
                                                    radius: 20.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      snapshot3.data.docs[0]
                                                          ['photoUrl'],
                                                    ),
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, left: 40.0),
                                                child: CircleAvatar(
                                                  radius: 20.0,
                                                  child: course['members']
                                                              .length >
                                                          2
                                                      ? Text(
                                                          "+" +
                                                              (length
                                                                  .toString()),
                                                          style: TextStyle(
                                                              color: TextThemes
                                                                  .ndGold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Text(
                                                          (course['members']
                                                              .length
                                                              .toString()),
                                                          style: TextStyle(
                                                              color: TextThemes
                                                                  .ndGold,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                ),
                                              ),
                                            ])
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }, childCount: snapshot.data.docs.length),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      )),
                ],
              );
            }));
  }
}
