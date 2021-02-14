import 'dart:async';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:MOOV/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey0 = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final yearList = ["Freshman", "Sophomore", "Junior", "Senior", "Grad"];
  final genderList = ["Male", "Female", "Other"];

  String yearDropdownValue = "Freshman";
  String genderDropdownValue = "Female";

  String dorm;
  String gender;
  String year;
  String referral;
  String venmoUsername;

  submit() {
    final form0 = _formKey0.currentState;
    final form = _formKey.currentState;
    final form2 = _formKey2.currentState;
    final form3 = _formKey3.currentState;
    final form4 = _formKey4.currentState;

    if (form0.validate() &&
        form.validate() &&
        form2.validate() &&
        form3.validate()) {
      form0.save();
      form.save();
      form2.save();
      form3.save();
      form4.save();
      SnackBar snackbar = SnackBar(
          backgroundColor: Colors.green, content: Text("Welcome to MOOV!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      createUserInFirestore();

      Timer(Duration(seconds: 1), () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context,
                        [dorm, gender, year, referral, venmoUsername, auth]) =>
                    Home()));
      });
    }
  }

  createUserInFirestore() async {
    // 1) check if user exists in users collection in database (according to their id)
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();

    if (!doc.exists) {
      // 2) if the user doesn't exist, then we want to take them to the create account page

      // 3) get username from create account, use it to make new user document in users collection
      usersRef.doc(user.id).set({
        "id": user.id,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "Create a bio here",
        "header": "",
        "timestamp": timestamp,
        "score": 0,
        "gender": gender,
        "year": year,
        "dorm": dorm,
        "referral": referral,
        "postLimit": 3,
        "sendLimit": 5,
        "verifiedStatus": 0,
        "friendArray": [],
        "friendRequests": [],
        "friendGroups": [],
        "venmoUsername": venmoUsername,
        "pushSettings": {
          "going": true,
          "hourBefore": true,
          "suggestions": true
        },
        "privacySettings": {
          "friendFinderVisibility": true,
          "friendsOnly": false,
          "incognito": false,
          "showDorm": true
        }
      });
      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
  }

  @override
  Widget build(BuildContext parentContext) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: TextThemes.ndBlue,
        //pinned: true,

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
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: isLargePhone ? 30 : 15),
                Container(
                  child: Container(
                      child: Column(children: [
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.accessibility_new,
                          color: TextThemes.ndBlue,
                          size: 50,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child:
                          Text("Welcome to MOOV", style: TextThemes.headline1),
                    ),
                    Text(
                      "Tell us about you",
                    ),
                  ])),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 50, right: 50),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        validator: (val) {
                          if (val.trim().length < 2 || val.isEmpty) {
                            return "Dorm name is too short";
                          } else if (val.trim().length > 16) {
                            return "Dorm name is too long";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => dorm = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Dorm",
                          labelStyle: TextStyle(fontSize: 13.0),
                          hintText: "Dorm",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Form(
                          key: _formKey2,
                          autovalidate: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .35,
                            child: ButtonTheme(
                              child: DropdownButtonFormField(
                                value: yearDropdownValue,
                                icon: Icon(Icons.arrow_downward,
                                    color: TextThemes.ndGold),
                                decoration: InputDecoration(
                                  labelText: "Year",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                items: yearList.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(value),
                                  );
                                }).toList(),
                                onChanged: (String newValue) {
                                  setState(() {
                                    yearDropdownValue = newValue;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'What year are you?';
                                  }
                                  return null;
                                },
                                onSaved: (value) => year = value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey3,
                        autovalidate: true,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .35,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              value: genderDropdownValue,
                              icon: Icon(Icons.arrow_downward,
                                  color: TextThemes.ndGold),
                              decoration: InputDecoration(
                                labelText: "Gender",
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              items: genderList.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  genderDropdownValue = newValue;
                                });
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'What gender are you?';
                                }
                                return null;
                              },
                              onSaved: (value) => gender = value,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Text("Optional Details"),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Form(
                          key: _formKey0,
                          autovalidate: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: ButtonTheme(
                              child: TextFormField(
                                autocorrect: false,
                                validator: (val) {
                                  if (val.trim().length > 2 &&
                                      !val.contains("@nd.edu")) {
                                    return "Enter an @nd.edu address";
                                  } else if (val.trim().length > 16) {
                                    return "Enter an @nd.edu address";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (val) => referral = val,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Who referred you?",
                                  labelStyle: TextStyle(fontSize: 13.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Form(
                          key: _formKey4,
                          autovalidate: true,
                          child: Container(
                            width: MediaQuery.of(context).size.width * .4,
                            child: ButtonTheme(
                              child: TextFormField(
                                autocorrect: false,
                                onSaved: (val) => venmoUsername = val,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Venmo Username",
                                  labelStyle: TextStyle(fontSize: 13.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isLargePhone ? 30 : 0),
                GestureDetector(
                  onTap: submit,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Container(
                      height: 50.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                        color: TextThemes.ndBlue,
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
