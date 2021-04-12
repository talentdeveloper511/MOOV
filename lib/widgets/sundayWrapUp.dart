import 'dart:async';
import 'dart:math';

import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  int length = 0;
  final List<Color> colorList = [
    Colors.purple[50],
    Colors.purple[100],
    Colors.purple[200],
    Colors.pink[50],
    Colors.pink[100],
  ];
  final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
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
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: wrapupRef
                        .doc(currentUser.id)
                        .collection('wrapUp')
                        .doc(widget.day)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data == null) {
                        return Container();
                      }
                      Map goingMOOVs = {};
                      Map ownMOOVs = {};
                      Map newFriends = {};

                      if (snapshot.data.data()['goingMOOVs'] != null) {
                        goingMOOVs = snapshot.data.data()['goingMOOVs'];
                        length = length + 1;
                      }
                      if (snapshot.data.data()['ownMOOVs'] != null) {
                        ownMOOVs = snapshot.data.data()['ownMOOVs'];
                        length = length + 1;
                      }
                      if (snapshot.data.data()['newFriends'] != null) {
                        newFriends = snapshot.data.data()['newFriends'];
                        length = length + 1;
                      }

                      return DraggableScrollbar.arrows(
                        // labelTextBuilder: (double offset) =>
                        //     Text("${offset ~/ 100}"),
                        controller: _arrowsController,
                        child:
                            ListView(controller: _arrowsController, children: [
                          (ownMOOVs.isNotEmpty)
                              ? Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10),
                                          child: Text(
                                            "You Made MOOVs.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          "Here are the MOOVs you posted \nthis week. Save 'em or lose 'em.",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 150,
                                      padding: EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 4.0,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: colorList[
                                            _random.nextInt(colorList.length)],
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemExtent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .6,
                                          itemCount: ownMOOVs.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      right: 10.0, left: 10)
                                                  : EdgeInsets.only(
                                                      right: 20.0, left: 0),
                                              child: Container(
                                                height: 100,
                                                child: WrapMOOV(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          (goingMOOVs.isNotEmpty)
                              ? Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10),
                                          child: Text(
                                            "You Went to MOOVs.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          "Here are the MOOVs you attended \nthis week. Save 'em or lose 'em.",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 150,
                                      padding: EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 4.0,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: colorList[
                                            _random.nextInt(colorList.length)],
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemExtent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .6,
                                          itemCount: goingMOOVs.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      right: 10.0, left: 10)
                                                  : EdgeInsets.only(
                                                      right: 20.0, left: 0),
                                              child: Container(
                                                height: 100,
                                                child: WrapMOOV(),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          (newFriends.isNotEmpty)
                              ? Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10),
                                          child: Text(
                                            "You Made Friends.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          "Check in with your new friends.",
                                          style: TextStyle(fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 150,
                                      padding: EdgeInsets.all(8.0),
                                      child: Material(
                                        elevation: 4.0,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: colorList[
                                            _random.nextInt(colorList.length)],
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemExtent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .6,
                                          itemCount: newFriends.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      right: 10.0,
                                                      left: 0,
                                                      top: 10,
                                                      bottom: 10)
                                                  : EdgeInsets.only(
                                                      right: 20.0,
                                                      left: 0,
                                                      top: 10,
                                                      bottom: 10),
                                              child: Container(
                                                height: 100,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                  child: CircleAvatar(
                                                      radius: 52.5,
                                                      backgroundImage:
                                                          NetworkImage(
                                                        currentUser.photoUrl,
                                                      )),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                        ]),
                      );
                    }),
              ),
            ],
          ),
        ),
        Positioned(
          child: GestureDetector(
              onTap: () {
                wrapupRef
                    .doc(currentUser.id)
                    .collection("wrapUp")
                    .doc(widget.day)
                    .set({"seen": true}, SetOptions(merge: true));
                Navigator.of(context).pop();
              },
              child: Icon(Icons.cancel_outlined)),
          top: 5,
          right: 5,
        ),
        Positioned(
          child: Transform.rotate(
            angle: 100,
            child: Container(
                height: 10.0,
                width: 130.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple[200], Colors.purple[800]],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                )),
          ),
          top: 5,
          left: -10,
        )
      ],
    );
  }
}

class WrapMOOV extends StatelessWidget {
  const WrapMOOV({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: 200,
          child: Stack(children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1.0,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('lib/assets/motd.jpg', fit: BoxFit.cover),
                ),
                margin: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "YOUR MOOV",
                      style: TextStyle(
                          fontFamily: 'Solway',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Positioned(
          top: 10,
          right: 12.5,
          child: Container(
            height: 30,
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[900], Colors.blue[800]],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(10.0)),
            child: Text(
              "Save",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ],
    );
  }
}
