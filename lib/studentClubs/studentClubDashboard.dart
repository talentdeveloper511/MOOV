import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class StudentClubDashboard extends StatelessWidget {
  const StudentClubDashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "lib/assets/clubDash.jpeg",
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Club Dashboard",
                  style: TextThemes.headlineWhite,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 65.0, left: 20, right: 20),
                  child: Text("Here's your club's new best friend",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text("Edit", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width * .8,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Center(
                                child: Text(
                              "Add your members now!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: TextThemes.ndBlue),
                            ))),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Column(
                      children: [Icon(Icons.person_search), Text("Recruit")],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text("Next Meeting",
                style: TextStyle(color: TextThemes.ndBlue, fontSize: 18)),
            SizedBox(height: 10),
            StudentClubMOOV(),
          ],
        ));
  }
}

class StudentClubMOOV extends StatelessWidget {
  const StudentClubMOOV({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            height: 150,
            width: 300,
            child: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: OpenContainer(
                  transitionType: ContainerTransitionType.fade,
                  transitionDuration: Duration(milliseconds: 500),
                  openBuilder: (context, _) => PostDetail("id"),
                  closedElevation: 0,
                  closedBuilder: (context, _) => FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network("pic", fit: BoxFit.cover),
                      ),
                      // margin: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment(0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
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
                        child: Text(
                          "title",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Solway',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          )
        ]),
        SizedBox(height: 5),
        Container(
            height: 100.0,
            width: MediaQuery.of(context).size.width * .6,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Align(
                    alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                    "Member Statuses",
                    style: TextStyle(
                          fontWeight: FontWeight.bold, color: TextThemes.ndBlue),
                  ),
                      ))),
            )),
      ],
    );
  }
}
