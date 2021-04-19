import 'package:MOOV/main.dart';
import 'package:MOOV/pages/create_account.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
      backgroundColor: TextThemes.ndBlue,
      body: Column(
        children: [
          SizedBox(height: isLargePhone ? 60 : 30),
          SizedBox(
            child: Image.asset('lib/assets/welcomePage.png'),
          ),
          SizedBox(height: isLargePhone ? 80 : 30),
          SizedBox(
            child: Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateAccount()));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff64B6FF), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "I'm in",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BetaWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Scaffold(
      backgroundColor: TextThemes.ndBlue,
      body: Column(
        children: [
          SizedBox(height: isLargePhone ? 30 : 0),
          SizedBox(
            child: Image.asset('lib/assets/betaWelcome.png'),
          ),
          SizedBox(height: isLargePhone ? 50 : 15),
          SizedBox(
            child: Container(
              height: 50.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => CreateAccount()),
                    (Route<dynamic> route) => false,
                  );
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff64B6FF), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 150.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Say less",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: isLargePhone ? 50 : 0),
          SizedBox(
            child: Image.asset('lib/assets/betaDisclaimer.png'),
          ),
        ],
      ),
    );
  }
}
