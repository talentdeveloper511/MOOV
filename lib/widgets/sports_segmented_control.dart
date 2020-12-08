import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';

import 'package:MOOV/helpers/themes.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/home.dart';

class SportsSegment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SportsSegmentState();
  }
}

class SportsSegmentState extends State<SportsSegment> {
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadCupertinoTabs(); //Method to add Tabs to the Segmented Control.
    loadChildWidgets(); //Method to add the Children as user selected.
  }

  bool _isPressed; // = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl(
          onValueChanged: (value) {
//Callback function executed when user changes the Tabs
            setState(() {
              selectedIndex = value;
            });
          },
          groupValue: selectedIndex, //The current selected Index or key
          selectedColor: Color.fromRGBO(
              2, 43, 91, 1.0), //Color that applies to selecte key or index
          pressedColor: Color.fromRGBO(220, 180, 57,
              1.0), //The color that applies when the user clicks or taps on a tab
          unselectedColor: Colors
              .grey, // The color that applies to the unselected tabs or inactive tabs
          children: map, //The tabs which are assigned in the form of map
          padding: EdgeInsets.all(10),
          borderColor: Color.fromRGBO(2, 43, 91, 1.0),
        ),
        Expanded(
          child: getChildWidget(),
        ),
      ],
    );
  }

  void loadCupertinoTabs() {
    map = new Map();
    map = {
      0: Container(
          width: 100,
          child: Center(
            child: Text(
              "Featured",
              style: TextStyle(color: Colors.white),
            ),
          )),
      1: Container(
          width: 100,
          child: Center(
            child: Text(
              "All",
              style: TextStyle(color: Colors.white),
            ),
          )),
      2: Container(
          width: 100,
          child: Center(
            child: Text(
              "Friends",
              style: TextStyle(color: Colors.white),
            ),
          ))
    };
  }

  void loadChildWidgets() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;
    childWidgets = [
      ListView.builder(
          itemCount: 2, //DemoValues.posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(postData: DemoValues.posts[index]);
          }),
      StreamBuilder(
          stream: Firestore.instance
              .collection('food')
              .where("type", isEqualTo: "Sport")
              .orderBy("startDate")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text('Loading data...');
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot course = snapshot.data.documents[index];
                List<dynamic> likedArray = course["liked"];
                List<String> uidArray = List<String>();
                if (likedArray != null) {
                  likeCount = likedArray.length;
                  for (int i = 0; i < likeCount; i++) {
                    var id = likedArray[i]["uid"];
                    uidArray.add(id);
                  }
                } else {
                  likeCount = 0;
                }

                if (uidArray != null && uidArray.contains(strUserId)) {
                  _isPressed = true;
                } else {
                  _isPressed = false;
                }

                return Card(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PostDetail(
                              course['image'],
                              course['title'],
                              course['description'],
                              course['startDate'],
                              course['location'],
                              course['address'],
                              course['profilePic'],
                              course['userName'],
                              course['userEmail'],
                              likedArray,
                              course.documentID)));
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Color(0xff000000),
                                        width: 1,
                                      )),
                                      /*child: Image.asset(
                                          'lib/assets/filmbutton1.png',
                                          fit: BoxFit.cover,
                                          height: 130,
                                          width: 50),*/
                                      child: Image.network(course['image'],
                                          fit: BoxFit.cover,
                                          height: 130,
                                          width: 50),
                                    ))),
                            Expanded(
                                child: Column(children: <Widget>[
                              Padding(padding: const EdgeInsets.all(8.0)),
                              Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(course['title'].toString(),
                                      style: TextStyle(
                                          color: Colors.blue[900],
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center)),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  course['description'].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(padding: const EdgeInsets.all(5.0)),
                              Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        DateFormat('EEEE, MMM d, yyyy').format(
                                            course['startDate'].toDate()),
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold)),
                                  )),
                            ]))
                          ]),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1.0),
                          child: Container(
                            height: 1.0,
                            width: 500.0,
                            color: Colors.grey[300],
                          ),
                        ),
                        Container(
                            child: Row(
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 10, 4, 10),
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                      NetworkImage(course['profilePic']),
                                  backgroundColor: Colors.transparent,
                                )),
                            Container(
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(course['userName'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(course['userEmail'],
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Container(
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: IconButton(
                                      icon: (_isPressed)
                                          ? new Icon(Icons.favorite)
                                          : new Icon(Icons.favorite_border),
                                      color: Colors.pink,
                                      iconSize: 24.0,
                                      splashColor: Colors.pink,
                                      //splashRadius: 7.0,
                                      highlightColor: Colors.pink,
                                      onPressed: () {
                                        // Perform action
                                        setState(() {
                                          List<dynamic> likedArray =
                                              course["liked"];
                                          List<String> uidArray =
                                              List<String>();
                                          if (likedArray != null) {
                                            likeCount = likedArray.length;
                                            for (int i = 0;
                                                i < likeCount;
                                                i++) {
                                              var id = likedArray[i]["uid"];
                                              uidArray.add(id);
                                            }
                                          }

                                          if (uidArray != null &&
                                              uidArray.contains(strUserId)) {
                                            Database().removeGoing(
                                              course["userId"],
                                              strUserId,
                                              course.documentID,
                                              strUserName,
                                              strUserPic,
                                            );
                                          } else {
                                            Database().addGoing(
                                              course["userId"],
                                              strUserId,
                                              course.documentID,
                                              strUserName,
                                              strUserPic,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 24.0, 10),
                                    child: Text('$likeCount',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                        /*ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            textColor: const Color(0xFF6200EE),
                            onPressed: () {
                              // Perform some action
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Text("WHO'S GOING?",
                                    style: TextStyle(
                                        color: Colors.blue[500],
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left)),
                          ),
                          FlatButton(
                            textColor: const Color(0xFF6200EE),
                            onPressed: () {
                              // Perform some action
                            },
                            child: IconButton(
                              icon: (_isPressed)
                                  ? new Icon(Icons.favorite)
                                  : new Icon(Icons.favorite_border),
                              color: Colors.pink,
                              iconSize: 24.0,
                              splashColor: Colors.pink,
                              splashRadius: 7.0,
                              highlightColor: Colors.pink,
                              onPressed: () {
                                // Perform action
                                setState(() {
                                  List<dynamic> likedArray = course["liked"];
                                  if (likedArray != null && likedArray.contains(strUserId)) {
                                    Database().removeGoing(strUserId, course.documentID);
                                  } else {
                                    Database().addLike(strUserId, course.documentID);
                                  }
                                  */ /*if (_isPressed) {
                                    Database().removeGoing(strUserId, course.documentID);
                                  } else {
                                    Database().addLike(strUserId, course.documentID);
                                  }*/ /*
                                });
                              },
                            ),
                          )
                        ],
                      ),*/
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Aw, you have no friends! Add some now.",
              ),
            ),
            FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: Text('Add Friends'),
                icon: Icon(Icons.person_add),
                backgroundColor: Color.fromRGBO(220, 180, 57, 1.0)),
          ],
        ),
      )
    ];
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
}
