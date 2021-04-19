import 'dart:async';

import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PromoteClub extends StatefulWidget {
  final String clubId;
  PromoteClub(this.clubId);

  @override
  _PromoteClubState createState() => _PromoteClubState();
}

class _PromoteClubState extends State<PromoteClub> {
  final storyController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                // borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "lib/assets/lead.png",
                  color: TextThemes.ndBlue,
                  colorBlendMode: BlendMode.darken,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 60.0,
                ),
                child: Text(
                  "Promote",
                  style: TextThemes.headlineWhite,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, left: 20, right: 20),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text("\nMOOV exists to spotlight underrepresented groups.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13)),
                    Text("Tell us your story.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 13))
                  ],
                ),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: storyController,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey[100],
                          hintStyle: TextStyle(
                              color: Colors.black38,
                              fontFamily: 'Akrobat-Bold'),
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          hintText: 'Why should someone join your club?'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Text(
                      "Shout us out on socials @MOOV.ND \n..maybe we'll hook you up.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                TextThemes.ndBlue,
                                Color(0xff64B6FF)
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: 125.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        if (_formKey.currentState.validate()) {
                          final dateToCheck = Timestamp.now().toDate();
                          final aDate = DateTime(dateToCheck.year,
                              dateToCheck.month, dateToCheck.day);

                          String whenString =
                              DateFormat('MMMd').format(aDate);
                          FirebaseFirestore.instance
                              .collection("promotionPitches")
                              .doc(whenString)
                              .collection(widget.clubId)
                              .doc(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                              .set({
                            "story": storyController.text,
                            "when": DateTime.now()
                          });

                          SnackBar snackbar = SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  "Thank you, ${currentUser.displayName}!"));
                          _scaffoldKey.currentState.showSnackBar(snackbar);
                          Timer(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    storyController.dispose();
  }
}
