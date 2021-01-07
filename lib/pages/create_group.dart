import 'dart:io';

import 'package:MOOV/pages/friend_groups.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupForm extends StatefulWidget {
  final Home user;
  final usersRef = Firestore.instance.collection('users');

  GroupForm({Key key, this.user}) : super(key: key);

  @override
  _GroupFormState createState() => new _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  get firestoreInstance => null;
  File _image;
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

  Future<bool> doesNameAlreadyExist(groupName) async {
    List<String> groupNames = [];

    final QuerySnapshot result = await Firestore.instance
        .collection('friendGroups')
        .where('groupName', isEqualTo: groupName)
        .getDocuments();
    for (int i = 0; i < result.documents.length; i++) {
      groupNames.add(result.documents[i].data['groupName']);
    }
    if (groupNames.contains(groupName))
      // return true;
      print("Yes, this name exists already!");
    else
      // return false;
      print("No, this name does not exist, we're good to go.");
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

  createGroupInFirestore(gname, cid, pic) async {
    final String groupName = gname;

    Firestore.instance.collection('friendGroups').add({
      "groupName": groupName,
      "members": [cid],
      "groupPic": pic,
      "chat": {'messages': []},
      "nextMOOV": ""
    });
    return Firestore.instance.runTransaction((transaction) async {
      final DocumentReference userRefs =
          Firestore.instance.document('users/$cid');

      transaction.update(userRefs, {
        'friendGroups': FieldValue.arrayUnion([gname]),
      });
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String groupName;
  bool _termsChecked = false;
  int radioValue = -1;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => FriendGroupsPage()),
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
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(children: [
                    _image != null
                        ? Container(
                            height: 200,
                            width: 200,
                            child: Image.file(_image, fit: BoxFit.cover),
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
                        : Container(
                            width: 100,
                            height: 100,
                            child: IconButton(
                                icon: Icon(Icons.add_a_photo, size: 50),
                                onPressed: () => selectImage(context))),
                  ]))),
          Container(
              margin: const EdgeInsets.all(20.0),
              child: new Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: new Column(
                    children: <Widget>[
                      new SizedBox(
                        height: 20.0,
                      ),
                      new TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'Friend Group Name'),
                        onSaved: (String value) {
                          groupName = value;
                        },
                        validator: _validateGroupName,
                        keyboardType: TextInputType.name,
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      new CheckboxListTile(
                          title: new Text("We'll be lit."),
                          value: _termsChecked,
                          onChanged: (bool value) =>
                              setState(() => _termsChecked = value)),
                      new SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        height: 50.0,
                        child: RaisedButton(
                          onPressed: _validateInputs,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    TextThemes.ndBlue,
                                    Color(0xff64B6FF)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 300.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Create Friend Group",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'You can add friends after you create the group.'),
                      ),
                    ],
                  ))),
        ],
      ),
    );
  }

  String _validateGroupName(String value) {
    doesNameAlreadyExist(value);
    if (value.isEmpty) {
      // The form is empty
      return "Enter group name";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    return 'Group name is invalid!';

    // The pattern of the email didn't match the regex above.
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (!_termsChecked) {
        // The checkbox wasn't checked
        _showSnackBar("Please accept our terms");
      } else {
        // Every of the data in the form are valid at this point
        form.save();
        _saveFirebase();
      }
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _saveFirebase() async {
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("images/group" + groupName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    if (taskSnapshot.error == null) {
      print("added to Firebase Storage");
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      createGroupInFirestore(groupName, currentUser.id, downloadUrl);
    }

    Navigator.pop(context);
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      backgroundColor: Colors.red,
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
