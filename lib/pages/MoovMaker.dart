import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/OtherGroup.dart';
import 'package:MOOV/pages/group_detail.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/widgets/add_users_post.dart';
import 'package:MOOV/widgets/camera.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:page_transition/page_transition.dart';
import 'home.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

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
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(alignment: Alignment.center, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      child: ClipRRect(
                        child: Image.asset(
                          'lib/assets/motd.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      margin: EdgeInsets.only(
                          left: 0, top: 0, right: 0, bottom: 7.5),
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
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Container(
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
              ]),
              MoovMakerForm(),
            ]),
      ),
    );
  }
}

class MoovMakerForm extends StatefulWidget {
  MoovMakerForm({Key key}) : super(key: key);

  @override
  _MoovMakerFormState createState() => _MoovMakerFormState();
}

class _MoovMakerFormState extends State<MoovMakerForm> {
  bool isUploading = false;

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

  final _formKey = GlobalKey<FormState>();
  final privacyList = ["Public", "Friends Only", "Invite Only"];
  final listOfTypes = [
    "Restaurants & Bars",
    "Pregames & Parties",
    "Clubs",
    "Sports",
    "Shows",
    "Virtual",
    "Recreation",
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
  // String locationDropdownValue = 'Off Campus';
  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final descriptionController = TextEditingController();
  final startDateController = DatePicker().startDate1;
  final maxOccupancyController = TextEditingController();
  final venmoController = TextEditingController();

  final format = DateFormat("EEE, MMM d,' at' h:mm a");
  Map<String, int> invitees = {};
  List<String> inviteesNameList = [];
  String userName;
  String userPic;
  int id = 0;
  bool noImage = false;
  bool barcode = false;
  String maxOccupancy;
  int maxOccupancyInt;
  String venmo;
  int venmoInt;
  bool noHeight = true;
  List<String> groupList = [];
  List groupMembers = [];
  bool push = true;



  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void refreshData() {
    id++;
  }

  FutureOr onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;
      List pushList = currentUser.pushSettings.values.toList();
    if (pushList[0] == false) {
      push = false;
    }

    return Form(
      key: _formKey,
      child: isUploading
          ? linearProgress()
          : SingleChildScrollView(
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 15.0, left: 15, right: 15),
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.create,
                        color: TextThemes.ndGold,
                      ),
                      labelText: "MOOV Title",
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
                  padding: EdgeInsets.only(top: 5, bottom: 15.0, left: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0, left: 8),
                        child: Icon(Icons.question_answer,
                            color: TextThemes.ndGold),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .45,
                        child: ButtonTheme(
                          child: DropdownButtonFormField(
                            style: isLargePhone
                                ? null
                                : TextStyle(
                                    fontSize: 12.5, color: Colors.black),
                            value: typeDropdownValue,
                            icon: Icon(Icons.museum, color: TextThemes.ndGold),
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
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * .35,
                          child: ButtonTheme(
                            child: DropdownButtonFormField(
                              style: isLargePhone
                                  ? null
                                  : TextStyle(
                                      fontSize: 12.5, color: Colors.black),
                              value: privacyDropdownValue,
                              icon: Icon(Icons.privacy_tip_outlined,
                                  color: TextThemes.ndGold),
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
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 5),
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.place, color: TextThemes.ndGold),
                      labelText: "Location or Address",
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
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.description,
                        color: TextThemes.ndGold,
                      ),
                      labelText: "Details about the MOOV",
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
                      top: 5, left: 15, bottom: 10, right: 15),
                  child: Container(
                    child: DateTimeField(
                      format: format,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          icon: Icon(Icons.timelapse, color: TextThemes.ndGold),
                          suffixIcon: Icon(
                            Icons.calendar_today,
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
                          firstDate: DateTime(2021),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (BuildContext context, Widget child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                primaryColor: TextThemes.ndGold,
                                accentColor: TextThemes.ndGold,
                                colorScheme: ColorScheme.light(
                                    primary: TextThemes.ndBlue),
                                buttonTheme: ButtonThemeData(
                                    textTheme: ButtonTextTheme.primary),
                              ),
                              child: child,
                            );
                          },
                        );
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  primaryColor: TextThemes.ndGold,
                                  accentColor: TextThemes.ndGold,
                                  colorScheme: ColorScheme.light(
                                      primary: TextThemes.ndBlue),
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
                          return currentValue;
                        }
                      },
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 0.0, left: 40, right: 12.5),
                  child: Column(
                    children: <Widget>[
                      ExpansionTile(
                        title: Text(
                          "Optional Details",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        children: <Widget>[
                          // ExpansionTile(
                          //   title: Text(
                          //     'Sub title',
                          //   ),
                          //   children: <Widget>[
                          //     // ListTile(
                          //     //   title: Text('data'),
                          //     // )
                          //   ],
                          // ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(flex: 4, child: Text('Max Occupancy')),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    controller: maxOccupancyController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                        setState(() => maxOccupancy = value),

                                    // your TextField's Content
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 4, child: Text('Venmo Per Person')),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    textAlign: TextAlign.center,
                                    inputFormatters: [
                                      CurrencyTextInputFormatter(
                                        decimalDigits: 0,
                                        symbol: '\$',
                                      )
                                    ],

                                    controller: venmoController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) =>
                                        setState(() => venmo = value),

                                    // your TextField's Content
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CheckboxListTile(
                              title: new Text("Needs a Barcode (Verification)"),
                              value: barcode,
                              onChanged: (bool value) =>
                                  setState(() => barcode = value)),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.bottomToTop,
                                    child: SearchUsersPost(inviteesNameList)))
                            .then(onGoBack);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      icon: Icon(
                                        Icons.person_add,
                                        size: 35,
                                      ),
                                      color: TextThemes.ndBlue,
                                      splashColor:
                                          Color.fromRGBO(220, 180, 57, 1.0),
                                      onPressed: () {
                                        Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    child: SearchUsersPost(
                                                        inviteesNameList)))
                                            .then(onGoBack);
                                      },
                                    ),
                                    Text("Invite",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              Container(
                                height: 100,
                                width: inviteesNameList.length == 0
                                    ? 0
                                    : MediaQuery.of(context).size.width * .74,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: inviteesNameList.length,
                                    itemBuilder: (_, index) {
                                      bool hide = false;
                                      if (!_isNumeric(
                                          inviteesNameList[index])) {
                                        hide = true;
                                      }
                                      return (hide == false)
                                          ? StreamBuilder(
                                              stream: usersRef
                                                  .doc(inviteesNameList[index])
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                // bool isLargePhone = Screen.diagonal(context) > 766;

                                                if (!snapshot.hasData)
                                                  return CircularProgressIndicator();

                                                userName = snapshot
                                                    .data['displayName'];
                                                userPic =
                                                    snapshot.data['photoUrl'];

                                                // userMoovs = snapshot.data['likedMoovs'];

                                                return Container(
                                                  height: 50,
                                                  child: Column(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          OtherProfile(
                                                                            inviteesNameList[index],
                                                                          )));
                                                        },
                                                        child: CircleAvatar(
                                                          radius: 34,
                                                          backgroundColor:
                                                              TextThemes.ndGold,
                                                          child: CircleAvatar(
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    userPic),
                                                            radius: 32,
                                                            backgroundColor:
                                                                TextThemes
                                                                    .ndBlue,
                                                            child: CircleAvatar(
                                                              // backgroundImage: snapshot.data
                                                              //     .documents[index].data['photoUrl'],
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      userPic),
                                                              radius: 32,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        5.0),
                                                            child: RichText(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              textScaleFactor:
                                                                  1.0,
                                                              text: TextSpan(
                                                                  style: TextThemes
                                                                      .mediumbody,
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            userName,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w500)),
                                                                  ]),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })
                                          : Container();
                                    }),
                              ),
                            ]),
                      ),
                    )),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 23.0),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: inviteesNameList.length,
                        itemBuilder: (_, index) {
                          bool hide = false;
                          if (_isNumeric(inviteesNameList[index])) {
                            hide = true;
                          }
                          if (inviteesNameList.length == 0) {
                            noHeight = true;
                          }
                          if (inviteesNameList.length != 0) {
                            noHeight = false;
                          }
                          return (hide == false)
                              ? StreamBuilder(
                                  stream: groupsRef
                                      .doc(inviteesNameList[index])
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    // bool isLargePhone = Screen.diagonal(context) > 766;

                                    if (!snapshot.hasData)
                                      return CircularProgressIndicator();

                                    userName = snapshot.data['groupName'];
                                    userPic = snapshot.data['groupPic'];
                                    String groupId = snapshot.data['groupId'];
                                    List members = snapshot.data['members'];

                                    // userMoovs = snapshot.data['likedMoovs'];

                                    return Container(
                                      height: 50,
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () => Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        members.contains(
                                                                currentUser.id)
                                                            ? GroupDetail(
                                                                groupId)
                                                            : OtherGroup(
                                                                groupId))),
                                            child: Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  SizedBox(
                                                    width: isLargePhone
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    height: isLargePhone
                                                        ? MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.09
                                                        : MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07,
                                                    child: Container(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: userPic,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      margin: EdgeInsets.only(
                                                          left: 10,
                                                          top: 0,
                                                          right: 10,
                                                          bottom: 0),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset: Offset(0,
                                                                3), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: <Color>[
                                                          Colors.black
                                                              .withAlpha(0),
                                                          Colors.black,
                                                          Colors.black12,
                                                        ],
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: ConstrainedBox(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .2),
                                                        child: Text(
                                                          userName,
                                                          maxLines: 2,
                                                          textAlign:
                                                              TextAlign.center,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Solway',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  isLargePhone
                                                                      ? 11.0
                                                                      : 9),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  // Positioned(
                                                  //   bottom: isLargePhone ? 0 : 0,
                                                  //   right: 55,
                                                  //   child: Row(
                                                  //     mainAxisAlignment:
                                                  //         MainAxisAlignment
                                                  //             .center,
                                                  //     children: [
                                                  //       Stack(children: [
                                                  //         Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                     .all(4.0),
                                                  //             child: members
                                                  //                         .length >
                                                  //                     1
                                                  //                 ? CircleAvatar(
                                                  //                     radius:
                                                  //                         25.0,
                                                  //                     backgroundImage:
                                                  //                         NetworkImage(
                                                  //                       course[1][
                                                  //                           'photoUrl'],
                                                  //                     ),
                                                  //                   )
                                                  //                 : Container()),
                                                  //         Padding(
                                                  //             padding:
                                                  //                 const EdgeInsets
                                                  //                         .only(
                                                  //                     top: 4,
                                                  //                     left: 25.0),
                                                  //             child: CircleAvatar(
                                                  //               radius: 25.0,
                                                  //               backgroundImage:
                                                  //                   NetworkImage(
                                                  //                 course[0][
                                                  //                     'photoUrl'],
                                                  //               ),
                                                  //             )),
                                                  //         Padding(
                                                  //           padding:
                                                  //               const EdgeInsets
                                                  //                       .only(
                                                  //                   top: 4,
                                                  //                   left: 50.0),
                                                  //           child: CircleAvatar(
                                                  //             radius: 25.0,
                                                  //             child:
                                                  //                 members.length >
                                                  //                         2
                                                  //                     ? Text(
                                                  //                         "+" +
                                                  //                             (length.toString()),
                                                  //                         style: TextStyle(
                                                  //                             color:
                                                  //                                 TextThemes.ndGold,
                                                  //                             fontWeight: FontWeight.w500),
                                                  //                       )
                                                  //                     : Text(
                                                  //                         (members
                                                  //                             .length
                                                  //                             .toString()),
                                                  //                         style: TextStyle(
                                                  //                             color:
                                                  //                                 TextThemes.ndGold,
                                                  //                             fontWeight: FontWeight.w500),
                                                  //                       ),
                                                  //             backgroundColor:
                                                  //                 TextThemes
                                                  //                     .ndBlue,
                                                  //           ),
                                                  //         ),
                                                  //       ])
                                                  //     ],
                                                  //   ),
                                                  // ),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : Container();
                        }),
                  ),
                  height: noHeight ? 0 : 100,
                  width: noHeight ? 0 : MediaQuery.of(context).size.width * .74,
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

                _image != null
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: 125,
                            width: MediaQuery.of(context).size.width * .8,
                            child: Center(
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child:
                                          Image.file(_image, fit: BoxFit.cover),
                                    ))),
                          ),
                          GestureDetector(
                              onTap: () => selectImage(context),
                              child: Icon(Icons.camera_alt))
                        ]),
                      )
                    : RaisedButton(
                        color: TextThemes.ndBlue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Upload Image/GIF',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        onPressed: () => selectImage(context)),
                noImage == true && _image == null
                    ? Text(
                        "No pic, no fun.",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(
                    padding: EdgeInsets.only(bottom: 40.0, top: 15),
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
                                    maxWidth: 125.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Post!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              // for (int i = 0;
                              //     i < inviteesNameList.length;
                              //     i++) {
                              //   if (!_isNumeric(inviteesNameList[i]) &&
                              //       inviteesNameList.length > 0) {
                              //     final DocumentSnapshot result =
                              //         await groupsRef
                              //             .doc(inviteesNameList[i])
                              //             .get();
                              //     result.data()['members'].forEach(
                              //         (element) => groupList.add(element));
                              //   }
                              // }
                              // print(groupList);

                              if (_image == null) {
                                setState(() {
                                  noImage = true;
                                });
                              }
                              if (_formKey.currentState.validate() &&
                                  _image != null) {
                                setState(() {
                                  isUploading = true;
                                });
                              }

                              final GoogleSignInAccount user =
                                  googleSignIn.currentUser;
                              final strUserId = user.id;
                              if (inviteesNameList.length == 0) {
                                print("EMTPY");
                              }
                              if (_formKey.currentState.validate()) {
                                if (_image != null) {
                                  firebase_storage.Reference ref =
                                      firebase_storage.FirebaseStorage.instance
                                          .ref()
                                          .child("images/" +
                                              user.id +
                                              titleController.text);
                                  if (maxOccupancyController.text.isEmpty) {
                                    maxOccupancyInt = 8000000;
                                  }

                                  if (maxOccupancyController.text.isNotEmpty) {
                                    maxOccupancyInt =
                                        int.parse(maxOccupancyController.text);
                                  }
                                  if (venmoController.text.isNotEmpty) {
                                    String x =
                                        venmoController.text.substring(1);
                                    venmoInt = int.parse(x);
                                  }

                                  firebase_storage.UploadTask uploadTask;

                                  uploadTask = ref.putFile(_image);

                                  firebase_storage.TaskSnapshot taskSnapshot =
                                      await uploadTask;
                                  if (uploadTask.snapshot.state ==
                                      firebase_storage.TaskState.success) {
                                    print("added to Firebase Storage");
                                    final String downloadUrl =
                                        await taskSnapshot.ref.getDownloadURL();
                                    Database().createPost(
                                        title: titleController.text,
                                        type: typeDropdownValue,
                                        privacy: privacyDropdownValue,
                                        description: descriptionController.text,
                                        address: addressController.text,
                                        startDate: currentValue,
                                        unix:
                                            currentValue.millisecondsSinceEpoch,
                                        statuses: inviteesNameList,
                                        maxOccupancy: maxOccupancyInt,
                                        venmo: venmoInt,
                                        barcode: barcode,
                                        imageUrl: downloadUrl,
                                        userId: strUserId,
                                        postId: generateRandomString(20),
                                        posterName: currentUser.displayName,
                                        push: push);

                                    Database().betaActivityTracker(
                                        currentUser.displayName,
                                        Timestamp.now(),
                                        "post");
                                    setState(() {
                                      isUploading = false;
                                    });
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

  bool _isNumeric(String result) {
    if (result == null) {
      return false;
    }
    return double.tryParse(result) != null;
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
