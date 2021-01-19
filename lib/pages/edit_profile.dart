import 'dart:io';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final Home user;

  final usersRef = FirebaseFirestore.instance.collection('users');

  EditProfile({Key key, this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  get firestoreInstance => null;
  File _image;
  File _image2;
  final picker = ImagePicker();
  final picker2 = ImagePicker();

  void openCamera(context) async {
    final image = await CustomCamera.openCamera();
    setState(() {
      _image = image;
      //  fileName = p.basename(_image.path);
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
            "Upload Profile Pic",
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

  void openCamera2(context) async {
    final image2 = await CustomCamera.openCamera();
    setState(() {
      _image2 = image2;
      //  fileName = p.basename(_image.path);
    });
  }

  void openGallery2(context) async {
    final image2 = await CustomCamera.openGallery();
    setState(() {
      _image2 = image2;
    });
  }

  Future handleTakePhoto2() async {
    Navigator.pop(context);
    final file2 = await picker2.getImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (_image2 != null) {
        _image2 = File(file2.path);
      }
    });
  }

  handleChooseFromGallery2() async {
    Navigator.pop(context);
    final file2 = await picker2.getImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      if (_image2 != null) {
        _image2 = File(file2.path);
      }
    });
  }

  selectImage2(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: Text(
            "Upload Header",
            style: TextStyle(color: Colors.white),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text(
                "Photo with Camera",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                openCamera2(context);
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
                openGallery2(context);
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

    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    dynamic userScore = currentUser.score.toString();
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    var userHeader = currentUser.header;

    dynamic likeCount;
    final dormController = TextEditingController();
    final bioController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => ProfilePageWithHeader()),
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 55.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: 145,
            child: GestureDetector(
              onTap: () => selectImage2(context),
              child: Stack(children: <Widget>[
                FractionallySizedBox(
                  widthFactor: isLargePhone ? 1.15 : 1.34,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: currentUser.header == ""
                          ? Image.asset('lib/assets/headerNoWhite.jpg',
                              fit: BoxFit.cover)
                          : Image.network(
                              currentUser.header,
                              fit: BoxFit.fitWidth,
                            ),
                    ),
                    margin: EdgeInsets.only(
                        left: 20, top: 0, right: 20, bottom: 7.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 50,
                  top: 20,
                  child: IconButton(
                      icon: Icon(Icons.add_a_photo, size: 50),
                      onPressed: () => selectImage2(context)),
                ),
                FractionallySizedBox(
                    widthFactor: isLargePhone ? 1.15 : 1.34,
                    child: _image2 != null
                        ? Container(
                            child: Image.file(_image2, fit: BoxFit.fitWidth),
                            margin: EdgeInsets.only(
                                left: 20, top: 0, right: 20, bottom: 7.5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                          )
                        : Text("")),
              ]),
            ),
          ),
          Container(
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
                            child: _image != null
                                ? CircleAvatar(
                                    backgroundImage: FileImage(_image),
                                    radius: 200,
                                  )
                                : Container(
                                    width: 100,
                                    height: 100,
                                    child: IconButton(
                                        icon: Icon(Icons.add_a_photo, size: 50),
                                        onPressed: () => selectImage(context))))
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
                      child:
                          Text('Save', style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_image != null) {
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref()
                              .child("images/" + currentUser.displayName);

                          // StorageReference firebaseStorageRef = FirebaseStorage
                          //     .instance
                          //     .ref()
                          //     .child("images/" + currentUser.displayName);
                          firebase_storage.UploadTask uploadTask;

                          uploadTask = ref.putFile(_image);

                          firebase_storage.UploadTask /*!*/ task;

                          // task = await uploadTask;
                          if (uploadTask.snapshot.state ==
                              firebase_storage.TaskState.success) {
                            print("added to Firebase Storage");

                            final String downloadUrl =
                                await ref.getDownloadURL();

                            usersRef.doc(currentUser.id).update({
                              "photoUrl": downloadUrl,
                            });
                          }
                        }
                        if (_image2 != null) {
                          firebase_storage.Reference ref = firebase_storage
                              .FirebaseStorage.instance
                              .ref()
                              .child("images/header" + currentUser.displayName);

                          // StorageReference firebaseStorageRef = FirebaseStorage
                          //     .instance
                          //     .ref()
                          //     .child("images/header" + currentUser.displayName);
                          firebase_storage.UploadTask uploadTask;

                          uploadTask = ref.putFile(_image2);
                          firebase_storage.UploadTask /*!*/ task;

                          firebase_storage.TaskSnapshot taskSnapshot =
                              await task;
                          if (task.snapshot.state ==
                              firebase_storage.TaskState.success) {
                            print("added to Firebase Storage");
                            final String headerUrl =
                                await taskSnapshot.ref.getDownloadURL();
                            usersRef.doc(currentUser.id).update({
                              "header": headerUrl,
                            });
                          }
                        }
                        if (dormController.text != "") {
                          usersRef.doc(currentUser.id).update({
                            "dorm": dormController.text.toUpperCase(),
                          });
                        }

                        if (bioController.text != "") {
                          usersRef.doc(currentUser.id).update({
                            "bio": bioController.text,
                          });
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
