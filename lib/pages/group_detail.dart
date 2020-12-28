import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MOOV/services/database.dart';

import 'home.dart';

class GroupDetail extends StatefulWidget {
  String photoUrl, displayName;
  List<dynamic> members;

  GroupDetail(this.photoUrl, this.displayName, this.members);

  @override
  State<StatefulWidget> createState() {
    return _GroupDetailState(this.photoUrl, this.displayName, this.members);
  }
}

class _GroupDetailState extends State<GroupDetail> {
  String photoUrl, displayName;
  List<dynamic> members;
  final dbRef = Firestore.instance;
  _GroupDetailState(this.photoUrl, this.displayName, this.members);
  bool requestsent = false;
  bool sendRequest = false;
  bool friends;
  var status;
  var userRequests;
  final GoogleSignInAccount userMe = googleSignIn.currentUser;
  final strUserId = currentUser.id;
  final strPic = currentUser.photoUrl;
  final strUserName = currentUser.displayName;
  var iter = 1;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .where('friendGroups', arrayContains: displayName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();

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
                  titlePadding: EdgeInsets.all(15),
                  title: Text(displayName,
                      style: TextStyle(fontSize: 30.0, color: Colors.white)),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: OutlineButton(
                        borderSide: BorderSide(
                            color: Colors.red,
                            width: 5,
                            style: BorderStyle.solid),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.red,
                                width: 5,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: null,
                        child: Text(
                          "LEAVE",
                          style: TextStyle(color: Colors.red),
                        )),
                  )
                ]),
            body: Container(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, index) {
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
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) => OtherProfile()));
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
                                          backgroundImage: NetworkImage(snapshot
                                              .data
                                              .documents[index]
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
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "NEXT \nMOOV:",
                            style: GoogleFonts.robotoSlab(fontSize: 20),
                          ),
                          Stack(children: <Widget>[
                            SizedBox(
                              height: 120,
                              width: 320,
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    'lib/assets/bouts.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                margin: EdgeInsets.only(
                                    left: 20, top: 0, right: 20, bottom: 7.5),
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
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 40,
                              left: 50,
                              right: 50,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
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
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Baraka Bouts",
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
                            )
                          ]),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: RaisedButton(
                      onPressed: () {},
                    color: TextThemes.ndBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                      
                        children: [
                          Icon(Icons.edit, color: TextThemes.ndGold),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Set the MOOV',
                             style: TextStyle(color: Colors.white, fontSize: 22)),
                          ),
                        ],
                      ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("CHAT", style: TextStyle(fontSize: 20),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 300,
  decoration: BoxDecoration(
    border: Border.all(
      color: TextThemes.ndBlue,
    ),
    borderRadius: BorderRadius.all(Radius.circular(20))
  ),
  
)
                  )
                ],
              ),
            ),
          );
        });
  }
}

class CircleImages extends StatefulWidget {
  var image = "";

  CircleImages({this.image});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CircleWidgets(image: image);
  }
}

class CircleWidgets extends State<CircleImages> {
  var image;
  CircleWidgets({this.image});
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (var x = 0; x < 10; x++) {
      widgets.add(Container(
          height: 60.0,
          width: 60.0,
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              boxShadow: [
                new BoxShadow(
                    color: Color.fromARGB(100, 0, 0, 0),
                    blurRadius: 5.0,
                    offset: Offset(5.0, 5.0))
              ],
              border: Border.all(
                  width: 2.0,
                  style: BorderStyle.solid,
                  color: Color.fromARGB(255, 0, 0, 0)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(image)))));
    }
    return Container(
        height: 80.0,
        child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(5.0),
            children: widgets));
  }
}
