import 'dart:async';

import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditClub extends StatefulWidget {
  final String clubId;
  EditClub(this.clubId);

  @override
  _EditClubState createState() => _EditClubState();
}

class _EditClubState extends State<EditClub> {
  bool isUploading = false;
  bool goodCheck = false;
  final duesController = TextEditingController();

  int duesInt;
  String dues;

  @override
  Widget build(BuildContext context) {
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
          title: Text('Edit Club',
              style: TextStyle(fontSize: 25.0, color: Colors.white)),
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: clubsRef.doc(widget.clubId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Container();
              }
              List<String> memberNames =
                  List<String>.from(snapshot.data['memberNames']);

              return Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/editclub.jpeg",
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                        colorBlendMode: BlendMode.darken,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "Make it Your Own",
                        style: TextThemes.headlineWhite,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 65.0, left: 20, right: 20),
                        child: Text("Want another feature? DM MOOV Team.",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  (isUploading)
                      ? linearProgress()
                      : (goodCheck)
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sweet!",
                                    style: TextThemes.headline1,
                                  ),
                                  SizedBox(height: 30),
                                  Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: 250,
                                  decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text("Set dues",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20)),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .23,
                                        child: ButtonTheme(
                                          child: TextFormField(
                                            onChanged: (text) {
                                              setState(() {
                                                dues = text;
                                              });
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              CurrencyTextInputFormatter(
                                                decimalDigits: 0,
                                                symbol: '\$',
                                              )
                                            ],
                                            controller: duesController,
                                            decoration: InputDecoration(
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never,
                                              icon: Icon(Icons.monetization_on,
                                                  color: Colors.green),
                                              labelStyle: TextThemes.mediumbody,
                                              labelText:
                                                  dues.toString() == "null"
                                                      ? "0"
                                                      : "\$$dues",
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                            ),
                                            // The validator receives the text that the user has entered.
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(28.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.red, width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              "LEAVE CLUB",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 15),
                                      GestureDetector(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Colors.blue, width: 3),
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              "NEW CLUB",
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(80.0)),
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
                                            borderRadius:
                                                BorderRadius.circular(30.0)),
                                        child: Container(
                                          constraints: BoxConstraints(
                                              maxWidth: 125.0, minHeight: 50.0),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Save",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        HapticFeedback.lightImpact();

                                        setState(() {
                                          isUploading = true;
                                        });
                                        if (duesController.text.isNotEmpty) {
                                          String x =
                                              duesController.text.substring(1);
                                          duesInt = int.parse(x);
                                        }
                                        clubsRef
                                            .doc(widget.clubId)
                                            .set({
                                              // "clubName": clubNameController.text,
                                              "dues": duesInt,
                                              'members': {
                                                for (var v in memberNames) v: 1
                                              },
                                            }, SetOptions(merge: true))
                                            .then((value) => setState(() {
                                                  isUploading = false;
                                                }))
                                            .then((value) => setState(() {
                                                  goodCheck = true;
                                                }))
                                            .then((value) =>
                                                Timer(Duration(seconds: 1), () {
                                                  Navigator.pop(
                                                    context,
                                                  );
                                                }));
                                      }),
                                ),
                              ],
                            ),
                ],
              );
            }),
      ),
    );
  }
}
