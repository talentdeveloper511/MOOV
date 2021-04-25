import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';

//this pag4 handles deposits and withdraws of MOOV Money
class MoovMoneyAdd extends StatelessWidget {
  MoovMoneyAdd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

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
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(alignment: Alignment.center, children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: SizedBox(
                  height: 190,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'lib/assets/moovmoney.jpg',
                        color: Colors.black12,
                        colorBlendMode: BlendMode.darken,
                        fit: BoxFit.cover,
                      ),
                    ),
                    margin:
                        EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 7.5),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
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
                          "MOOV Money",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Solway',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Column(
              children: [
                Text("Current Balance ",
                    style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 23)),
                SizedBox(height: 5),
                Text("\$0",
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 23)),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Use MOOV Money to buy anything at your MOOVs. Drinks at the bar, Venmo for house covers, skipping bar lines, club dues, you name it.",
                          style: TextStyle(fontWeight: FontWeight.w300),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ),
                Container(
                height: 50.0,
                width: 300.0,
                decoration: BoxDecoration(
                  color: TextThemes.ndGold,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Center(
                  child: Text(
                    "Deposit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ],
            )
          ],
        ));
  }
}
