import 'package:MOOV/main.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/my_moovs_segment.dart';
import 'package:MOOV/widgets/send_moov.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/pages/notification_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'PostDepth.dart';

class MOOVSPage extends StatefulWidget {
  @override
  _MOOVSPageState createState() => _MOOVSPageState();
}

class _MOOVSPageState extends State<MOOVSPage>
    with SingleTickerProviderStateMixin {
  // TabController to control and switch tabs
  TabController _tabController;
  List<dynamic> likedArray;
  dynamic moovId;
  String type;

  // Current Index of tab
  int _currentIndex = 1;

  String text = 'https://www.whatsthemoov.com';
  String subject = 'Check out MOOV. You get paid to download!';
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;

  bool _isPressed;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
  final String currentUserId = currentUser?.id;
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    isLiked = false;
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset('lib/assets/ndlogo.png', height: 70),
        ),
        backgroundColor: TextThemes.ndBlue,
        //pinned: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.insert_chart),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              // Implement navigation to leaderboard page here...
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LeaderBoardPage()));
            },
          ),
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.notifications_active),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationFeed()));
            },
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 55.0,
              ),
            ],
          ),
        ),
      ),
// .where("liked", arrayContains: strUserId)
      body: Container(
          height: MediaQuery.of(context).size.height * 0.90,
          child: Column(children: <Widget>[
            new Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    new BoxShadow(
                      color: Colors.grey,
                      offset: new Offset(1.0, 1.0),
                    ),
                  ],
                ),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Sign In Button
                    new FlatButton(
                      color: _currentIndex == 0 ? Colors.blue : Colors.white,
                      onPressed: () {
                        _tabController.animateTo(0);
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: new Text("My Posts"),
                    ),
                    // Sign Up Button
                    new FlatButton(
                      color: _currentIndex == 1 ? Colors.blue : Colors.white,
                      onPressed: () {
                        _tabController.animateTo(1);
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: new Text("Going"),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(controller: _tabController,
                    // Restrict scroll by user
                    children: [
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('food')
                          .where("userId", isEqualTo: currentUser.id)
                          .orderBy("startDate")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: Text(
                                  "You have no posts. Go post the MOOV!",
                                  style: TextStyle(fontSize: 20)));
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();
                            DocumentSnapshot course =
                                snapshot.data.documents[index];
                            List<dynamic> likedArray = course["liked"];
                            List<String> uidArray = List<String>();
                            var strUserPic = currentUser.photoUrl;

                            bool isAmbassador;
                            var userYear;
                            var userDorm;
                            if (likedArray != null) {
                              likeCount = likedArray.length;
                              for (int i = 0; i < likeCount; i++) {
                                var id = likedArray[i]["uid"];
                                uidArray.add(id);
                              }
                            } else {
                              likeCount = 0;
                            }

                            if (uidArray != null &&
                                uidArray.contains(strUserId)) {
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
                                          course['userId'],
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
                                child: Column(
                                  children: [
                                    Card(
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    right: 5,
                                                    bottom: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    color: Color(0xff000000),
                                                    width: 1,
                                                  )),
                                                  child: Image.network(
                                                      course['image'],
                                                      fit: BoxFit.cover,
                                                      height: 130,
                                                      width: 50),
                                                ))),
                                        Expanded(
                                            child: Column(children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                  course['title'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center)),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              course['description'].toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0),
                                                    child: Icon(Icons.timer,
                                                        color:
                                                            TextThemes.ndGold,
                                                        size: 20),
                                                  ),
                                                  Text('WHEN: ',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      DateFormat('MMMd')
                                                          .add_jm()
                                                          .format(course[
                                                                  'startDate']
                                                              .toDate()),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0.0),
                                                    child: Icon(Icons.place,
                                                        color:
                                                            TextThemes.ndGold,
                                                        size: 20),
                                                  ),
                                                  Text(' WHERE: ',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(course['address'],
                                                      overflow:
                                                          TextOverflow.fade,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Container(
                                        height: 1.0,
                                        width: 500.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('users')
                                            .document(course['userId'])
                                            .snapshots(),
                                        builder: (context, snapshot2) {
                                          userDorm = snapshot2.data['dorm'];
                                          strUserPic =
                                              snapshot2.data['photoUrl'];
                                          isAmbassador =
                                              snapshot2.data['isAmbassador'];
                                          userYear = snapshot2.data['year'];
                                          bool isLargePhone =
                                              Screen.diagonal(context) > 766;

                                          if (!snapshot.hasData)
                                            return CircularProgressIndicator();

                                          return Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 10, 4, 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (course[
                                                                  'userId'] ==
                                                              strUserId) {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfilePage()));
                                                          } else {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
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
                                                              CachedNetworkImageProvider(
                                                                  strUserPic),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      )),
                                                  Container(
                                                    width: 120,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (course['userId'] ==
                                                            strUserId) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProfilePage()));
                                                        } else {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: Text(
                                                                course[
                                                                    'userName'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: TextThemes
                                                                        .ndBlue,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: Expanded(
                                                              child: Text(
                                                                  userYear +
                                                                      " in " +
                                                                      userDorm,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: TextThemes
                                                                          .ndBlue,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              course["userId"] == currentUser.id
                                                  ? RaisedButton(
                                                      color: Colors.red,
                                                      onPressed: () =>
                                                          showAlertDialog(
                                                              context,
                                                              course["postId"],
                                                              course["userId"]),
                                                      child: Text(
                                                        "DELETE",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                  : Text(''),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 5.0,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType
                                                                        .bottomToTop,
                                                                    child: SendMOOV(
                                                                        course[
                                                                            'postId'],
                                                                        course[
                                                                            'userId'],
                                                                        course[
                                                                            'photoUrl'],
                                                                        course[
                                                                            'postId'],
                                                                        course[
                                                                            'startDate'],
                                                                        course[
                                                                            'title'],
                                                                        course[
                                                                            'description'],
                                                                        course[
                                                                            'location'],
                                                                        course[
                                                                            'address'],
                                                                        course[
                                                                            'profilePic'],
                                                                        course[
                                                                            'userName'],
                                                                        course[
                                                                            'userEmail'],
                                                                        course[
                                                                            'liked'])));
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .send_rounded,
                                                              color: Colors
                                                                  .blue[500],
                                                              size: 30),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 15.0),
                                                        child: Text(
                                                          'Send',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 2.0,
                                                                left: 8),
                                                        child: IconButton(
                                                          icon: (_isPressed)
                                                              ? new Icon(
                                                                  Icons
                                                                      .directions_run,
                                                                  color: Colors
                                                                      .green)
                                                              : new Icon(Icons
                                                                  .directions_walk),
                                                          color: Colors.red,
                                                          iconSize: 30.0,
                                                          splashColor:
                                                              Colors.green,
                                                          //splashRadius: 7.0,
                                                          highlightColor:
                                                              Colors.green,
                                                          onPressed: () {
                                                            setState(() {
                                                              List<dynamic>
                                                                  likedArray =
                                                                  course[
                                                                      "liked"];
                                                              List<String>
                                                                  uidArray =
                                                                  List<
                                                                      String>();
                                                              if (likedArray !=
                                                                  null) {
                                                                likeCount =
                                                                    likedArray
                                                                        .length;
                                                                for (int i = 0;
                                                                    i < likeCount;
                                                                    i++) {
                                                                  var id =
                                                                      likedArray[
                                                                              i]
                                                                          [
                                                                          "uid"];
                                                                  uidArray
                                                                      .add(id);
                                                                }
                                                              }

                                                              if (uidArray !=
                                                                      null &&
                                                                  uidArray.contains(
                                                                      strUserId)) {
                                                                Database().removeGoing(
                                                                    course[
                                                                        "userId"],
                                                                    course[
                                                                        "image"],
                                                                    strUserId,
                                                                    course
                                                                        .documentID,
                                                                    strUserName,
                                                                    strUserPic,
                                                                    course[
                                                                        "startDate"],
                                                                    course[
                                                                        "title"],
                                                                    course[
                                                                        "description"],
                                                                    course[
                                                                        "location"],
                                                                    course[
                                                                        "address"],
                                                                    course[
                                                                        "profilePic"],
                                                                    course[
                                                                        "userName"],
                                                                    course[
                                                                        "userEmail"],
                                                                    likedArray);
                                                              } else {
                                                                Database().addGoing(
                                                                    course[
                                                                        "userId"],
                                                                    course[
                                                                        "image"],
                                                                    strUserId,
                                                                    course
                                                                        .documentID,
                                                                    strUserName,
                                                                    strUserPic,
                                                                    course[
                                                                        "startDate"],
                                                                    course[
                                                                        "title"],
                                                                    course[
                                                                        "description"],
                                                                    course[
                                                                        "location"],
                                                                    course[
                                                                        "address"],
                                                                    course[
                                                                        "profilePic"],
                                                                    course[
                                                                        "userName"],
                                                                    course[
                                                                        "userEmail"],
                                                                    likedArray);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 6.0,
                                                                bottom: 4.0),
                                                        child: Text(
                                                          'Going?',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 22.0, 10),
                                                        child: Text(
                                                            '$likeCount',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    TextThemes
                                                                        .ndBlue,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection('food')
                          .where("liked", arrayContains: {
                            "strName": currentUser.displayName,
                            "strPic": currentUser.photoUrl,
                            "uid": currentUser.id
                          })
                          .orderBy("startDate")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: Text(
                                "You're not going to any MOOVs! \nHella lame.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20)),
                          );
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot course =
                                snapshot.data.documents[index];
                            List<dynamic> likedArray = course["liked"];
                            List<String> uidArray = List<String>();
                            var strUserPic = currentUser.photoUrl;

                            bool isAmbassador;
                            var userYear;
                            var userDorm;
                            if (likedArray != null) {
                              likeCount = likedArray.length;
                              for (int i = 0; i < likeCount; i++) {
                                var id = likedArray[i]["uid"];
                                uidArray.add(id);
                              }
                            } else {
                              likeCount = 0;
                            }

                            if (uidArray != null &&
                                uidArray.contains(strUserId)) {
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
                                          course['userId'],
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
                                child: Column(
                                  children: [
                                    Card(
                                      shadowColor: Colors.white,
                                      color: Colors.white,
                                      child: Row(children: <Widget>[
                                        Expanded(
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 0.0,
                                                    right: 5,
                                                    bottom: 5),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    color: Color(0xff000000),
                                                    width: 1,
                                                  )),
                                                  child: Image.network(
                                                      course['image'],
                                                      fit: BoxFit.cover,
                                                      height: 130,
                                                      width: 50),
                                                ))),
                                        Expanded(
                                            child: Column(children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0)),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Text(
                                                  course['title'].toString(),
                                                  style: TextStyle(
                                                      color: Colors.blue[900],
                                                      fontSize: 20.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center)),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              course['description'].toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.black
                                                      .withOpacity(0.6)),
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4.0),
                                                    child: Icon(Icons.timer,
                                                        color:
                                                            TextThemes.ndGold,
                                                        size: 20),
                                                  ),
                                                  Text('WHEN: ',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(
                                                      DateFormat('MMMd')
                                                          .add_jm()
                                                          .format(course[
                                                                  'startDate']
                                                              .toDate()),
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      )),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 0.0),
                                                    child: Icon(Icons.place,
                                                        color:
                                                            TextThemes.ndGold,
                                                        size: 20),
                                                  ),
                                                  Text(' WHERE: ',
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(course['address'],
                                                      overflow:
                                                          TextOverflow.fade,
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.0),
                                      child: Container(
                                        height: 1.0,
                                        width: 500.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('users')
                                            .document(course['userId'])
                                            .snapshots(),
                                        builder: (context, snapshot2) {
                                          bool isLargePhone =
                                              Screen.diagonal(context) > 766;

                                          if (!snapshot.hasData)
                                            return CircularProgressIndicator();
                                          if (!snapshot2.hasData)
                                            return CircularProgressIndicator();
                                          print(snapshot2.data['dorm']);
                                          userDorm = snapshot2.data['dorm'];
                                          strUserPic =
                                              snapshot2.data['photoUrl'];
                                          isAmbassador =
                                              snapshot2.data['isAmbassador'];
                                          userYear = snapshot2.data['year'];

                                          return Container(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          12, 10, 4, 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          if (course[
                                                                  'userId'] ==
                                                              strUserId) {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            ProfilePage()));
                                                          } else {
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
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
                                                              CachedNetworkImageProvider(
                                                                  strUserPic),
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                      )),
                                                  Container(
                                                    width: 120,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (course['userId'] ==
                                                            strUserId) {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProfilePage()));
                                                        } else {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: Text(
                                                                course[
                                                                    'userName'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: TextThemes
                                                                        .ndBlue,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .none)),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 2.0),
                                                            child: Expanded(
                                                              child: Text(
                                                                  userYear +
                                                                      " in " +
                                                                      userDorm,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          11,
                                                                      color: TextThemes
                                                                          .ndBlue,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .none)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              course["userId"] == currentUser.id
                                                  ? RaisedButton(
                                                      color: Colors.red,
                                                      onPressed: () =>
                                                          showAlertDialog(
                                                              context,
                                                              course["postId"],
                                                              course["userId"]),
                                                      child: Text(
                                                        "DELETE",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ))
                                                  : Text(''),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom: 5.0,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                PageTransition(
                                                                    type: PageTransitionType
                                                                        .bottomToTop,
                                                                    child: SendMOOV(
                                                                        course[
                                                                            'postId'],
                                                                        course[
                                                                            'userId'],
                                                                        course[
                                                                            'photoUrl'],
                                                                        course[
                                                                            'postId'],
                                                                        course[
                                                                            'startDate'],
                                                                        course[
                                                                            'title'],
                                                                        course[
                                                                            'description'],
                                                                        course[
                                                                            'location'],
                                                                        course[
                                                                            'address'],
                                                                        course[
                                                                            'profilePic'],
                                                                        course[
                                                                            'userName'],
                                                                        course[
                                                                            'userEmail'],
                                                                        course[
                                                                            'liked'])));
                                                          },
                                                          child: Icon(
                                                              Icons
                                                                  .send_rounded,
                                                              color: Colors
                                                                  .blue[500],
                                                              size: 30),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 15.0),
                                                        child: Text(
                                                          'Send',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 2.0,
                                                                left: 8),
                                                        child: IconButton(
                                                          icon: (_isPressed)
                                                              ? new Icon(
                                                                  Icons
                                                                      .directions_run,
                                                                  color: Colors
                                                                      .green)
                                                              : new Icon(Icons
                                                                  .directions_walk),
                                                          color: Colors.red,
                                                          iconSize: 30.0,
                                                          splashColor:
                                                              Colors.green,
                                                          //splashRadius: 7.0,
                                                          highlightColor:
                                                              Colors.green,
                                                          onPressed: () {
                                                            setState(() {
                                                              List<dynamic>
                                                                  likedArray =
                                                                  course[
                                                                      "liked"];
                                                              List<String>
                                                                  uidArray =
                                                                  List<
                                                                      String>();
                                                              if (likedArray !=
                                                                  null) {
                                                                likeCount =
                                                                    likedArray
                                                                        .length;
                                                                for (int i = 0;
                                                                    i < likeCount;
                                                                    i++) {
                                                                  var id =
                                                                      likedArray[
                                                                              i]
                                                                          [
                                                                          "uid"];
                                                                  uidArray
                                                                      .add(id);
                                                                }
                                                              }

                                                              if (uidArray !=
                                                                      null &&
                                                                  uidArray.contains(
                                                                      strUserId)) {
                                                                Database().removeGoing(
                                                                    course[
                                                                        "userId"],
                                                                    course[
                                                                        "image"],
                                                                    strUserId,
                                                                    course
                                                                        .documentID,
                                                                    strUserName,
                                                                    strUserPic,
                                                                    course[
                                                                        "startDate"],
                                                                    course[
                                                                        "title"],
                                                                    course[
                                                                        "description"],
                                                                    course[
                                                                        "location"],
                                                                    course[
                                                                        "address"],
                                                                    course[
                                                                        "profilePic"],
                                                                    course[
                                                                        "userName"],
                                                                    course[
                                                                        "userEmail"],
                                                                    likedArray);
                                                              } else {
                                                                Database().addGoing(
                                                                    course[
                                                                        "userId"],
                                                                    course[
                                                                        "image"],
                                                                    strUserId,
                                                                    course
                                                                        .documentID,
                                                                    strUserName,
                                                                    strUserPic,
                                                                    course[
                                                                        "startDate"],
                                                                    course[
                                                                        "title"],
                                                                    course[
                                                                        "description"],
                                                                    course[
                                                                        "location"],
                                                                    course[
                                                                        "address"],
                                                                    course[
                                                                        "profilePic"],
                                                                    course[
                                                                        "userName"],
                                                                    course[
                                                                        "userEmail"],
                                                                    likedArray);
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 6.0,
                                                                bottom: 4.0),
                                                        child: Text(
                                                          'Going?',
                                                          style: TextStyle(
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 22.0, 10),
                                                        child: Text(
                                                            '$likeCount',
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    TextThemes
                                                                        .ndBlue,
                                                                decoration:
                                                                    TextDecoration
                                                                        .none)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ));
                                        }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                ]))
          ])),
    );

    // FloatingActionButton.extended(
    //     onPressed: () {
    //       // Add your onPressed code here!
    //     },
    //     label: Text('Find a MOOV',
    //         style: TextStyle(color: Colors.white)),
    //     icon: Icon(Icons.search, color: Colors.white),
    //     backgroundColor: Color.fromRGBO(220, 180, 57, 1.0))
  }

  void showAlertDialog(BuildContext context, postId, userId) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Delete?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nMOOV to trash can?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yeah", style: TextStyle(color: Colors.red)),
            onPressed: () {
              Database().deletePost(postId, userId);
            },
          ),
          CupertinoDialogAction(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }

  handleLikePost() {
    if (isLiked == true) {
      isLiked = false;
    } else {
      isLiked = true;
    }
  }
}
