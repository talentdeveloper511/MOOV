import 'dart:async';

import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SuggestionBoxCarousel extends StatelessWidget {
  const SuggestionBoxCarousel();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SuggestionForm()));
      },
      child: Stack(alignment: Alignment.center, children: [
        Image.asset(
          'lib/assets/suggestion.png',
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Suggestion Box",
                style: TextStyle(
                    color: TextThemes.ndBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("\$5",
                    style: GoogleFonts.kaushanScript(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.w800)),
              ),
              Text("for each helpful suggestion")
            ],
          ),
        )
      ]),
    );
  }
}

class SuggestionForm extends StatefulWidget {
  @override
  SuggestionFormState createState() {
    return SuggestionFormState();
  }
}

class SuggestionFormState extends State<SuggestionForm> {
  final suggestionController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
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
      body: Form(
        key: _formKey,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/suggestion.png',
                  scale: 15,
                ),
                SizedBox(height: 15),
                Text(
                  "Let's make money together",
                  style: TextThemes.headline1,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                    "What could be better with our app? \nEach helpful suggestion will net you \$5.",
                    textAlign: TextAlign.center),
                SizedBox(height: 30),
                TextFormField(
                  controller: suggestionController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blueGrey[100],
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Akrobat-Bold'),
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      hintText: 'Anything helpful...'),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 125.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 22),
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

                          String whenString = DateFormat('MMMd').format(aDate);
                          FirebaseFirestore.instance
                              .collection("suggestions")
                              .doc(whenString)
                              .collection(currentUser.displayName)
                              .doc(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                              .set({
                            "suggestion": suggestionController.text,
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    suggestionController.dispose();
  }
}
