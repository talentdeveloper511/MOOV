import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
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
        .where("displayName", isGreaterThanOrEqualTo: query)
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
              child: Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Image.asset('lib/assets/ndlogo.png'),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: buildSearchField(),
      body: buildSearchResults(),
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
      height: 150,
      color: Colors.white,
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('tapped'),
            child: Card(
                child: Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                      child: Text(
                        user.displayName == null ? "" : user.displayName,
                        style: TextStyle(
                            color: TextThemes.ndBlue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
             Text("is going to")
            ])),
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
