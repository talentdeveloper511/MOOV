import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:MOOV/services/database.dart';

import 'home.dart';

class OtherProfile extends StatefulWidget {
  String photoUrl, displayName, id;

  OtherProfile(this.photoUrl, this.displayName, this.id);

  @override
  State<StatefulWidget> createState() {
    return _OtherProfileState(this.photoUrl, this.displayName, this.id);
  }
}

class _OtherProfileState extends State<OtherProfile> {
  String photoUrl, displayName, id;
  final dbRef = Firestore.instance;
  _OtherProfileState(this.photoUrl, this.displayName, this.id);
  bool requestsent = false;
  bool sendRequest = false;
  bool friends;
  var status;
  var userRequests;
  final strUserId = currentUser.id;
  final strPic = currentUser.photoUrl;
  final strUserName = currentUser.displayName;
  bool isAmbassador = currentUser.isAmbassador;
  var iter = 1;

  checkFunction() {
    // check to see if a request from other user already exists
    Database().checkStatus(id, strUserId).then((QuerySnapshot docs) => {
          if (docs.documents.isNotEmpty)
            {
              // setState(
              //     () => userRequests = docs.documents[0].data['friendRequests']),
              // for (var i = 0; i < userRequests.length; i++)
              //   {
              //     if (userRequests[i][id] == 0) {status = 2, print('hio')}
              //   }
              setState(() {
                status = 2;
              })
            }
        });
  }

  checkFunction2() {
    // checks to see if current user has sent request already
    Database().checkStatus(strUserId, id).then((QuerySnapshot docs) => {
          if (docs.documents.isNotEmpty)
            {
              setState(() =>
                  userRequests = docs.documents[0].data['friendRequests']),
              if (userRequests[0] != null) {status = 0}
            }
        });
  }

  checkFunction3() {
    // users are already friends
    Database().checkFriends(strUserId, id).then((QuerySnapshot docs) => {
          if (docs.documents.isNotEmpty)
            {
              setState(
                () => userRequests = docs.documents[0].data['friendRequests'],
              ),
              status = 1
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return StreamBuilder(
        stream: Firestore.instance.collection('users').document(id).snapshots(),
        builder: (context, snapshot) {
          isAmbassador = snapshot.data['isAmbassador'];
          if (!snapshot.hasData) return Text('Loading data...');
          while (iter > 0) {
            checkFunction();
            checkFunction2();
            checkFunction3();
            iter = iter - 1;
          }
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
                      Image.asset(
                        'lib/assets/moovblue.png',
                        fit: BoxFit.cover,
                        height: 55.0,
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(children: [
                Container(
                  height: 130,
                  child: GestureDetector(
                    onTap: () {},
                    child: Stack(children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: isLargePhone ? 1.17 : 1.34,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: snapshot.data['header'] == null
                                ? null
                                : Image.network(
                                    snapshot.data['header'],
                                    fit: BoxFit.fitWidth,
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: TextThemes.ndGold,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: TextThemes.ndBlue,
                          child: CircleAvatar(
                            backgroundImage: (photoUrl == null)
                                ? AssetImage('images/user-avatar.png')
                                : NetworkImage(snapshot.data['photoUrl']),
                            // backgroundImage: NetworkImage(currentUser.photoUrl),
                            radius: 50,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName != ""
                                ? displayName
                                : "Username not found",
                            style: TextThemes.extraBold,
                          ),
                          isAmbassador
                              ? Image.asset('lib/assets/verif.png', height: 35)
                              : Text("")
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 8.0),
                          child: Text(
                            snapshot.data['year'] +
                                " in " +
                                snapshot.data['dorm'],
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              '2',
                              style: TextThemes.extraBold,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Next MOOVs   ',
                                style: TextThemes.bodyText1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '0',
                                style: TextThemes.extraBold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Friends',
                                  style: TextThemes.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '0',
                              style: TextThemes.extraBold,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Friend Groups',
                                style: TextThemes.bodyText1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    snapshot.data['bio'] != "Create a bio here"
                        ? Card(
                            margin: EdgeInsets.only(
                                left: 15, right: 15, bottom: 20, top: 10),
                            color: TextThemes.ndBlue,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, bottom: 2, top: 8),
                                  child: RichText(
                                    textScaleFactor: 1.75,
                                    text: TextSpan(
                                        style: TextThemes.mediumbody,
                                        children: [
                                          TextSpan(
                                              text: "",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  color: TextThemes.ndGold)),
                                        ]),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 40),
                                  child: Center(
                                    child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: RichText(
                                          textScaleFactor: 1.3,
                                          text: TextSpan(
                                              style: TextThemes.mediumbody,
                                              children: [
                                                TextSpan(
                                                    text: "\"" +
                                                        snapshot.data['bio'] +
                                                        "\"",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontStyle:
                                                            FontStyle.italic)),
                                              ]),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(""),
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 7.5, bottom: 15, top: 15.5),
                      child: status == 2
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                    padding: const EdgeInsets.all(12.0),
                                    color: Color.fromRGBO(0, 100, 0, 1.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0))),
                                    onPressed: () {
                                      Database().acceptFriendRequest(
                                          id, strUserId, strUserName, strPic);
                                      status = 1;
                                      Database().friendAcceptNotification(
                                          id, photoUrl, displayName, strUserId);
                                    },
                                    child: Text(
                                      "Accept Friend Request",
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    )),
                                RaisedButton(
                                    padding: const EdgeInsets.all(12.0),
                                    color: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(3.0))),
                                    onPressed: () {
                                      Database().rejectFriendRequest(
                                          strUserId, id, strUserName, strPic);
                                      status = null;
                                    },
                                    child: Text(
                                      "Decline Friend Request",
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    )),
                              ],
                            )
                          : status != 1
                              ? RaisedButton(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Color.fromRGBO(2, 43, 91, 1.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    Database().sendFriendRequest(
                                        strUserId, id, strUserName, strPic);
                                    status = 0;
                                    Database().friendRequestNotification(
                                        id, photoUrl, displayName, strUserId);
                                  },
                                  child: status == null
                                      ? Text(
                                          "Send Friend Request",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      : Text(
                                          "Request Sent",
                                          style: new TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                )
                              : RaisedButton(
                                  padding: const EdgeInsets.all(12.0),
                                  color: Color.fromRGBO(0, 100, 0, 1.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    // unfriend code here
                                  },
                                  child: Text(
                                    "Friends",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  )),
                    ),
                  ],
                ),
              ]));
        });
  }
}
