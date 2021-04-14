import 'dart:async';
import 'dart:math';
import 'package:MOOV/pages/archiveDetail.dart';
import 'package:MOOV/pages/dealDetail.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
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
    Colors.pink[50],
    Colors.blue[50]
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
                  "What a week, $firstName! Here's your recap, be sure to save any Memorable MOOVs before they expire tonight.",
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
                      List goingMOOVs = [];
                      List ownMOOVs = [];
                      List newFriends = [];

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
                                      width: MediaQuery.of(context).size.width * .75,
                                      height: 150,
                                      padding: EdgeInsets.all(2.0),
                                      child: Material(
                                        elevation: 4.0,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                        color: colorList[
                                            _random.nextInt(colorList.length)],
                                        child: ListView.builder(
                                          // physics: AlwaysScrollableScrollPhysics(),
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
                                                      right: 0.0, left: 10)
                                                  : EdgeInsets.only(
                                                      right: 10.0, left: 0),
                                              child: Container(
                                                height: 100,
                                                child:
                                                    WrapMOOV(index, ownMOOVs),
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
                                                child:
                                                    WrapMOOV(index, goingMOOVs),
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
                                              .4,
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
                          FutureBuilder(
                              future: wrapupRef.doc('nextDeals').get(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  return Container();
                                }
                                List nextDeals = [];

                                if (snapshot.data.data()['nextDeals'] != null) {
                                  nextDeals = snapshot.data.data()['nextDeals'];
                                  length = length + 1;
                                }
                                return Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 10),
                                          child: Text(
                                            "Next Week's Deals.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        Text(
                                          "Another week of absurd deals.",
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
                                          // physics: AlwaysScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemExtent: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .385,
                                          itemCount: nextDeals.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: index == 0
                                                  ? EdgeInsets.only(
                                                      right: 10.0,
                                                      left: 10,
                                                      top: 10,
                                                      bottom: 10)
                                                  : EdgeInsets.only(
                                                      right: 10.0,
                                                      left: 0,
                                                      top: 10,
                                                      bottom: 10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      border: index ==
                                                              nextDeals.length -
                                                                  1
                                                          ? null
                                                          : Border(
                                                              right: BorderSide(
                                                                  width: 2.0,
                                                                  color: Colors
                                                                      .black),
                                                            )),
                                                  height: 100,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 8.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          nextDeals[index]['day'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        WrapMOOV(index, nextDeals)
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
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
  final int index;
  final List moovType;
  const WrapMOOV(this.index, this.moovType);

  @override
  Widget build(BuildContext context) {
    Timer _timer;

    bool isDeal = false;
    if (moovType[0]['day'] != null) {
      isDeal = true;
    }

    return Stack(
      children: [
        Container(
          height: isDeal ? 95 : 200,
          width: 200,
          child: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: OpenContainer(
                transitionType: ContainerTransitionType.fade,
                transitionDuration: Duration(milliseconds: 500),
                openBuilder: (context, _) => isDeal
                    ? DealDetail(
                        moovType[index]['title'],
                        moovType[index]['pic'],
                        moovType[index]['description'],
                        moovType[index]['day'])
                    : ArchiveDetail(moovType[index]['postId']),
                closedElevation: 0,
                closedBuilder: (context, _) => FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(moovType[index]['pic'],
                          fit: BoxFit.cover),
                    ),
                    // margin: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment(0.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        moovType[index]['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Solway',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: isDeal ? 13 : 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
        isDeal
            ? Container()
            : Positioned(
                top: 10,
                right: 17.5,
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
                  child: FocusedMenuHolder(
                    menuWidth: MediaQuery.of(context).size.width * 0.62,
                    blurSize: 5.0,
                    menuItemExtent: 45,
                    menuBoxDecoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    duration: Duration(milliseconds: 20),
                    animateMenuItems: true,
                    blurBackgroundColor: Colors.black54,
                    openWithTap:
                        true, // Open Focused-Menu on Tap rather than Long Press
                    menuOffset:
                        10.0, // Offset value to show menuItem from the selected item
                    bottomOffsetHeight:
                        80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                    menuItems: <FocusedMenuItem>[
                      // Add Each FocusedMenuItem  for Menu Options

                      FocusedMenuItem(
                          title: Text(
                            "Save to MOOV Memories?",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          ),
                          trailingIcon: Icon(Icons.save_sharp,
                              size: 20, color: Colors.blue),
                          onPressed: () {
                            archiveRef
                                .doc(moovType[index]['postId'])
                                .set({
                                  "memories":
                                      FieldValue.arrayUnion([currentUser.id])
                                }, SetOptions(merge: true))
                                .then((value) => showDialog(
                                    context: context,
                                    builder: (BuildContext builderContext) {
                                      _timer = Timer(Duration(seconds: 1), () {
                                        Navigator.of(context).pop();
                                      });

                                      return AlertDialog(
                                        backgroundColor: Colors.green,
                                        title: Center(
                                          child: Text(
                                            'Saved',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        content: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      );
                                    }))
                                .then((val) {
                                  if (_timer.isActive) {
                                    _timer.cancel();
                                  }
                                });
                          }),
                      FocusedMenuItem(
                          title: Text(
                            "Nvm",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          trailingIcon: Icon(Icons.cancel, size: 20),
                          onPressed: () {}),
                    ],

                    onPressed: () {},
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              )
      ],
    );
  }
}

//this function gets the next sunday for items to be saved for the wrapup
Future<String> nextSunday() async {
  int sunday = 7;
  DateTime now = new DateTime.now();
  if (now.weekday == 7) {
    now = now.add(new Duration(days: 7));
  }
  while (now.weekday != sunday) {
    now = now.add(new Duration(days: 1));
  }
  final aDate = DateTime(now.year, now.month, now.day);

  String nextSunday = DateFormat('MMMd').format(aDate);

  return nextSunday;
}