import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:MOOV/widgets/friend_groups_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EditProfile extends StatefulWidget {
  final Home user;
  EditProfile({Key key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final dorms = MoovMaker.listOfLocations;
    final strUserId = user.id;
    dynamic userScore = currentUser.score.toString();
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;
    final bioController = TextEditingController();
    final factController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
=======
        leading: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset('lib/assets/ndlogo.png', height: 100),
        ),
        backgroundColor: TextThemes.ndBlue,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.insert_chart),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LeaderBoardPage()));
            },
>>>>>>> a53770c0baab08b9b115846c55635b23d8627537
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 55.0,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: TextThemes.ndGold,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: TextThemes.ndBlue,
                    child: Stack(children: [
                      Opacity(
                        opacity: .5,
                        child: CircleAvatar(
                          backgroundImage: (currentUser.photoUrl == null)
                              ? AssetImage('images/user-avatar.png')
                              : NetworkImage(currentUser.photoUrl),
                          radius: 50,
                        ),
                      ),
                      Center(child: Icon(Icons.add_a_photo, size: 50))
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  currentUser.displayName != null
                      ? currentUser.displayName
                      : "Username not found",
                  style: TextThemes.extraBold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                child: Text(
                  "Dorm",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: "What dorm are you in?",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
<<<<<<< HEAD
=======
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a bio';
                    }
                    return null;
                  },
>>>>>>> a53770c0baab08b9b115846c55635b23d8627537
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 15),
                child: Text(
                  "Bio",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: factController,
                  decoration: InputDecoration(
                    labelText: "What's your party trick?",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
<<<<<<< HEAD
=======
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Enter a fun fact';
                    }
                    return null;
                  },
>>>>>>> a53770c0baab08b9b115846c55635b23d8627537
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                    color: TextThemes.ndBlue,
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      //DATABASE CODE HERE
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
