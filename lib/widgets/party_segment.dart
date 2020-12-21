import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/other_profile.dart';
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
import 'package:share/share.dart';

class PartySegment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PartySegmentState();
  }
}

class PartySegmentState extends State<PartySegment> {
  String text = 'https://www.whatsthemoov.com';
  String subject = 'Check out this MOOV!';
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
    // TODO: implement build
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
    final party = "Party";
    dynamic likeCount;
    childWidgets = [
      // ListView.builder(
      //     itemCount: 2, //DemoValues.posts.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return PostCard(postData: DemoValues.posts[index]);
      //     }),
      StreamBuilder(
          stream: Firestore.instance
              .collection('food')
              .where("type", isEqualTo: party)
              .where("featured", isEqualTo: true)
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
                    onDoubleTap: () {
                      setState(() {
                        List<dynamic> likedArray = course["liked"];
                        List<String> uidArray = List<String>();
                        if (likedArray != null) {
                          likeCount = likedArray.length;
                          for (int i = 0; i < likeCount; i++) {
                            var id = likedArray[i]["uid"];
                            uidArray.add(id);
                          }
                        }

                        if (uidArray != null && uidArray.contains(strUserId)) {
                          Database().removeGoing(
                              course["userId"],
                              course["image"],
                              strUserId,
                              course.documentID,
                              strUserName,
                              strUserPic,
                              course["startDate"],
                              course["title"],
                              course["description"],
                              course["location"],
                              course["address"],
                              course["profilePic"],
                              course["userName"],
                              course["userEmail"],
                              likedArray);
                        } else {
                          Database().addGoing(
                              course["userId"],
                              course["image"],
                              strUserId,
                              course.documentID,
                              strUserName,
                              strUserPic,
                              course["startDate"],
                              course["title"],
                              course["description"],
                              course["location"],
                              course["address"],
                              course["profilePic"],
                              course["userName"],
                              course["userEmail"],
                              likedArray);
                        }
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, right: 5, bottom: 5),
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(Icons.timer,
                                            color: TextThemes.ndGold, size: 20),
                                      ),
                                      Text('WHEN: ',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          DateFormat('MMMd').add_jm().format(
                                              course['startDate'].toDate()),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(Icons.place,
                                            color: TextThemes.ndGold, size: 20),
                                      ),
                                      Text('WHERE: ',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(course['location'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 4, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (course['userId'] == strUserId) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherProfile(
                                                      course['profilePic'],
                                                      course['userName'],
                                                      course['userId'],
                                                    )));
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          NetworkImage(course['profilePic']),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    if (course['userId'] == strUserId) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherProfile(
                                                    course['profilePic'],
                                                    course['userName'],
                                                    course['userId'],
                                                  )));
                                    }
                                  },
                                  child: Column(
                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(course['userName'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: TextThemes.ndBlue,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(course['userEmail'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: TextThemes.ndBlue,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 110.0, bottom: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Share.share(
                                          text,
                                          subject: 'Update the coordinate!',
                                        );
                                      },
                                      child: Icon(Icons.send_rounded,
                                          color: Colors.blue[500], size: 30),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 110, bottom: 20.0),
                                    child: Text(
                                      'Send',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: (_isPressed)
                                        ? new Icon(Icons.directions_run,
                                            color: Colors.green)
                                        : new Icon(Icons.directions_walk),
                                    color: Colors.red,
                                    iconSize: 30.0,
                                    splashColor: Colors.green,
                                    //splashRadius: 7.0,
                                    highlightColor: Colors.green,
                                    onPressed: () {
                                      setState(() {
                                        List<dynamic> likedArray =
                                            course["liked"];
                                        List<String> uidArray = List<String>();
                                        if (likedArray != null) {
                                          likeCount = likedArray.length;
                                          for (int i = 0; i < likeCount; i++) {
                                            var id = likedArray[i]["uid"];
                                            uidArray.add(id);
                                          }
                                        }

                                        if (uidArray != null &&
                                            uidArray.contains(strUserId)) {
                                          Database().removeGoing(
                                              course["userId"],
                                              course["image"],
                                              strUserId,
                                              course.documentID,
                                              strUserName,
                                              strUserPic,
                                              course["startDate"],
                                              course["title"],
                                              course["description"],
                                              course["location"],
                                              course["address"],
                                              course["profilePic"],
                                              course["userName"],
                                              course["userEmail"],
                                              likedArray);
                                        } else {
                                          Database().addGoing(
                                              course["userId"],
                                              course["image"],
                                              strUserId,
                                              course.documentID,
                                              strUserName,
                                              strUserPic,
                                              course["startDate"],
                                              course["title"],
                                              course["description"],
                                              course["location"],
                                              course["address"],
                                              course["profilePic"],
                                              course["userName"],
                                              course["userEmail"],
                                              likedArray);
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Text(
                                      'Going?',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
                      ],
                    ),
                  ),
                );
              },
            );
          }),
      StreamBuilder(
          //all
          stream: Firestore.instance
              .collection('food')
              .where("type", isEqualTo: "Party")
              .orderBy("startDate")
              .snapshots(),
          builder: (context, snapshot) {
            bool isLargePhone = Screen.diagonal(context) > 766;

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
                    onDoubleTap: () {
                      setState(() {
                        List<dynamic> likedArray = course["liked"];
                        List<String> uidArray = List<String>();
                        if (likedArray != null) {
                          likeCount = likedArray.length;
                          for (int i = 0; i < likeCount; i++) {
                            var id = likedArray[i]["uid"];
                            uidArray.add(id);
                          }
                        }

                        if (uidArray != null && uidArray.contains(strUserId)) {
                          Database().removeGoing(
                              course["userId"],
                              course["image"],
                              strUserId,
                              course.documentID,
                              strUserName,
                              strUserPic,
                              course["startDate"],
                              course["title"],
                              course["description"],
                              course["location"],
                              course["address"],
                              course["profilePic"],
                              course["userName"],
                              course["userEmail"],
                              likedArray);
                        } else {
                          Database().addGoing(
                              course["userId"],
                              course["image"],
                              strUserId,
                              course.documentID,
                              strUserName,
                              strUserPic,
                              course["startDate"],
                              course["title"],
                              course["description"],
                              course["location"],
                              course["address"],
                              course["profilePic"],
                              course["userName"],
                              course["userEmail"],
                              likedArray);
                        }
                      });
                    },
                    child: Column(
                      children: [
                        ListTile(
                          title: Row(children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, right: 5, bottom: 5),
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
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(Icons.timer,
                                            color: TextThemes.ndGold, size: 20),
                                      ),
                                      Text('WHEN: ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          DateFormat('MMMd').add_jm().format(
                                              course['startDate'].toDate()),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: isLargePhone ? 12 : 11,
                                          )),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        child: Icon(Icons.place,
                                            color: TextThemes.ndGold, size: 20),
                                      ),
                                      Text('WHERE: ',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold)),
                                      Text(course['address'],
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize:
                                                  isLargePhone ? 12 : 11)),
                                    ],
                                  ),
                                ],
                              ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 10, 4, 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (course['userId'] == strUserId) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilePage()));
                                      } else {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OtherProfile(
                                                      course['profilePic'],
                                                      course['userName'],
                                                      course['userId'],
                                                    )));
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                          NetworkImage(course['profilePic']),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    if (course['userId'] == strUserId) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProfilePage()));
                                    } else {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OtherProfile(
                                                    course['profilePic'],
                                                    course['userName'],
                                                    course['userId'],
                                                  )));
                                    }
                                  },
                                  child: Column(
                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(course['userName'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: TextThemes.ndBlue,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(course['userEmail'],
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: TextThemes.ndBlue,
                                                decoration:
                                                    TextDecoration.none)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                            course["userId"] == currentUser.id
                                ? RaisedButton(
                                    color: Colors.red,
                                    onPressed: () => showAlertDialog(context,
                                        course["postId"], course["userId"]),
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.white),
                                    ))
                                : Text(''),
                            Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, bottom: 10.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Share.share(
                                            text,
                                            subject: 'Update the coordinate!',
                                          );
                                        },
                                        child: Icon(Icons.send_rounded,
                                            color: Colors.blue[500], size: 30),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, bottom: 20.0),
                                      child: Text(
                                        'Send',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                      icon: (_isPressed)
                                          ? new Icon(Icons.directions_run,
                                              color: Colors.green)
                                          : new Icon(Icons.directions_walk),
                                      color: Colors.red,
                                      iconSize: 30.0,
                                      splashColor: Colors.green,
                                      //splashRadius: 7.0,
                                      highlightColor: Colors.green,
                                      onPressed: () {
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
                                                course["image"],
                                                strUserId,
                                                course.documentID,
                                                strUserName,
                                                strUserPic,
                                                course["startDate"],
                                                course["title"],
                                                course["description"],
                                                course["location"],
                                                course["address"],
                                                course["profilePic"],
                                                course["userName"],
                                                course["userEmail"],
                                                likedArray);
                                          } else {
                                            Database().addGoing(
                                                course["userId"],
                                                course["image"],
                                                strUserId,
                                                course.documentID,
                                                strUserName,
                                                strUserPic,
                                                course["startDate"],
                                                course["title"],
                                                course["description"],
                                                course["location"],
                                                course["address"],
                                                course["profilePic"],
                                                course["userName"],
                                                course["userEmail"],
                                                likedArray);
                                          }

                                          Database().addLikedMoovs(
                                              strUserId, course.documentID);
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10.0, bottom: 4.0),
                                    child: Text(
                                      'Going?',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 0, 30.0, 10),
                                    child: Text('$likeCount',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: TextThemes.ndBlue,
                                            decoration: TextDecoration.none)),
                                  ),
                                ],
                              ),
                            ])
                          ],
                        )),
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

  void showAlertDialog(BuildContext context, postId, userId) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Delete?", style: TextStyle(color: Colors.red)),
        content: Text("MOOVin' this to the trash can?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Database().deletePost(postId, userId);
            },
          ),
          CupertinoDialogAction(
            child: Text("Nah, nvm"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
}
