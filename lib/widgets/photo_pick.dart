import 'dart:io';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:MOOV/widgets/camera.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class PhotoPick extends StatefulWidget {
  final Widget beforeUI, afterUI;
  final String pic;
  PhotoPick(this.beforeUI, this.afterUI, this.pic);

  @override
  _PhotoPickState createState() => _PhotoPickState();
}

class _PhotoPickState extends State<PhotoPick> {
  File _image;

  bool isUploading = false;

  var placeholderImage;
  final picker = ImagePicker();

  void openCamera(context) async {
    final image = await CustomCamera.openCamera();
    setState(() {
      _image = image;
      //  fileName = p.basename(_image.path);
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

  firebase_storage.Reference ref;
  firebase_storage.UploadTask uploadTask;
  firebase_storage.TaskSnapshot taskSnapshot;
  String downloadUrl = "";
  void openGallery(context) async {
    final image = await CustomCamera.openGallery();
    setState(() {
      _image = image;
    });
    _cropImage().then((_image != null)
        ? {
            setState(() {
              isUploading = true;
            }),
            ref = firebase_storage.FirebaseStorage.instance
                .ref()
                .child("images/" + currentUser.id + "menu/" + randomString(3)),
            uploadTask = ref.putFile(_image),
            taskSnapshot = await uploadTask,
            if (uploadTask.snapshot.state == firebase_storage.TaskState.success)
              {
                print("added to Firebase Storage"),
                downloadUrl = await taskSnapshot.ref.getDownloadURL(),
                usersRef.doc(currentUser.id).set({
                  "menu": FieldValue.arrayUnion([downloadUrl]),
                }, SetOptions(merge: true)),
                setState(() {
                  isUploading = false;
                })
              }
          }
        : circularProgress());
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
            "Show it off",
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
    bool isLargePhone = Screen.diagonal(context) > 766;

    return Column(children: [
      _image != null
          ? Container(
              height: 200,
              width: MediaQuery.of(context).size.width * .99,
              child: ListView(scrollDirection: Axis.horizontal, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    height: 200,
                    width: 175,
                    decoration: BoxDecoration(
                        color: Colors.purple[50],
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Center(
                        child: AspectRatio(
                            aspectRatio: 9 / 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_image, fit: BoxFit.cover),
                            ))),
                  ),
                ),
                PhotoPick(
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book),
                              Text("Add your menu")
                            ],
                          ),
                          height: 200,
                          width: 175,
                          decoration: BoxDecoration(
                              color: Colors.purple[50],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                    ),
                    Container(),
                    ""),
              ]),
            )
          : !isUploading
              ? Container(
                  child: widget.pic != null && widget.pic != ""
                      ? Stack(
                          children: [
                            OpenContainer(
                                transitionType: ContainerTransitionType.fade,
                                transitionDuration: Duration(milliseconds: 500),
                                openBuilder: (context, _) =>
                                    PhotoFullScreen(widget.pic),
                                closedElevation: 0,
                                closedBuilder: (context, _) => widget.beforeUI),
                            // Container(child: widget.beforeUI),
                            Positioned(
                                top: 10,
                                right: 30,
                                child: GestureDetector(
                                    onTap: () => showAlertDialog(context),
                                    child: Icon(Icons.delete, color: Colors.red,))),
                            Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                    onTap: () => selectImage(context),
                                    child: Icon(Icons.add)))
                          ],
                        )
                      : GestureDetector(
                          onTap: () => selectImage(context),
                          child: Container(child: widget.beforeUI)),
                )
              : circularProgress(),
    ]);
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("Delete",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("Delete this?"),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("Keep pic", style: TextStyle()),
              onPressed: () => Navigator.of(context).pop(true)),
          CupertinoDialogAction(
            child: Text("Delete", style: TextStyle(color: Colors.red)),
            onPressed: () {
              usersRef.doc(currentUser.id).set({
                "menu": FieldValue.arrayRemove([widget.pic]),
              }, SetOptions(merge: true));
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}

class PhotoFullScreen extends StatelessWidget {
  final String image;
  const PhotoFullScreen(this.image);
  final bool includeMarkAsDoneButton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: (includeMarkAsDoneButton)
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  tooltip: 'Mark as done',
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(
                      context,
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
        body: Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(image, fit: BoxFit.cover)),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)))));
  }
}
