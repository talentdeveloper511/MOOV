import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendFinder extends StatefulWidget {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;
  final userFriends;
  var moovRef;

  FriendFinder({this.userFriends});

  @override
  State<StatefulWidget> createState() {
    return FriendFinderState(this.userFriends);
  }
}

class FriendFinderState extends State<FriendFinder> {
  dynamic moovId;
  var moovRef;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;
  var empty = true;
  var moov;
  final userFriends;

  FriendFinderState(this.userFriends);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where("friendArray", arrayContains: currentUser.id)
            .snapshots(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
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
                title: Text(
                  "Friend Finder",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    moovId = snapshot.data.documents[0].data['likedMoovs'][0];
                    moovRef = Firestore.instance
                        .collection('food')
                        .where('id', isEqualTo: moovId)
                        .getDocuments()
                        .then((QuerySnapshot docs) => {
                              if (docs.documents.isNotEmpty)
                                {
                                  setState(() {
                                    empty = false;
                                    moov = docs.documents[0].data['title'];
                                    print(moov);
                                  })
                                }
                            });
                    print(moovId);
                    return
                        // moov == null
                        //     ? Text('') :
                        Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Container(
                          margin: EdgeInsets.all(0.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              children: [
                                Container(
                                    color: Colors.grey[300],
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return OtherProfile(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['photoUrl']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['displayName']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['id']
                                                          .toString());
                                                })); //Material
                                              },
                                              child: CircleAvatar(
                                                  radius: 22,
                                                  child: CircleAvatar(
                                                      radius: 22.0,
                                                      backgroundImage:
                                                          NetworkImage(snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['photoUrl'])

                                                      // NetworkImage(likedArray[index]['strPic']),

                                                      ))),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return OtherProfile(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['photoUrl']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['displayName']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['id']
                                                          .toString());
                                                })); //Material
                                              },
                                              child: Text(
                                                  snapshot.data.documents[index]
                                                      .data['displayName']
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: TextThemes.ndBlue,
                                                      decoration: TextDecoration
                                                          .none))),
                                        ),
                                        Text(' is ',
                                            style: TextStyle(fontSize: 16)),
                                        Text(' Going ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.green)),
                                        Text(' to ',
                                            style: TextStyle(fontSize: 16)),
                                        Spacer(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return OtherProfile(
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['photoUrl']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['displayName']
                                                          .toString(),
                                                      snapshot
                                                          .data
                                                          .documents[index]
                                                          .data['id']
                                                          .toString());
                                                })); //Material
                                              },
                                              child: Text(moov.toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: TextThemes.ndBlue,
                                                      decoration: TextDecoration
                                                          .none))),
                                        ),
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(right: 8),
                                        //   child: RaisedButton(
                                        //     padding:
                                        //         const EdgeInsets.all(2.0),
                                        //     color: Colors.green,
                                        //     shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.all(
                                        //                 Radius.circular(
                                        //                     3.0))),
                                        //     onPressed: () {
                                        //       Navigator.of(context).push(
                                        //           MaterialPageRoute(
                                        //               builder: (context) =>
                                        //                   OtherProfile(
                                        //                       snapshot
                                        //                           .data
                                        //                           .documents[
                                        //                               index]
                                        //                           .data[
                                        //                               'photoUrl']
                                        //                           .toString(),
                                        //                       snapshot
                                        //                           .data
                                        //                           .documents[
                                        //                               index]
                                        //                           .data[
                                        //                               'displayName']
                                        //                           .toString(),
                                        //                       snapshot
                                        //                           .data
                                        //                           .documents[
                                        //                               index]
                                        //                           .data['id']
                                        //                           .toString())));
                                        //     },
                                        //     child: Text(
                                        //       "Friends",
                                        //       style: new TextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 14.0,
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    )),
                              ],
                            ),
                          )),
                    );
                  }));
        });
  }
}
