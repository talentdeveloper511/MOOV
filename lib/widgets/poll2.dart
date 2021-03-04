import 'dart:async';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/pointAnimation.dart';
import 'package:animated_widgets/animated_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:polls/polls.dart';

class PollView extends StatefulWidget {
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  bool positivePointAnimation = false;
  bool positivePointAnimation2 = false;

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
 
    String question;
    String choice1;
    String choice2;
    var x;
    var y;

    bool isLargePhone = Screen.diagonal(context) > 766;
    final dateToCheck = Timestamp.now().toDate();
    final aDate =
        DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);

    String day = DateFormat('MMMd').format(aDate);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notreDame')
            .doc('data')
            .collection('poll')
            .doc(day)
            .snapshots(),
        // ignore: missing_return
        builder: (context, snapshot) {
          // dynamic moovId;
          bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();

          voters = snapshot.data['voters'];
          question = snapshot.data['question'];
          choice1 = snapshot.data['choice1'];
          choice2 = snapshot.data['choice2'];

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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 7),
                    child: Column(
                      children: [
                        Text(
                          question,
                          textAlign: TextAlign.center,
                          style: TextThemes.headline1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Polls(
                            children: [
                              // This cannot be less than 2, else will throw an exception
                              Polls.options(title: choice1, value: option1),
                              Polls.options(title: choice2, value: option2),
                            ],
                            question: Text(
                              'ON or OFF Campus Tonight?',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 0),
                              overflow: TextOverflow.ellipsis,
                            ),
                            pollStyle: TextStyle(color: TextThemes.ndBlue),
                            currentUser: currentUser.id,
                            creatorID: this.creator,
                            voteData: voters,
                            // voteData: usersWhoVoted,
                            // userChoice: usersWhoVoted[this.userId],
                            userChoice: voters[currentUser.id],
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

                              FirebaseFirestore.instance
                                  .collection('notreDame')
                                  .doc('data')
                                  .collection('poll')
                                  .doc(day)
                                  .set({
                                "voters": {currentUser.id ?? "": choice}
                              }, SetOptions(merge: true));

                              if (choice == 1) {
                                usersRef.doc(currentUser.id).update(
                                    {"score": FieldValue.increment(25)});
                                setState(() {
                                  option1 += 1.0;
                                });
                                positivePointAnimation = true;

                                Timer(Duration(seconds: 2), () {
                                  setState(() {
                                    positivePointAnimation = false;
                                  });
                                });
                              }
                              if (choice == 2) {
                                usersRef.doc(currentUser.id?? "").update(
                                    {"score": FieldValue.increment(25)});

                                setState(() {
                                  option2 += 1.0;
                                });
                                positivePointAnimation2 = true;

                                Timer(Duration(seconds: 2), () {
                                  setState(() {
                                    positivePointAnimation2 = false;
                                  });
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
                      ],
                    ),
                  ),
                ),
                TranslationAnimatedWidget(
                    enabled: this
                        .positivePointAnimation, //update this boolean to forward/reverse the animation
                    values: [
                      Offset(175, 50), // disabled value value
                      Offset(175, 50), //intermediate value
                      Offset(175, 20) //enabled value
                    ],
                    child: OpacityAnimatedWidget.tween(
                        opacityEnabled: 1, //define start value
                        opacityDisabled: 0, //and end value
                        enabled: positivePointAnimation,
                        child: PointAnimation(25, true))),
                TranslationAnimatedWidget(
                    enabled: this
                        .positivePointAnimation2, //update this boolean to forward/reverse the animation
                    values: [
                      Offset(175, 50), // disabled value value
                      Offset(175, 50), //intermediate value
                      Offset(175, 20) //enabled value
                    ],
                    child: OpacityAnimatedWidget.tween(
                        opacityEnabled: 1, //define start value
                        opacityDisabled: 0, //and end value
                        enabled: positivePointAnimation2,
                        child: PointAnimation(25, true))),
                voters.containsKey(currentUser.id)
                    ? Positioned(
                        top: isLargePhone ? 60 : 60,
                        left: isLargePhone ? 90 : 90,
                        child: Container(
                          height: 100,
                          width: voters.length == 0
                              ? 0
                              : isLargePhone
                                  ? MediaQuery.of(context).size.width * .6
                                  : MediaQuery.of(context).size.width * .53,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              // itemCount: invitees.length,
                              itemCount: option1.toInt(),
                              itemBuilder: (_, index) {
                                voters = snapshot.data['voters'];

                                voters.removeWhere((key, value) => value == 2);

                                var p = voters.keys.toList();

                                return StreamBuilder(
                                    stream: usersRef.doc(p[index]).snapshots(),
                                    builder: (context, snapshot2) {
                                      // bool isLargePhone = Screen.diagonal(context) > 766;

                                      if (!snapshot2.hasData)
                                        return CircularProgressIndicator();
                                      var name = snapshot2.data['displayName'];
                                      var pic = snapshot2.data['photoUrl'];
                                      var id = snapshot2.data['id'];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Container(
                                          height: 27,
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: currentUser.id == id
                                                    ? () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfilePageWithHeader()));
                                                      }
                                                    : () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherProfile(
                                                                          id,
                                                                        )));
                                                      },
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(pic),
                                                    radius: 17,
                                                    backgroundColor:
                                                        TextThemes.ndBlue,
                                                    child: CircleAvatar(
                                                      // backgroundImage: snapshot.data
                                                      //     .documents[index].data['photoUrl'],
                                                      backgroundImage:
                                                          NetworkImage(pic),
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
                voters.containsKey(currentUser.id)
                    ? Positioned(
                        bottom: isLargePhone ? -35 : -35,
                        left: isLargePhone ? 90 : 90,
                        child: Container(
                          height: 100,
                          width: voters.length == 0
                              ? 0
                              : isLargePhone
                                  ? MediaQuery.of(context).size.width * .6
                                  : MediaQuery.of(context).size.width * .53,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              // itemCount: invitees.length,
                              itemCount: option2.toInt(),
                              itemBuilder: (_, index) {
                                voters = snapshot.data['voters'];

                                voters.removeWhere((key, value) => value == 1);

                                var w = voters.keys.toList();

                                return StreamBuilder(
                                    stream: usersRef.doc(w[index]).snapshots(),
                                    builder: (context, snapshot3) {
                                      // bool isLargePhone = Screen.diagonal(context) > 766;

                                      if (!snapshot3.hasData)
                                        return CircularProgressIndicator();
                                      var name2 = snapshot3.data['displayName'];
                                      var pic2 = snapshot3.data['photoUrl'];
                                      var id2 = snapshot3.data['id'];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Container(
                                          height: 27,
                                          child: Column(
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: currentUser.id == id2
                                                    ? () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfilePageWithHeader()));
                                                      }
                                                    : () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        OtherProfile(
                                                                          id2,
                                                                        )));
                                                      },
                                                child: CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(pic2),
                                                    radius: 17,
                                                    backgroundColor:
                                                        TextThemes.ndBlue,
                                                    child: CircleAvatar(
                                                      // backgroundImage: snapshot.data
                                                      //     .documents[index].data['photoUrl'],
                                                      backgroundImage:
                                                          NetworkImage(pic2),
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
