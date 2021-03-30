import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemoteControl extends StatefulWidget {
  RemoteControl();

  @override
  State<StatefulWidget> createState() {
    return _RemoteControlState();
  }
}

class _RemoteControlState extends State<RemoteControl> {
  final dbRef = FirebaseFirestore.instance;
  _RemoteControlState();
  final pollTitleController = TextEditingController();
  final choice1Controller = TextEditingController();
  final choice2Controller = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
               Navigator.pop(context);
 
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(15),
          title: Text('Remote Control',
              style: TextStyle(fontSize: 25.0, color: Colors.white)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: pollTitleController,
                  decoration: InputDecoration(
                    labelText: "title",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: choice1Controller,
                  decoration: InputDecoration(
                    labelText: "choice 1",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: choice2Controller,
                  decoration: InputDecoration(
                    labelText: "choice 2",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: "DATE",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: Text("Date needs to be 'Feb 24' format")),
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
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
                          "Save that shit",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      if (pollTitleController.text != "" &&
                          choice1Controller.text != "" &&
                          choice2Controller.text != "" &&
                          dateController.text != "") {
                        FirebaseFirestore.instance
                            .collection('notreDame')
                            .doc('data')
                            .collection('poll')
                            .doc(dateController.text)
                            .set({
                          "choice1": choice1Controller.text,
                          "choice2": choice2Controller.text,
                          "question": pollTitleController.text,
                          "suggestorName": null,
                          "suggestorYear": null,
                          "voters": {currentUser.id: 1}
                        }, SetOptions(merge: true));
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
