import 'package:MOOV/helpers/size_config.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:MOOV/widgets/friend_groups_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MOTD extends StatefulWidget {
  @override
  _MOTDState createState() => _MOTDState();
}

class _MOTDState extends State<MOTD> {
  @override
  Widget build(BuildContext context) {
    var title;
    var pic;

    return StreamBuilder(
        stream: Firestore.instance.collection('MOTD').document("ARohxuFZnP6fm1bqzMac"
).snapshots(),
        builder: (context, snapshot) {
          title = snapshot.data['title'];
          pic = snapshot.data['pic'];
          if (!snapshot.hasData) return Text('Loading data...');

          return Column(
            children: <Widget>[
              Container(
                height: SizeConfig.blockSizeVertical * 15,
                child: Stack(children: <Widget>[
                  FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          pic,
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: EdgeInsets.only(
                          left: 20, top: 10, right: 20, bottom: 7.5),
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
                        child: Text(
                          title,
                          style: TextStyle(
                              fontFamily: 'Solway',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (_) => CupertinoAlertDialog(
                                  title: Text("Your MOOV."),
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        "Do you have the MOOV of the Day? Email kcamson@nd.edu."),
                                  ),
                                ),
                            barrierDismissible: true);
                      },
                      child: Card(
                        borderOnForeground: true,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "MOOV of the Day",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          );
        });
  }
}
