import 'dart:io';

import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final Home user;

  final usersRef = Firestore.instance.collection('users');

  EditProfile({Key key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  get firestoreInstance => null;
  File _image;

  void openCamera(context) async {
    File _image;
    final image = await CustomCamera.openCamera();
    setState(() {
      _image = image;
      //  fileName = p.basename(_image.path);
    });
  }

  void openGallery(context) async {
    final image = await CustomCamera.openGallery();
    setState(() {
      File _image;
      _image = image;
    });
  }

  final picker = ImagePicker();

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Create Post",
            style: TextStyle(color: Colors.white),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Photo with Camera",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openCamera(context);
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              //    child: Text("Image from Gallery", style: TextStyle(color: Colors.white),), onPressed: handleChooseFromGallery),
              //    child: Text("Image from Gallery", style: TextStyle(color: Colors.white),), onPressed: () => openGallery(context)),
              child: Text(
                "Image from Gallery",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openGallery(context);
                Navigator.of(context).pop();
              },
            ),
            SimpleDialogOption(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context, true),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    dynamic userScore = currentUser.score.toString();
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;
    final dormController = TextEditingController();
    final genderController = TextEditingController();
    final bioController = TextEditingController();

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
                          // backgroundImage: NetworkImage(currentUser.photoUrl),
                          radius: 50,
                        ),
                      ),
                      Center(
                          child: IconButton(
                              icon: Icon(Icons.add_a_photo, size: 50),
                              onPressed: selectImage(context)))
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
                padding: const EdgeInsets.only(top: 30.0, bottom: 5),
                child: Text(
                  "Dorm",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: dormController,
                  decoration: InputDecoration(
                    labelText: "Which dorm do you live in?",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 5),
                child: Text(
                  "Bio",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: bioController,
                  decoration: InputDecoration(
                    labelText: "What's your party trick?",
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: RaisedButton(
                    color: TextThemes.ndBlue,
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      //DATABASE CODE HERE
                      print(currentUser.id);
                      usersRef.document(currentUser.id).updateData({
                        "dorm": dormController.text.toUpperCase(),
                        "bio": bioController.text.toUpperCase(),
                      });
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
