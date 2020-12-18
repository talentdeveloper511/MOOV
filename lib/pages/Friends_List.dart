import 'package:MOOV/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = Firestore.instance.collection('users');

class friendsList extends StatefulWidget {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;
  final userFriends;
  var iter = 0;

  friendsList(this.moovId, this.likedArray, {this.userFriends});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return friendsListState(this.moovId, this.likedArray, this.userFriends);
  }
}

class friendsListState extends State<friendsList> {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;
  var iter = 0;
  final userFriends;

  friendsListState(this.moovId, this.likedArray, this.userFriends);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: AppBar(
          backgroundColor: TextThemes.ndBlue,
          title: Text(
            "Friends",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 4.0),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .where("id", arrayContains: userFriends[iter])
                  .snapshots(),
              builder: (context, snapshot) {
                print(Firestore.instance
                    .collection('users')
                    .where("id", arrayContains: userFriends[iter]));
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    children: [
                      Container(
                          color: Colors.grey[300],
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: CircleAvatar(
                                    radius: 22,
                                    child: CircleAvatar(
                                        radius: 22.0,
                                        backgroundImage:
                                            AssetImage('lib/assets/me.jpg')
                                        // NetworkImage(likedArray[index]['strPic']),

                                        )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text("Kev",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: TextThemes.ndBlue,
                                        decoration: TextDecoration.none)),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(2.0),
                                  color: TextThemes.ndBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    print("Click friends");

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  },
                                  child: Text(
                                    "View Profile",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                );
                iter = iter + 1;
              }),
        ));
  }
}
