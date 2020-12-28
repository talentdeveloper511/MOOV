import 'dart:io';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroup extends StatefulWidget {
  final Home user;
  final usersRef = Firestore.instance.collection('users');

  CreateGroup({Key key, this.user}) : super(key: key);
  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  get firestoreInstance => null;
  File _image;
  File _image2;
  final picker = ImagePicker();

  void openCamera(context) async {
    final image = await CustomCamera.openCamera();
    setState(() {
      _image = image;
    });
  }

  void openGallery(context) async {
    final image = await CustomCamera.openGallery();
    setState(() {
      _image = image;
    });
  }

  Future handleTakePhoto() async {
    Navigator.pop(context);
    final file = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (_image != null) {
        _image = File(file.path);
      }
    });
  }

  createGroupInFirestore(gname, cid) async {
    final String groupName = gname;

    Firestore.instance.collection('friendgroups').add({
      "groupName": groupName,
      "members": [cid],
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    final file = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (_image != null) {
        _image = File(file.path);
      }
    });
  }

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Upload Group Picture",
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
    bool isLargePhone = Screen.diagonal(context) > 766;

    var userHeader = "";
    final dormController = TextEditingController();
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
        child: Stack(children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 100,
                      height: 100,
                      child: IconButton(
                          icon: Icon(Icons.add_a_photo, size: 50),
                          onPressed: () => selectImage(context))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 5),
                  child: Text(
                    "Group Name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: bioController,
                    decoration: InputDecoration(
                      labelText: "What do we call you guys?",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: TextThemes.ndGold)),
                      color: TextThemes.ndBlue,
                      child: Text('Create Friend Group',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_image != null) {
                          StorageReference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child("images/" + currentUser.displayName);
                          StorageUploadTask uploadTask =
                              firebaseStorageRef.putFile(_image);
                          StorageTaskSnapshot taskSnapshot =
                              await uploadTask.onComplete;
                          if (taskSnapshot.error == null) {
                            print("added to Firebase Storage");
                            final String downloadUrl =
                                await taskSnapshot.ref.getDownloadURL();
                            usersRef.document(currentUser.id).updateData({
                              "photoUrl": downloadUrl,
                            });
                          }
                        }
                        if (_image2 != null) {
                          StorageReference firebaseStorageRef = FirebaseStorage
                              .instance
                              .ref()
                              .child("images/header" + currentUser.displayName);
                          StorageUploadTask uploadTask =
                              firebaseStorageRef.putFile(_image2);
                          StorageTaskSnapshot taskSnapshot =
                              await uploadTask.onComplete;
                          if (taskSnapshot.error == null) {
                            print("added to Firebase Storage");
                            final String headerUrl =
                                await taskSnapshot.ref.getDownloadURL();
                            usersRef.document(currentUser.id).updateData({
                              "header": headerUrl,
                            });
                          }
                        }

                        if (bioController.text != "") {
                          createGroupInFirestore(
                              bioController.text, currentUser.id);
                        }
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
