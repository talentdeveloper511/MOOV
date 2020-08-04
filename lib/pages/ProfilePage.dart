import 'package:MOOV3/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV3/widgets/post_card.dart';
import 'package:MOOV3/helpers/demo_values.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: TextThemes.ndGold,
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/assets/me.jpg'),
                  maxRadius: 75,
                  minRadius: 75,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kevin Camson',
                style: TextThemes.extraBold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '0 Friends',
                  style: TextThemes.bodyText1,
                ), Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('•'),
                ), Text('0 upcoming MOOVS', style: TextThemes.bodyText1,)
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 7.5, bottom: 20, top: 15.5),
              child: SizedBox(
                height: 35.0,
                width: 300,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
                  label: Text("Edit profile"),
                  foregroundColor: Colors.white,
                  elevation: 15,
                ),
              ),
            ), Text('Past MOOVs'), 
          ],
        ),
      ),
    ));
  }
}
