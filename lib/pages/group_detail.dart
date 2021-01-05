import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/helpers/utils.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/widgets/NextMOOV.dart';
import 'package:MOOV/widgets/set_moov.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MOOV/services/database.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import '../widgets/add_users.dart';
import 'edit_group.dart';
import 'home.dart';

class GroupDetail extends StatefulWidget {
  String photoUrl, displayName, gid, next;
  List<dynamic> members;

  GroupDetail(
      this.photoUrl, this.displayName, this.members, this.gid, this.next);

  @override
  State<StatefulWidget> createState() {
    return _GroupDetailState(
        this.photoUrl, this.displayName, this.members, this.gid, this.next);
  }
}

class _GroupDetailState extends State<GroupDetail> {
  String photoUrl, displayName, gid, next;
  List<dynamic> members;
  bool member;
  final dbRef = Firestore.instance;
  _GroupDetailState(
      this.photoUrl, this.displayName, this.members, this.gid, this.next);

  sendChat() {
    Database().sendChat(currentUser.displayName, chatController.text, gid);
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Leave the group?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nTime to MOOV on?"),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text("Yes get me out", style: TextStyle(color: Colors.red)),
            onPressed: () {
              leaveGroup();
              Navigator.of(context).pop(true);
            },
          ),
          CupertinoDialogAction(
            child: Text("Nah, my mistake"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }

  leaveGroup() {
    if (members.length == 1) {
      Database().leaveGroup(currentUser.id, displayName, gid);
      Database().destroyGroup(gid);
    } else {
      Database().leaveGroup(currentUser.id, displayName, gid);
    }
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  bool requestsent = false;
  TextEditingController chatController = TextEditingController();
  bool sendRequest = false;
  bool friends;

  var status;
  var userRequests;
  final GoogleSignInAccount userMe = googleSignIn.currentUser;
  final strUserId = currentUser.id;
  final strPic = currentUser.photoUrl;
  final strUserName = currentUser.displayName;
  var profilePic;
  var otherDisplay;
  var id;
  var iter = 1;

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('friendGroups', arrayContains: displayName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

          return Scaffold(
            backgroundColor: Colors.white,
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
                  titlePadding: EdgeInsets.all(15),
                  title: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 210),
                    child: Text(
                      displayName,
                      style: TextStyle(
                          fontSize: isLargePhone ? 30.0 : 22,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                actions: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(4.0),
                  //   child: FlatButton(
                  //       onPressed: () {
                  //         Database()
                  //             .leaveGroup(currentUser.id, displayName, gid);

                  //         Navigator.pop(
                  //           context,
                  //           MaterialPageRoute(builder: (context) => HomePage()),
                  //         );
                  //       },
                  //       child: Text(
                  //         "LEAVE",
                  //         style: TextStyle(color: Colors.red),
                  //       )),
                  // ),
                  IconButton(
                    padding: EdgeInsets.all(5.0),
                    icon: Icon(Icons.person_add),
                    color: Colors.white,
                    splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: AddUsers(
                                  displayName, gid, photoUrl, members, next)));
                    },
                  ),
                  FocusedMenuHolder(
                    menuWidth: MediaQuery.of(context).size.width * 0.50,
                    blurSize: 5.0,
                    menuItemExtent: 45,
                    menuBoxDecoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    duration: Duration(milliseconds: 100),
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
                          title: Text("Share"),
                          trailingIcon: Icon(Icons.send),
                          onPressed: () {
                            Share.share(
                                "Hey let's put our friend group on MOOV.");
                          }),
                      FocusedMenuItem(
                          title: Text("Edit Group"),
                          trailingIcon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditGroup(
                                        photoUrl, displayName, members, gid)));
                          }),
                      FocusedMenuItem(
                          title: Text(
                            "Leave Group",
                            style: TextStyle(color: Colors.redAccent),
                          ),
                          trailingIcon: Icon(
                            Icons.directions_walk,
                            color: Colors.redAccent,
                          ),
                          onPressed: () {
                            showAlertDialog(context);
                          }),
                    ],
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ]),
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot course =
                                snapshot.data.documents[index];

                            return Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (course['id'] == strUserId) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfilePage()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OtherProfile(
                                                        course['photoUrl'],
                                                        course['displayName'],
                                                        course['id'],
                                                      )));
                                        }
                                      },
                                      child: CircleAvatar(
                                        radius: 54,
                                        backgroundColor: TextThemes.ndGold,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(snapshot
                                              .data
                                              .documents[index]
                                              .data['photoUrl']),
                                          radius: 50,
                                          backgroundColor: TextThemes.ndBlue,
                                          child: CircleAvatar(
                                            // backgroundImage: snapshot.data
                                            //     .documents[index].data['photoUrl'],
                                            backgroundImage: NetworkImage(
                                                snapshot.data.documents[index]
                                                    .data['photoUrl']),
                                            radius: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: RichText(
                                          textScaleFactor: 1.1,
                                          text: TextSpan(
                                              style: TextThemes.mediumbody,
                                              children: [
                                                TextSpan(
                                                    text: snapshot
                                                        .data
                                                        .documents[index]
                                                        .data['displayName']
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    SingleChildScrollView(
                      child: Column(children: [
                        Text(
                          "NEXT MOOV",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                          child: Container(
                            child:
                                next != "" ? NextMOOV(next) : buildNoContent(),
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: SetMOOV(displayName, gid)));
                          },
                          color: TextThemes.ndBlue,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.edit, color: TextThemes.ndGold),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text('Set the MOOV',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20)),
                                ),
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: Text(
                            "CHAT",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextFormField(
                                controller: chatController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(fontSize: 15),
                                  contentPadding:
                                      EdgeInsets.only(top: 18, bottom: 10),
                                  hintText: "What's the MOOV tonight guys...",
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.message,
                                    size: 28.0,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(Icons.send),
                                    onPressed: sendChat,
                                  ),
                                ),
                                // onFieldSubmitted: sendChat(currentUser.displayName,
                                //     chatController.text, gid),
                              ),
                              height: 150,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: TextThemes.ndBlue,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                            ))
                      ]),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  buildNoContent() {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: isLargePhone
            ? SizeConfig.blockSizeVertical * 15
            : SizeConfig.blockSizeVertical * 18,
        child: Stack(alignment: Alignment.center, children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'lib/assets/bouts.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 7.5),
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
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Colors.black.withAlpha(15),
                      Colors.black,
                      Colors.black12,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    "No Upcoming MOOVs",
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
    );
  }
}
