import 'package:MOOV/main.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';

class BlockedPage extends StatelessWidget {
  const BlockedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TextThemes.ndBlue,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.all(5),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 50.0,
                ),
              ],
            ),
          ),
        ),
        body: Stack(children: [
          Image.asset('lib/assets/blockedOverlay.jpg'),
          Dialog(
              elevation: 10,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    width: 300,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50.0, left: 20, right: 20, bottom: 25),
                          child: Text(
                            "Get fucked.",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "Sorry, this app is exclusively made for ND students and local businesses.",
                            style: TextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "If you're a student, login with your @ND.EDU address. If you're a business, email kevin@whatsthemoov.com",
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                         Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "OK, I'll uninstall.",
                            style: TextStyle(decoration: TextDecoration.underline),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                  Positioned(
                    child: Transform.rotate(
                      angle: 100,
                      child: Container(
                          height: 10.0,
                          width: 130.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.red[200], Colors.purple[800]],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          )),
                    ),
                    top: 5,
                    left: -10,
                  )
                ],
              ))
        ]));
  }
}
