import 'dart:async';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:polls/polls.dart';

User currentUser;

class PollView extends StatefulWidget {
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  double option1 = 1;
  double option2 = 90;
  // double option3 = 2.0;
  // double option4 = 3.0;

  Map voters = {};
  String creator = "me";
  String userId;
  String voter;
  List<dynamic> option1List;
  List<dynamic> option2List;

  @override
  Widget build(BuildContext context) {
    String userName;
    String userPic;
    var x;
    var y;
    GoogleSignInAccount user = googleSignIn.currentUser;
    userId = user.id;

    bool isLargePhone = Screen.diagonal(context) > 766;

    return StreamBuilder(
        stream:
            Firestore.instance.collection('poll').document('jan12').snapshots(),
        builder: (context, snapshot) {
          // dynamic moovId;
          bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();

          voters = snapshot.data['voters'];
          var _list = voters.values.toList();
          var _list2 = voters.keys.toList();
          option1 =
              _list.where((element) => element == 1).toList().length.toDouble();
          option2 =
              _list.where((element) => element == 2).toList().length.toDouble();

          option1List = _list.where((element) => element == 1).toList();

          option2List = _list.where((element) => element == 2).toList();

          // var count = _list.where((c) => c.product_id == 2).toList().length;

          for (var entry in voters.entries) {
            x = entry.key;
            y = entry.value;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Stack(children: [
                Container(
                  height: 200,
                  child: Polls(
                      children: [
                        // This cannot be less than 2, else will throw an exception
                        Polls.options(title: 'ON', value: option1),
                        Polls.options(title: 'OFF', value: option2),
                      ],
                      question: isLargePhone
                          ? Text(
                              '      ON or OFF Campus Tonight?',
                              textAlign: TextAlign.center,
                              style: TextThemes.headline1,
                            )
                          : Text('       ON or OFF Campus Tonight?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: TextThemes.ndBlue,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20)),
                      pollStyle: TextStyle(color: TextThemes.ndBlue),
                      currentUser: userId,
                      creatorID: this.creator,
                      voteData: voters,
                      // voteData: usersWhoVoted,
                      // userChoice: usersWhoVoted[this.userId],
                      userChoice: voters[userId],
                      onVoteBackgroundColor: Colors.blue,
                      leadingBackgroundColor: TextThemes.ndGold,
                      backgroundColor: Colors.white,
                      onVote: (choice) {
                        for (var entry in voters.entries) {
                          x = entry.key;
                          y = entry.value;
                        }

                        setState(() {
                          x = choice;
                        });

                        Firestore.instance
                            .collection('poll')
                            .document('jan12')
                            .setData({
                          "voters": {user.id: choice}
                        }, merge: true);

                        if (choice == 1) {
                          setState(() {
                            option1 += 1.0;
                          });
                        }
                        if (choice == 2) {
                          setState(() {
                            option2 += 1.0;
                          });
                        }
                        // if (choice == 3) {
                        //   setState(() {
                        //     option3 += 1.0;
                        //   });
                        // }
                        // if (choice == 4) {
                        //   setState(() {
                        //     option4 += 1.0;
                        //   });
                        // }
                      }),
                ),
                voters.containsKey(userId)
                    ? Positioned(
                        top: isLargePhone ? 45 : 40,
                        left: isLargePhone ? 80 : 70,
                        child: Container(
                          height: 100,
                          width: voters.length == 0
                              ? 0
                              : MediaQuery.of(context).size.width * .74,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              // itemCount: invitees.length,
                              itemCount: option1.toInt(),
                              itemBuilder: (_, index) {
                                voters.removeWhere((key, value) => value == 2);

                                x = voters.keys.toList();

                                return StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('users')
                                        .document(x[index])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      // bool isLargePhone = Screen.diagonal(context) > 766;

                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      userName = snapshot.data['displayName'];
                                      userPic = snapshot.data['photoUrl'];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Container(
                                          height: 27,
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtherProfile(
                                                                userPic,
                                                                userName,
                                                                x,
                                                              )));
                                                },
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(userPic),
                                                    radius: 17,
                                                    backgroundColor:
                                                        TextThemes.ndBlue,
                                                    child: CircleAvatar(
                                                      // backgroundImage: snapshot.data
                                                      //     .documents[index].data['photoUrl'],
                                                      backgroundImage:
                                                          NetworkImage(userPic),
                                                      radius: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        ),
                      )
                    : Container(),
                voters.containsKey(userId)
                    ? Positioned(
                        bottom: isLargePhone ? -20 : 40,
                        left: isLargePhone ? 80 : 70,
                        child: Container(
                          height: 100,
                          width: voters.length == 0
                              ? 0
                              : MediaQuery.of(context).size.width * .74,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              // itemCount: invitees.length,
                              itemCount: option2.toInt(),
                              itemBuilder: (_, index) {
                                voters = snapshot.data['voters'];

                                voters.removeWhere((key, value) => value == 1);

                                x = voters.keys.toList();
                                print(x);

                                return StreamBuilder(
                                    stream: Firestore.instance
                                        .collection('users')
                                        .document(x[index])
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      // bool isLargePhone = Screen.diagonal(context) > 766;

                                      if (!snapshot.hasData)
                                        return CircularProgressIndicator();
                                      userName = snapshot.data['displayName'];
                                      userPic = snapshot.data['photoUrl'];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Container(
                                          height: 27,
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              OtherProfile(
                                                                userPic,
                                                                userName,
                                                                x,
                                                              )));
                                                },
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(userPic),
                                                    radius: 17,
                                                    backgroundColor:
                                                        TextThemes.ndBlue,
                                                    child: CircleAvatar(
                                                      // backgroundImage: snapshot.data
                                                      //     .documents[index].data['photoUrl'],
                                                      backgroundImage:
                                                          NetworkImage(userPic),
                                                      radius: 18,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              }),
                        ),
                      )
                    : Container(),
              ]),
            );
          }
        });
  }
}
