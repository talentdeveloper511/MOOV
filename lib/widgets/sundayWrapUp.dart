import 'dart:async';

import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SundayWrapUp extends StatefulWidget {
  final String title, description, choice1, choice2, image, postTitle, day;

  // final MyEventCallback choice1Action, choice2Action;

  const SundayWrapUp(
      {Key key,
      this.title,
      this.description,
      this.choice1,
      this.choice2,
      this.image,
      // this.choice1Action,
      // this.choice2Action,
      this.postTitle,
      this.day});

  @override
  _SundayWrapUpState createState() => _SundayWrapUpState();
}

class _SundayWrapUpState extends State<SundayWrapUp> {
  ScrollController _arrowsController = ScrollController();
  bool isChecking = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        child: contentBox(context));
  }

  contentBox(context) {
    //to get first name
    String fullName = currentUser.displayName;
    List<String> tempList = fullName.split(" ");
    int start = 0;
    int end = tempList.length;
    if (end > 1) {
      end = 1;
    }
    final selectedWords = tempList.sublist(start, end);
    String firstName = selectedWords.join(" ");

    return Stack(
      children: [
        Container(
          color: Colors.indigo.shade100,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text(
                  "Sunday Wrap-up",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: TextThemes.ndBlue),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, left: 20, right: 20, bottom: 25),
                child: Text(
                  "What a week, $firstName! Here's your recap, be sure to save any Memorable MOOVs before they expire tonight!",
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                    stream: wrapupRef
                        .doc(currentUser.id)
                        .collection('wrapUp')
                        .doc(widget.day)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Container();
                      }
                      Map goingMOOVs = {};
                      Map ownMOOVs = {};
                      Map newFriends = {};

                      if (snapshot.data.data()['goingMOOVs'] != null) {
                        goingMOOVs = snapshot.data.data()['goingMOOVs'];
                      }
                      if (snapshot.data.data()['ownMOOVs'] != null) {
                        goingMOOVs = snapshot.data.data()['ownMOOVs'];
                      }
                      if (snapshot.data.data()['newFriends'] != null) {
                        goingMOOVs = snapshot.data.data()['newFriends'];
                      }

                      // snapshot.data.forEach((doc){
                      //   print(doc);
                      // });

                      return DraggableScrollbar.arrows(
                        labelTextBuilder: (double offset) =>
                            Text("${offset ~/ 100}"),
                        controller: _arrowsController,
                        child: ListView.builder(
                          controller: _arrowsController,
                          itemCount: 8,
                          itemExtent: 100.0,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              child: Material(
                                elevation: 4.0,
                                borderRadius: BorderRadius.circular(4.0),
                                color: Colors.purple[index % 9 * 100],
                                child: Center(
                                  child: Text(index.toString()),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        Positioned(
          child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(Icons.cancel_outlined)),
          top: 5,
          right: 5,
        )
      ],
    );
  }
}
