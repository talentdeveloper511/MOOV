import 'package:flutter/material.dart';
import 'package:MOOV3/pages/HomePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whats the MOOV?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(220, 180, 57, 1.0),
        dialogBackgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Color.fromRGBO(220, 180, 57, 1.0),
        fontFamily: 'Solway',
      ),
      home: HomePage(),
    );
  }
}
