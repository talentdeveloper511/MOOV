import 'dart:async';

import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/pages/search.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'ProfilePage.dart';
import 'other_profile.dart';

class FriendFinder extends StatefulWidget {
  @override
  _FriendFinderState createState() => _FriendFinderState();
}

class _FriendFinderState extends State<FriendFinder>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchController = TextEditingController();
  Future<QuerySnapshot> searchResultsFuture;
  bool get wantKeepAlive => true;
  handleSearch(String query) {
    Future<QuerySnapshot> users = usersRef
        // .where("displayName", isGreaterThanOrEqualTo: query)
        .where("friendArray", arrayContains: currentUser.id)
        .limit(5)
        .getDocuments();
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
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.all(2),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: GestureDetector(
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
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()),
          );
        },
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
            print('Leaderboards clicked');
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
            hintText: "Find your friends...",
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

  buildSearchResults() {
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

  buildNoContent() {
    currentUser.friendArray.length != 0 && currentUser.friendArray != null
        ? Timer(Duration(seconds: 1), () {
            handleSearch("");
          })
        : null;

    return SingleChildScrollView(
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
                    text: TextSpan(style: TextThemes.mediumbody, children: [
                      TextSpan(
                          text: "Fuck FOMO. \n Find your friends",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: " now",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600)),
                      TextSpan(
                          text: ".",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w300))
                    ]))),
            Image.asset('lib/assets/ff.png')
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: currentUser.friendArray.isNotEmpty
          ? buildSearchField()
          : AppBar(
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
      body: currentUser.friendArray.isEmpty
          ? StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document(currentUser.id)
                  .snapshots(),
              builder: (context, snapshot) {
                List<dynamic> friendArray;

                bool isLargePhone = Screen.diagonal(context) > 766;

                if (!snapshot.hasData) return CircularProgressIndicator();
                friendArray = snapshot.data['friendArray'];
                if (snapshot.data["friendArray"].isEmpty) {
                  return Container(
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
                                            text: "Aw, no friends? Add some",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: " now",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: ".",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.w300))
                                      ]))),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35.0),
                            child: FloatingActionButton.extended(
                                backgroundColor: Colors.pinkAccent[100],
                                onPressed: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Search()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                label: const Text("Find friends",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white))),
                          ),
                          Image.asset('lib/assets/ff.png')
                        ],
                      ),
                    ),
                  );
                } else {
                  buildNoContent();
                }
              })
          : searchResultsFuture == null
              ? buildNoContent()
              : buildSearchResults(),
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Container(
      height: 140,
      color: Colors.white,
      child: GestureDetector(
        onTap: () => print('tapped'),
        child: Card(
            color: Colors.white,
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            if (user.id == currentUser.id) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OtherProfile(
                                        user.photoUrl,
                                        user.displayName,
                                        user.id,
                                      )));
                            }
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    CachedNetworkImageProvider(user.photoUrl),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FittedBox(
                                  child: Text(
                                    user.displayName == null
                                        ? ""
                                        : user.displayName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: TextThemes.ndBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(child: Text("is going to")),
                    Container(
                        child: StreamBuilder(
                            stream: Firestore.instance
                                .collection('food')
                                .where('liker', arrayContains: user.id)
                                .orderBy('startDate')
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData)
                                return CircularProgressIndicator();
                              if (!snapshot.hasData ||
                                  snapshot.data.documents.length == 0)
                                return SizedBox(
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("nothing, right now.")),
                                    width: isLargePhone
                                        ? MediaQuery.of(context).size.width *
                                            0.51
                                        : MediaQuery.of(context).size.width *
                                            0.49,
                                    height: MediaQuery.of(context).size.height *
                                        0.15);
                              var course = snapshot.data.documents[0];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          (PostDetail(course['postId']))));
                                },
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: isLargePhone
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.51
                                            : MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.49,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.15,
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl: course['image'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              top: 0,
                                              right: 20,
                                              bottom: 7.5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
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
                                            snapshot.data.documents[0]['title'],
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                fontFamily: 'Solway',
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize:
                                                    isLargePhone ? 17.0 : 14),
                                          ),
                                        ),
                                      ),
                                    ]),
                              );
                            }))
                  ]),
            )),
      ),
    );
  }
}

// import 'package:MOOV/pages/home.dart';
// import 'package:MOOV/pages/other_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:MOOV/helpers/themes.dart';
// import 'package:MOOV/pages/post_detail.dart';
// import 'package:MOOV/pages/ProfilePage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FriendFinder extends StatefulWidget {
//   String moovId;
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> likedArray;
//   final userFriends;
//   // var moovRef;
//   FriendFinder({this.userFriends});

//   @override
//   State<StatefulWidget> createState() {
//     return FriendFinderState(this.userFriends);
//   }
// }

// class FriendFinderState extends State<FriendFinder> {
//   String moovId;
//   var moovArray;
//   var moovRef;
//   var moov;
//   TextEditingController searchController = TextEditingController();
//   List<dynamic> likedArray;
//   final userFriends;

//   friendFind(arr) {
//     moovRef = Firestore.instance
//         .collection('food')
//         .where('liker', arrayContains: arr) // add document id
//         .orderBy("startDate")
//         .getDocuments()
//         .then((QuerySnapshot docs) => {
//               if (docs.documents.isNotEmpty)
//                 {
//                   // setState(() {
//                   moov = docs.documents[0].data['title']
//                   // })
//                 }
//             });
//     print(moov);
//   }

//   FriendFinderState(this.userFriends);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//         stream: Firestore.instance
//             .collection('users')
//             .where("friendArray", arrayContains: currentUser.id)
//             .snapshots(),
//         builder: (context, snapshot) {
//           return Scaffold(
//               appBar: AppBar(
//                 leading: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.pop(
//                       context,
//                       MaterialPageRoute(builder: (context) => ProfilePage()),
//                     );
//                   },
//                 ),
//                 backgroundColor: TextThemes.ndBlue,
//                 title: Text(
//                   "Friend Finder",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               // body: Column(children: <Widget>[
//               //   // Text(friendFind(snapshot.data.documents[0].data).toString()),
//               //   Text(friendFind(snapshot.data.documents[1].data).toString()),
//               //   Text(friendFind(snapshot.data.documents[2].data).toString()),
//               // ])
//               body: ListView.builder(
//                   itemCount: snapshot.data.documents.length,
//                   itemBuilder: (_, index) {
//                     var iter = 0;
//                     while (iter == 0) {
//                       print(snapshot.data.documents[index].data['id']);
//                                             print(snapshot.data.documents[index].data['id']);
//                       print(snapshot.data.documents[index].data['id']);

//                       friendFind(snapshot.data.documents[index].data['id']);
//                       iter = iter + 1;
//                     }
//                     return moov == null
//                         ? Container(color: Colors.white)
//                         : Padding(
//                             padding: const EdgeInsets.all(2.0),
//                             child: Container(
//                                 margin: EdgeInsets.all(0.0),
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 2.0),
//                                   child: Column(
//                                     children: [
//                                       Container(
//                                           color: Colors.grey[300],
//                                           child: Row(
//                                             children: [
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: GestureDetector(
//                                                     onTap: () {
//                                                       Navigator.of(context).push(
//                                                           MaterialPageRoute(
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                         return OtherProfile(
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data[
//                                                                     'photoUrl']
//                                                                 .toString(),
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data[
//                                                                     'displayName']
//                                                                 .toString(),
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data['id']
//                                                                 .toString());
//                                                       })); //Material
//                                                     },
//                                                     child: CircleAvatar(
//                                                         radius: 22,
//                                                         child: CircleAvatar(
//                                                             radius: 22.0,
//                                                             backgroundImage:
//                                                                 NetworkImage(snapshot
//                                                                         .data
//                                                                         .documents[
//                                                                             index]
//                                                                         .data[
//                                                                     'photoUrl'])

//                                                             // NetworkImage(likedArray[index]['strPic']),

//                                                             ))),
//                                               ),
//                                               Padding(
//                                                 padding: const EdgeInsets.only(
//                                                     left: 10.0),
//                                                 child: GestureDetector(
//                                                     onTap: () {
//                                                       Navigator.of(context).push(
//                                                           MaterialPageRoute(
//                                                               builder:
//                                                                   (BuildContext
//                                                                       context) {
//                                                         return OtherProfile(
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data[
//                                                                     'photoUrl']
//                                                                 .toString(),
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data[
//                                                                     'displayName']
//                                                                 .toString(),
//                                                             snapshot
//                                                                 .data
//                                                                 .documents[
//                                                                     index]
//                                                                 .data['id']
//                                                                 .toString());
//                                                       })); //Material
//                                                     },
//                                                     child: Text(
//                                                         snapshot
//                                                             .data
//                                                             .documents[index]
//                                                             .data['displayName']
//                                                             .toString(),
//                                                         style: TextStyle(
//                                                             fontSize: 16,
//                                                             color: TextThemes
//                                                                 .ndBlue,
//                                                             decoration:
//                                                                 TextDecoration
//                                                                     .none))),
//                                               ),
//                                               Text(' is',
//                                                   style:
//                                                       TextStyle(fontSize: 16)),
//                                               Text(' Going ',
//                                                   style: TextStyle(
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 16,
//                                                       color: Colors.green)),
//                                               Text('to ',
//                                                   style:
//                                                       TextStyle(fontSize: 16)),
//                                               Spacer(),
//                                               GestureDetector(
//                                                   onTap: () {
//                                                     Navigator.of(context).push(
//                                                         MaterialPageRoute(
//                                                             builder:
//                                                                 (BuildContext
//                                                                     context) {
//                                                       return OtherProfile(
//                                                           snapshot
//                                                               .data
//                                                               .documents[index]
//                                                               .data['photoUrl']
//                                                               .toString(),
//                                                           snapshot
//                                                               .data
//                                                               .documents[index]
//                                                               .data[
//                                                                   'displayName']
//                                                               .toString(),
//                                                           snapshot
//                                                               .data
//                                                               .documents[index]
//                                                               .data['id']
//                                                               .toString());
//                                                     })); //Material
//                                                   },
//                                                   child: Text(moov.toString(),
//                                                       style: TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold,
//                                                           fontSize: 16,
//                                                           color:
//                                                               TextThemes.ndBlue,
//                                                           decoration:
//                                                               TextDecoration
//                                                                   .none))),
//                                             ],
//                                           )),
//                                     ],
//                                   ),
//                                 )),
//                           );
//                   }));
//         });
//   }
// }
