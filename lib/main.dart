import 'package:MOOV/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/ManagerPage.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/LoginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MOOV());
}

class MOOV extends StatelessWidget {
  const MOOV({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats the MOOV?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CupertinoColors.lightBackgroundGray,
        dialogBackgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Color.fromRGBO(220, 180, 57, 1.0),
        textTheme: TextTheme(
            headline1: TextThemes.headline1,
            subtitle1: TextThemes.subtitle1,
            bodyText1: TextThemes.bodyText1),
        fontFamily: 'Solway',
      ),
      home: Home(),
    );
  }
}
