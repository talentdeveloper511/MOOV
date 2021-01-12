import 'dart:async';
import 'package:MOOV/main.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';
import 'package:polls/polls.dart';

class PollView extends StatefulWidget {
  @override
  _PollViewState createState() => _PollViewState();
}

class _PollViewState extends State<PollView> {
  double option1 = 2.0;
  double option2 = 0.0;
  // double option3 = 2.0;
  // double option4 = 3.0;

  String user = "king@mail.com";
  Map usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };
  String creator = "eddy@mail.com";

  @override
  Widget build(BuildContext context) {
        bool isLargePhone = Screen.diagonal(context) > 766;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        height: 200,
        child: Polls(
          children: [
            // This cannot be less than 2, else will throw an exception
            Polls.options(title: 'ON', value: option1),
            Polls.options(title: 'OFF', value: option2),
          ],
          question: isLargePhone ?               Text('      ON or OFF Campus Tonight?', textAlign: TextAlign.center, style: TextThemes.headline1,) :

              Text('       ON or OFF Campus Tonight?', textAlign: TextAlign.center, style: TextStyle(color: TextThemes.ndBlue, fontWeight: FontWeight.w900, fontSize: 20)),
          pollStyle: TextStyle(color: TextThemes.ndBlue),
          currentUser: this.user,
          creatorID: this.creator,
          voteData: usersWhoVoted,
          userChoice: usersWhoVoted[this.user],
          onVoteBackgroundColor: Colors.blue,
          leadingBackgroundColor: Colors.blue,
          backgroundColor: Colors.white,
          onVote: (choice) {
            print(choice);
            setState(() {
              this.usersWhoVoted[this.user] = choice;
            });
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
          },
        ),
      ),
    );
  }
}
