import 'package:MOOV3/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
              padding: const EdgeInsets.only(top: 35.0, bottom: 10),
              child: CircleAvatar(
        backgroundImage: AssetImage('lib/assets/woman.jpg'),
        maxRadius: 75,
        minRadius: 75,),
            ),
            Text('Rebecca Lin', style: TextThemes.extraBold,),
            Padding(
          padding: const EdgeInsets.only(right: 7.5, bottom: 7.5, top: 15.5),
          child: SizedBox(
            height: 35.0,
            width: 300,
            child: FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.edit),
              backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
              label: Text("Edit profile"), foregroundColor: Colors.white,
              elevation: 15,
            ),
          ),
        ),
          ],
        ),
      ),
    ));
  }
}

