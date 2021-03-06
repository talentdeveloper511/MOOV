import 'package:flutter/material.dart';

class TextThemes {

  const TextThemes();

  static final Color ndGold = Color.fromRGBO(220, 180, 57, 1.0);
  static final Color ndBlue = Color.fromRGBO(2, 43, 91, 1.0);

  static final TextStyle headline1 = TextStyle(
    fontFamily: 'Solway',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Color.fromRGBO(2, 43, 91, 1.0),
  );
  
 static final TextStyle headlineWhite = TextStyle(
    fontFamily: 'Solway',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white
  );

  static final TextStyle extraBold = TextStyle(
    fontFamily: 'Solway',
    fontSize: 24,
    fontWeight: FontWeight.w800,
  );
  static final TextStyle extraBoldWhite = TextStyle(
    fontFamily: 'Solway',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: Colors.white
  );

  static final TextStyle italic = TextStyle(
    fontFamily: 'Solway',
    fontSize: 14,
    fontStyle: FontStyle.italic,
    color: ndGold
  );
  static final TextStyle subtitle1 = TextStyle(
    fontFamily: 'Solway',
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static final TextStyle bodyText1 = TextStyle(
    fontFamily: 'Solway',
    fontSize: 11,
    fontWeight: FontWeight.w300,
  );
  static final TextStyle bodyTextWhite = TextStyle(
    fontFamily: 'Solway',
    fontSize: 11,
    fontWeight: FontWeight.w300,
    color: Colors.white
  );
  static final TextStyle mediumbody = TextStyle(
    fontFamily: 'Solway',
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: ndBlue
  );

  static final TextStyle dateStyle = TextStyle(
    fontFamily: 'Solway',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color.fromRGBO(2, 43, 91, 1.0),
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
