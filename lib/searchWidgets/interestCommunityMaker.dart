import 'dart:io';

import 'package:MOOV/helpers/common.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/IconPicker/Packs/FontAwesome.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class InterestCommunityMaker extends StatelessWidget {
  const InterestCommunityMaker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final nameController = TextEditingController();
  File _image;
  final picker = ImagePicker();

  void openCamera(context) async {
    final image = await CustomCamera.openCamera();
    setState(() {
      _image = image;
      _noImage = false;
      //  fileName = p.basename(_image.path);
    });
    _cropImage();
  }

  void openGallery(context) async {
    final image = await CustomCamera.openGallery();
    setState(() {
      _image = image;
      _noImage = false;
    });
    _cropImage();
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        maxHeight: 100,
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Croperooni',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Croperooni',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            "Upload Pic",
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

  final _formKey = GlobalKey<FormState>();

  bool _isUploading = false;
  bool _isChecking = false;
  bool nameTaken = false;
  bool _noImage = false;
  bool _noIcon = false;
  List takenNames = [];
  String groupName;
  Icon _icon;

  bool equalsIgnoreCase(String string1, String string2) {
    return string1?.toLowerCase() == string2?.toLowerCase();
  }

  @override
  void initState() {
    super.initState();

    communityGroupsRef.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        String name = value.docs[i]['groupName'].toLowerCase();
        takenNames.add(name);
      }
    });
  }

  _pickIcon() async {
    IconData icon = await FlutterIconPicker.showIconPicker(context,
        barrierDismissible: false,
        iconPackMode: IconPack.custom,
        customIconPack: fontAwesomeIcons,
        iconColor: Colors.white);

    _icon = Icon(icon, color: Colors.white, size: 40);

    if (icon == null) {
      _icon = Icon(Icons.emoji_emotions, color: Colors.white, size: 41);
    }
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  static final RegExp REGEX_EMOJI = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  @override
  Widget build(BuildContext context) {

    return Theme(
      data: ThemeData.from(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber)),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  child: _image == null
                      ? Image.asset(
                          'lib/assets/bouts.jpg',
                          fit: BoxFit.cover,
                          color: Colors.black45,
                          colorBlendMode: BlendMode.darken,
                        )
                      : Image.file(_image,
                          fit: BoxFit.cover,
                          color: Colors.black45,
                          colorBlendMode: BlendMode.darken),
                  margin:
                      EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 7.5),
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
                Positioned(
                  right: 15,
                  bottom: 20,
                  child: IconButton(
                      icon: Icon(Icons.add_a_photo,
                          size: 40,
                          color: _noImage ? Colors.red : Colors.white),
                      onPressed: () => selectImage(context)),
                ),
                Positioned(
                  right: 60,
                  bottom: 20,
                  child: _icon != null
                      ? GestureDetector(
                          onTap: () {
                            _pickIcon();
                          },
                          child: _icon)
                      : IconButton(
                          icon: Icon(Icons.emoji_emotions,
                              size: 40,
                              color: _noIcon ? Colors.red : Colors.white),
                          onPressed: () {
                            _pickIcon();
                          }),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 100.0, right: 100, top: 40),
                  child: Container(
                    height: 83,
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          child: Text("M",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: TextThemes.ndGold)),
                        ),
                        Container(
                            height: 60,
                            child: Text(
                              "/",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            )),
                        Expanded(
                          child: Container(
                            height: 84,
                            child: TextFormField(
                              controller: nameController,
                              style: GoogleFonts.montserrat(
                                  fontSize: 20, color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Anything..',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  helperText: ' ',
                                  errorStyle: TextStyle(color: Colors.white)),
                              validator: (input) {
                                if (input == null || input.isEmpty) {
                                  return 'No name? Strange.';
                                }
                                if (input.length > 18) {
                                  return "That's a mouthful.";
                                }
                                final RegExp emoji = RegExp(
                                    r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');
                                if (emoji.hasMatch(input)) {
                                  return 'No emojis here';
                                }
                                String lower = input.toLowerCase();

                                if (takenNames.contains(lower)) {
                                  return 'This community exists!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (_icon == null || _icon.size == 41.0) {
                          setState(() {
                            _noIcon = true;
                          });
                        }
                        if (_image == null) {
                          setState(() {
                            _noImage = true;
                          });
                        } else {
                          setState(() {
                            _isUploading = true;
                          });
                          _createGroup(nameController.text);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30))),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: TextThemes.ndGold,
                          borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        width: 115,
                        height: 40,
                        alignment: Alignment.center,
                        child: _isUploading
                            ? linearProgress()
                            : _isChecking
                                ? Center(
                                    child:
                                        Icon(Icons.check, color: Colors.white))
                                : Text(
                                    'Create',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                      ),
                    ),
                  ),
                )),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _createGroup(String groupName) async {
    String groupId = generateRandomString(20);

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("images/" + groupId);
    firebase_storage.UploadTask uploadTask;

    uploadTask = ref.putFile(_image);

    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    if (uploadTask.snapshot.state == firebase_storage.TaskState.success) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      communityGroupsRef.doc(groupId).set({
        "groupId": groupId,
        "groupName": groupName,
        "members": [currentUser.id],
        "admins": [currentUser.id],
        "notifList": [currentUser.id],
        "groupPic": downloadUrl,
        "groupIcon": {
          "codePoint": _icon.icon.codePoint,
          "fontFamily": _icon.icon.fontFamily,
        }
      }).then((value) => setState(() {
            _isUploading = false;
            _isChecking = true;
          }));
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } else {
      return linearProgress();
    }
  }
}
