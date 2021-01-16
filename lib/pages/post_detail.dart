import 'dart:ui';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/send_moov.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:MOOV/pages/Going_event.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';

class PostDetail extends StatefulWidget {
  String postId;
  PostDetail(this.postId);

  @override
  State<StatefulWidget> createState() {
    return _PostDetailState(this.postId);
  }
}

class _PostDetailState extends State<PostDetail> {
  String postId;
  _PostDetailState(this.postId);

  int segmentedControlValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
          backgroundColor: TextThemes.ndBlue,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Image.asset(
                    'lib/assets/moovblue.png',
                    fit: BoxFit.cover,
                    height: 50.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: Stack(children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('food')
                    .doc(postId)
                    .snapshots(),
                builder: (context, snapshot) {
                  String title,
                      description,
                      bannerImage,
                      address,
                      userId,
                      postId;
                  dynamic startDate;
                  List<dynamic> likedArray;

                  if (!snapshot.hasData) return CircularProgressIndicator();
                  title = snapshot.data()()['title'];
                  bannerImage = snapshot.data()['image'];
                  description = snapshot.data()['description'];
                  startDate = snapshot.data()['startDate'];
                  address = snapshot.data()['address'];
                  userId = snapshot.data()['userId'];
                  likedArray = snapshot.data()['likedArray'];
                  postId = snapshot.data()['postId'];
                  return Container(
                    color: Colors.white,
                    child: ListView(
                      children: <Widget>[
                        _BannerImage(bannerImage),
                        _NonImageContents(title, description, startDate,
                            address, userId, likedArray, postId),
                      ],
                    ),
                  );
                }),
          ]),
        ));
  }
}

class _BannerImage extends StatelessWidget {
  String bannerImage;
  _BannerImage(this.bannerImage);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        child: Container(
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: CachedNetworkImage(
            imageUrl: bannerImage,
            fit: BoxFit.fitWidth,
            height: 200,
            width: double.infinity,
          ),
        ),
      ),
    ]);
  }
}

class _NonImageContents extends StatelessWidget {
  String title, description, userId;
  dynamic startDate, address, moovId;
  List<dynamic> likedArray;

  _NonImageContents(this.title, this.description, this.startDate, this.address,
      this.userId, this.likedArray, this.moovId);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Title(title),
          _Description(description),
          PostTimeAndPlace(startDate, address),
          _AuthorContent(userId),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Container(
              height: 1.0,
              width: 500.0,
              color: Colors.grey[700],
            ),
          ),
          Buttons(likedArray, moovId),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              height: 1.0,
              width: 500.0,
              color: Colors.grey[700],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(Icons.directions_run, color: Colors.green),
                ),
                Text(
                  'Going List',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Seg2(likedArray: likedArray, moovId: moovId),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  String title;
  _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextThemes.headline1,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  String description;
  _Description(this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 15.0, left: 10, right: 10),
      child: Center(
        child: Text(description,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }
}

class PostTimeAndPlace extends StatelessWidget {
  dynamic startDate, address;

  PostTimeAndPlace(this.startDate, this.address);

  @override
  Widget build(BuildContext context) {
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: Icon(Icons.timer, color: TextThemes.ndGold),
              ),
              Text('WHEN: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                DateFormat('MMMd').add_jm().format(startDate.toDate()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: Icon(
                    Icons.place,
                    color: TextThemes.ndGold,
                  ),
                ),
                Text('WHERE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(address)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _AuthorContent extends StatelessWidget {
  String userId;
  var course;
  var snapshot;
  var data;
  _AuthorContent(this.userId);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return FutureBuilder<DocumentSnapshot>(
      future: usersRef.doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> course = snapshot.data.data();

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => course['id'] != currentUser.id
                      ? OtherProfile(course['photoUrl'], course['displayName'],
                          course['id'])
                      : ProfilePage())),
              child: Container(
                  child: Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
                      child: CircleAvatar(
                        radius: 22.0,
                        backgroundImage:
                            CachedNetworkImageProvider(course['photoUrl']),
                        backgroundColor: Colors.transparent,
                      )),
                  Container(
                    child: Column(
                      //  mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(course['displayName'],
                              style: TextStyle(
                                  fontSize: 14,
                                  color: TextThemes.ndBlue,
                                  decoration: TextDecoration.none)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(course['email'],
                              style: TextStyle(
                                  fontSize: 12,
                                  color: TextThemes.ndBlue,
                                  decoration: TextDecoration.none)),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: isLargePhone
                        ? const EdgeInsets.only(right: 42.0, top: 10.0)
                        : const EdgeInsets.only(right: 30.0, top: 10.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.bottomToTop,
                                child: SendMOOV(
                                    course['postId'],
                                    course['userId'],
                                    course['image'],
                                    course['postId'],
                                    course['startDate'],
                                    course['title'],
                                    course['description'],
                                    course['address'],
                                    course['profilePic'],
                                    course['userName'],
                                    course['userEmail'],
                                    course['liked'])));
                      },
                      color: Colors.white,
                      padding: EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Column(
                          children: [
                            Text('Send'),
                            Icon(Icons.send_rounded,
                                color: Colors.blue[500], size: 25),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}

class Seg2 extends StatefulWidget {
  List<dynamic> likedArray;
  dynamic moovId;
  Seg2({Key key, @required this.likedArray, @required this.moovId})
      : super(key: key);

  @override
  _Seg2State createState() => _Seg2State(likedArray, moovId);
}

class _Seg2State extends State<Seg2> with SingleTickerProviderStateMixin {
  // TabController to control and switch tabs
  TabController _tabController;
  List<dynamic> likedArray;
  dynamic moovId;

  _Seg2State(this.likedArray, this.moovId);

  // Current Index of tab
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: 2, initialIndex: _currentIndex);
    _tabController.animation
      ..addListener(() {
        setState(() {
          _currentIndex = (_tabController.animation.value)
              .round(); //_tabController.animation.value returns double
        });
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: <Widget>[
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
                    child: new Text("All"),
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
                    child: new Text("Friends"),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController,
                // Restrict scroll by user
                children: [
                  // Sign In View
                  Center(
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return GoingPage(likedArray, moovId);
                        }),
                  ),
                  // Sign Up View
                  Center(
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return GoingPageFriends(likedArray, moovId);
                        }),
                  )
                ]),
          )
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId, likeCount;
  String text = 'https://www.whatsthemoov.com';

  Buttons(this.likedArray, this.moovId);

  bool _isPressed;
  int status;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('food')
            .doc(moovId)
            .snapshots(),
        builder: (context, snapshot) {
          // title = snapshot.data['title'];
          // pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          DocumentSnapshot course = snapshot.data();
          List<dynamic> likedArray = course["liked"];
          Map<String, dynamic> invitees = course['invitees'];

          List<dynamic> inviteesIds = invitees.keys.toList();

          List<dynamic> inviteesValues = invitees.values.toList();

          if (invitees != null) {
            for (int i = 0; i < invitees.length; i++) {
              if (inviteesIds[i] == currentUser.id) {
                if (inviteesValues[i] == 1) {
                  status = 1;
                }
              }
            }
            if (invitees != null) {
              for (int i = 0; i < invitees.length; i++) {
                if (inviteesIds[i] == currentUser.id) {
                  if (inviteesValues[i] == 2) {
                    status = 2;
                  }
                }
              }
            }
            if (invitees != null) {
              for (int i = 0; i < invitees.length; i++) {
                if (inviteesIds[i] == currentUser.id) {
                  if (inviteesValues[i] == 3) {
                    status = 3;
                  }
                }
              }
            }

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

            if (uidArray != null && uidArray.contains(currentUser.id)) {
              _isPressed = true;
            } else {
              _isPressed = false;
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () {
                      if (invitees != null && status != 1) {
                        Database().addNotGoing(currentUser.id, moovId);
                        status = 1;
                        print(status);
                      } else if (invitees != null && status == 1) {
                        Database().removeNotGoing(currentUser.id, moovId);
                        status = 0;
                      }
                    },
                    //   if (likedArray != null) {
                    //     likeCount = likedArray.length;
                    //     for (int i = 0; i < likeCount; i++) {
                    //       var id = likedArray[i]["uid"];
                    //       uidArray.add(id);
                    //     }
                    //   }

                    //   if (uidArray != null && uidArray.contains(currentUser.id)) {
                    //     Database().removeGoing(
                    //         course["userId"],
                    //         course["image"],
                    //         currentUser.id,
                    //         course.documentID,
                    //         currentUser.displayName,
                    //         currentUser.photoUrl,
                    //         course["startDate"],
                    //         course["title"],
                    //         course["description"],
                    //         course["address"],
                    //         course["profilePic"],
                    //         course["userName"],
                    //         course["userEmail"],
                    //         likedArray);
                    //   } else {
                    //     Database().addGoing(
                    //         course["userId"],
                    //         course["image"],
                    //         currentUser.id,
                    //         course.documentID,
                    //         currentUser.displayName,
                    //         currentUser.photoUrl,
                    //         course["startDate"],
                    //         course["title"],
                    //         course["description"],
                    //         course["address"],
                    //         course["profilePic"],
                    //         course["userName"],
                    //         course["userEmail"],
                    //         likedArray);
                    //   }
                    // },
                    color: (status == 1) ? Colors.red : Colors.white,
                    padding: EdgeInsets.all(5.0),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: (status == 1)
                          ? Column(
                              children: [
                                Text(
                                  'Not going',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 3.0, top: 3.0),
                                  child: Icon(Icons.directions_run,
                                      color: Colors.white),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Text('Not going'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 3.0, top: 3.0),
                                  child: Icon(Icons.directions_walk,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        if (invitees != null && status != 2) {
                          Database().addUndecided(currentUser.id, moovId);
                          status = 2;
                          print(status);
                        } else if (invitees != null && status == 2) {
                          Database().removeUndecided(currentUser.id, moovId);
                          status = 0;
                        }
                      },
                      color: (status == 2) ? Colors.yellow[600] : Colors.white,
                      padding: EdgeInsets.all(5.0),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 3.0, right: 3),
                        child: (status == 2)
                            ? Column(
                                children: [
                                  Text('Undecided',
                                      style: TextStyle(color: Colors.white)),
                                  Icon(Icons.accessibility,
                                      color: Colors.white, size: 30),
                                ],
                              )
                            : Column(
                                children: [
                                  Text('Undecided'),
                                  Icon(Icons.accessibility,
                                      color: Colors.yellow[600], size: 30),
                                ],
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(color: Colors.black)),
                      onPressed: () {
                        if (invitees != null && status != 3) {
                          Database().addGoingGood(
                              currentUser.id,
                              course['userId'],
                              moovId,
                              course['title'],
                              course['image']);
                          status = 3;
                          print(status);
                        } else if (invitees != null && status == 3) {
                          Database().removeGoingGood(
                              currentUser.id,
                              course['userId'],
                              moovId,
                              course['title'],
                              course['image']);
                          status = 0;
                        }
                      },
                      color: (status == 3) ? Colors.green : Colors.white,
                      padding: EdgeInsets.all(5.0),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: (status == 3)
                              ? Column(
                                  children: [
                                    Text('Going!',
                                        style: TextStyle(color: Colors.white)),
                                    Icon(Icons.directions_run_outlined,
                                        color: Colors.white, size: 30),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text('Going'),
                                    Icon(Icons.directions_run_outlined,
                                        color: Colors.green[500], size: 30),
                                  ],
                                )),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
//SEND MOOV BUTTON
//  Padding(
//                   padding: const EdgeInsets.only(left: 0.0, bottom: 0.0),
//                   child: RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                         side: BorderSide(color: Colors.black)),
//                     onPressed: () {
//                       Navigator.push(
//                           context,
//                           PageTransition(
//                               type: PageTransitionType.bottomToTop,
//                               child: SendMOOV(
//                                   course['postId'],
//                                   course['userId'],
//                                   course['image'],
//                                   course['postId'],
//                                   course['startDate'],
//                                   course['title'],
//                                   course['description'],
//                                   course['address'],
//                                   course['profilePic'],
//                                   course['userName'],
//                                   course['userEmail'],
//                                   course['liked'])));
//                     },
//                     color: Colors.white,
//                     padding: EdgeInsets.all(5.0),
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 4.0),
//                       child: Column(
//                         children: [
//                           Text('Send'),
//                           Icon(Icons.send_rounded,
//                               color: Colors.blue[500], size: 30),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
