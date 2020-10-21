import 'package:MOOV/pages/home/home.dart';
import 'package:MOOV/provider/auth_provider.dart';
import 'package:MOOV/provider/language_provider.dart';
import 'package:MOOV/provider/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/pages/ManagerPage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/pages/auth/LoginPage.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'enums/flavor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    runApp(
      /*
      * MultiProvider for top services that do not depends on any runtime values
      * such as user uid/email.
       */
      MultiProvider(providers: [
        Provider<Flavor>.value(value: Flavor.dev),
          ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider(),
          ),

          ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider(),
          ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ], child: MOOV()),
    );
  });
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
