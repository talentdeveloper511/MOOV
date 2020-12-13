import 'dart:async';

import 'package:MOOV/helpers/themes.dart';
// import 'package:MOOV/pages/HomePage.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  String dorm;
  String gender;
  String year;

  submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackbar = SnackBar(content: Text("Welcome to MOOV"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context, [dorm, gender, year]);
      });
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
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
              Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 55.0,
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
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      "Tell us about you",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
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
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Must be at least 3 characters",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey2,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 2 || val.isEmpty) {
                            return "Please enter either Freshman, Sophomore, Junior, or Senior";
                          } else if (val.trim().length > 16) {
                            return "Please enter either Freshman, Sophomore, Junior, or Senior";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => year = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Freshman, Sophomore, Junior, or Senior",
                          labelStyle: TextStyle(fontSize: 15.0),
                          hintText: "Freshman, Sophomore, Junior, or Senior",
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey3,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 2 || val.isEmpty) {
                            return "Gender should be Male or Female";
                          } else if (val.trim().length > 7) {
                            return "Gender should be Male or Female";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => gender = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Gender",
                          labelStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
