import 'dart:io';
import 'dart:math';
// import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:MOOV/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/LoginPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';

final bucketGlobalHome = PageStorageBucket();
PageStorageKey homeKey = PageStorageKey("homeKey");

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.blue, // navigation bar color
      statusBarColor: TextThemes.ndBlue));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MOOV());
  });
}

class MOOV extends StatelessWidget {
  MOOV({Key key}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1284, 2778),
      allowFontScaling: false,
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus.unfocus();
          }
        },
        child: MaterialApp(
          navigatorKey: navigatorKey,
          builder: (context, widget) {
            return MediaQuery(
              child: widget,
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            );
          }, //for accessibility larger text size
          title: 'MOOV',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(brightness: Brightness.dark),
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
          // home: Scaffold(
          //   body: push.MessageHandler(),
          // )
          home: PageStorage(
              bucket: bucketGlobalHome, key: homeKey, child: Home()),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  bool hide = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        child: Column(
          children: [
            Opacity(
                opacity: hide ? 0 : 1,
                child: MaterialButton(
                  onPressed: () {},
                  child: Text('Me!'),
                  color: Colors.green,
                )),
            MaterialButton(
              onPressed: () {
                setState(() {
                  hide = !hide;
                });
              },
              child: Text('${hide ? "Show" : "Hide"}'),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}

class Screen {
  static double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;
  static bool isLandscape(BuildContext c) =>
      MediaQuery.of(c).orientation == Orientation.landscape;
  //PIXELS
  static Size size(BuildContext c) => MediaQuery.of(c).size;
  static double width(BuildContext c) => size(c).width;
  static double height(BuildContext c) => size(c).height;
  static double diagonal(BuildContext c) {
    Size s = size(c);
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  //INCHES
  static Size inches(BuildContext c) {
    Size pxSize = size(c);
    return Size(pxSize.width / _ppi, pxSize.height / _ppi);
  }

  static double widthInches(BuildContext c) => inches(c).width;
  static double heightInches(BuildContext c) => inches(c).height;
  static double diagonalInches(BuildContext c) => diagonal(c) / _ppi;
}
