import 'dart:io';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'home.dart';

final usersRef = Firestore.instance.collection('users');

class MoovMaker extends StatefulWidget {
  final PostModel postModel;

  MoovMaker({Key key, @required this.postModel}) : super(key: key);
  @override
  _MoovMakerState createState() => _MoovMakerState();
}

class _MoovMakerState extends State<MoovMaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_drop_up_outlined,
                color: Colors.white, size: 35),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: TextThemes.ndBlue,
        //pinned: true,

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
      body: Center(
          child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    child: ClipRRect(
                      child: Image.asset(
                        'lib/assets/motd.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
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
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 44.0),
                      child: Text(
                        "MOOV Maker",
                        style: TextStyle(
                            fontFamily: 'Solway',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 25.0),
                      ),
                    ),
                  ),
                ),
              ]),
              MoovMakerForm(),
            ]),
      )),
    );
  }
}

class MoovMakerForm extends StatefulWidget {
  MoovMakerForm({Key key}) : super(key: key);

  @override
  _MoovMakerFormState createState() => _MoovMakerFormState();
}

class _MoovMakerFormState extends State<MoovMakerForm> {
  File _image;
  final picker = ImagePicker();

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

  final _formKey = GlobalKey<FormState>();
  final privacyList = ["Public", "Friends Only", "Invite Only"];
  final listOfTypes = [
    "Restaurants & Bars",
    "Pregames & Parties",
    "Clubs",
    "Sports",
    "Shows",
    "Virtual",
    "Dorm Life",
    "Shopping",
    "Games",
    "Music",
    "Black Market",
    "Study",
    "Student Gov",
    "Mass",
    "Service"
  ];

  DateTime currentValue = DateTime.now();
  DateTime currentValues;
  // DateTime endTime = DateTime.now().add(Duration(minutes: 120));
  // DateTime endTimes;
  String privacyDropdownValue = 'Public';
  String typeDropdownValue = 'Pregames & Parties';
  String locationDropdownValue = 'Off Campus';
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = DatePicker().startDate1;
  final format = DateFormat("EEE, MMM d,' at' h:mm a");
  User currentUser;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.create,
                  color: TextThemes.ndGold,
                ),
                labelText: "Enter Event Title",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Event Title';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: typeDropdownValue,
              icon: Icon(Icons.arrow_downward, color: TextThemes.ndGold),
              decoration: InputDecoration(
                labelText: "Select Event Type",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: listOfTypes.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  typeDropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'What are we doing?';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: addressController,
              decoration: InputDecoration(
                icon: Icon(Icons.place, color: TextThemes.ndGold),
                labelText: "Where's it at?",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return "Where's it at?";
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: DropdownButtonFormField(
              value: privacyDropdownValue,
              icon: Icon(Icons.arrow_downward, color: TextThemes.ndGold),
              decoration: InputDecoration(
                labelText: "Visibility",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              items: privacyList.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              onChanged: (String newValue) {
                setState(() {
                  privacyDropdownValue = newValue;
                });
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Who can come?';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.description,
                  color: TextThemes.ndGold,
                ),
                labelText: "Describe your MOOV",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value.isEmpty) {
                  return "What's going down?";
                }
                return null;
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.all(20.0),
          //   child: DropdownButtonFormField(
          //     value: locationDropdownValue,
          //     icon: Icon(Icons.arrow_downward, color: TextThemes.ndGold),
          //     decoration: InputDecoration(
          //       labelText: "Select Location",
          //       enabledBorder: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     items: listOfLocations.map((String value) {
          //       return new DropdownMenuItem<String>(
          //         value: value,
          //         child: new Text(value),
          //       );
          //     }).toList(),
          //     onChanged: (String newValue) {
          //       setState(() {
          //         locationDropdownValue = newValue;
          //       });
          //     },
          //     validator: (value) {
          //       if (value.isEmpty) {
          //         return 'Select Event Type';
          //       }
          //       return null;
          //     },
          //   ),
          // ),

          Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 20, right: 20, bottom: 10),
            child: DateTimeField(
              format: format,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.arrow_downward,
                    color: TextThemes.ndGold,
                  ),
                  labelText: 'Enter Start Time',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  floatingLabelBehavior: FloatingLabelBehavior.always),
              onChanged: (DateTime newValue) {
                setState(() {
                  currentValue = currentValues; // = newValue;
                  //   newValue = currentValue;
                });
              },
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        primaryColor: TextThemes.ndGold,
                        accentColor: TextThemes.ndGold,
                        colorScheme:
                            ColorScheme.light(primary: TextThemes.ndBlue),
                        buttonTheme:
                            ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child,
                    );
                  },
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor: TextThemes.ndGold,
                          accentColor: TextThemes.ndGold,
                          colorScheme:
                              ColorScheme.light(primary: TextThemes.ndBlue),
                          buttonTheme: ButtonThemeData(
                              textTheme: ButtonTextTheme.primary),
                        ),
                        child: child,
                      );
                    },
                  );
                  currentValues = DateTimeField.combine(date, time);
                  return currentValues;
                } else {
                  return currentValue.add(Duration(days: 18250));
                }
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: DateTimeField(
          //     format: format,
          //     keyboardType: TextInputType.datetime,
          //     decoration: InputDecoration(
          //         suffixIcon: Icon(
          //           Icons.arrow_downward,
          //           color: TextThemes.ndGold,
          //         ),
          //         labelText: 'Enter End Time',
          //         enabledBorder: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(10.0)),
          //         floatingLabelBehavior: FloatingLabelBehavior.always),
          //     onChanged: (DateTime et) {
          //       setState(() {
          //         endTime = endTimes;
          //       });
          //     },
          //     onShowPicker: (context, endTime) async {
          //       final date = await showDatePicker(
          //         context: context,
          //         firstDate: DateTime(1900),
          //         initialDate: endTime ?? DateTime.now(),
          //         lastDate: DateTime(2100),
          //         builder: (BuildContext context, Widget child) {
          //           return Theme(
          //             data: ThemeData.light().copyWith(
          //               primaryColor: TextThemes.ndGold,
          //               accentColor: TextThemes.ndGold,
          //               colorScheme:
          //                   ColorScheme.light(primary: TextThemes.ndBlue),
          //               buttonTheme:
          //                   ButtonThemeData(textTheme: ButtonTextTheme.primary),
          //             ),
          //             child: child,
          //           );
          //         },
          //       );
          //       if (date != null) {
          //         final time = await showTimePicker(
          //           context: context,
          //           initialTime:
          //               TimeOfDay.fromDateTime(endTime ?? DateTime.now()),
          //           builder: (BuildContext context, Widget child) {
          //             return Theme(
          //               data: ThemeData.light().copyWith(
          //                 primaryColor: TextThemes.ndGold,
          //                 accentColor: TextThemes.ndGold,
          //                 colorScheme:
          //                     ColorScheme.light(primary: TextThemes.ndBlue),
          //                 buttonTheme: ButtonThemeData(
          //                     textTheme: ButtonTextTheme.primary),
          //               ),
          //               child: child,
          //             );
          //           },
          //         );
          //         endTimes = DateTimeField.combine(date, time);
          //         return endTimes;
          //       } else {
          //         return endTime.add(Duration(days: 18250));
          //       }
          //     },
          //   ),
          // ),
          RaisedButton(
              color: TextThemes.ndBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Upload an image',
                    style: TextStyle(color: Colors.white, fontSize: 22)),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              onPressed: () => selectImage(context)),
          _image != null
              ? Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width * .8,
                  child: Center(
                      child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.file(_image,
                                width: 100, height: 100, fit: BoxFit.fitHeight),
                          ))),
                )
              : Container(),
          Padding(
              padding: EdgeInsets.only(bottom: 20.0, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      padding: EdgeInsets.all(0.0),
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [TextThemes.ndBlue, Color(0xff64B6FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Container(
                          constraints:
                              BoxConstraints(maxWidth: 125.0, minHeight: 50.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Post!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final GoogleSignInAccount user =
                            googleSignIn.currentUser;
                        final strUserId = user.id;
                        final profilePic = user.photoUrl;
                        final userName = user.displayName;
                        final userEmail = user.email;
                        if (_formKey.currentState.validate()) {
                          if (_image != null) {
                            StorageReference firebaseStorageRef =
                                FirebaseStorage.instance
                                    .ref()
                                    .child("images/" + titleController.text);
                            StorageUploadTask uploadTask =
                                firebaseStorageRef.putFile(_image);
                            StorageTaskSnapshot taskSnapshot =
                                await uploadTask.onComplete;
                            if (taskSnapshot.error == null) {
                              print("added to Firebase Storage");
                              final String downloadUrl =
                                  await taskSnapshot.ref.getDownloadURL();
                              Database().createPost(
                                title: titleController.text,
                                type: typeDropdownValue,
                                privacy: privacyDropdownValue,
                                description: descriptionController.text,
                                location: locationDropdownValue,
                                address: addressController.text,
                                startDate: currentValue,
                                // endDate: endTime,
                                imageUrl: downloadUrl,
                                userId: strUserId,
                                likes: false,
                                userName: userName,
                                userEmail: userEmail,
                                profilePic: profilePic,
                              );
                            }
                            Navigator.pop(context);
                          }
                        }
                      }),
                ],
              )),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }
}

class DatePicker extends StatefulWidget {
  DatePicker({this.startDate1});
  DateTime startDate1 = DateTime.now();
  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime startDate1 = DateTime.now();
  // DateTime _endDate = DateTime.now().add(Duration(days: 7));

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: startDate1,
        // initialLastDate: _endDate,
        firstDate: new DateTime(DateTime.now().year),
        lastDate: new DateTime(DateTime.now().year + 10));
    if (picked != null && picked.length == 2) {
      setState(() {
        startDate1 = picked[0];
        // _endDate = picked[1];
      });
    } else if (picked.length == 1) {
      setState(() {
        startDate1 = picked[0];
        // _endDate = picked[0];
      });
    }
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // Text("Location ${widget.postModel.title}"),
        RaisedButton(
          color: Colors.amber[300],
          child: Text("Select Dates"),
          onPressed: () async {
            await displayDateRangePicker(context);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                    "Start Date: ${DateFormat('EEE, MM/dd').format(startDate1).toString()}"),
                // Text(
                //     "End Date: ${DateFormat('EEE, MM/dd').format(_endDate).toString()}"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
