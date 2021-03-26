import 'dart:math';

import 'package:MOOV/main.dart';
import 'package:MOOV/pages/EditArchive.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/archiveDetail.dart';
import 'package:MOOV/pages/edit_post.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/going_statuses.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:worm_indicator/indicator.dart';
import 'package:worm_indicator/shape.dart';

class Biz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BizState();
  }
}

class _BizState extends State<Biz> {
  PageController _goingController, _againController;
  int pageNumber = 0;

  @override
  void initState() {
    super.initState();
    _goingController = PageController();
    _againController = PageController();
  }

  _onPageViewChange(int page) {
    setState(() {
      pageNumber = page;
    });
  }

  Widget buildPageView(snapshot, count, PageController controller) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    return PageView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      controller: controller,
      onPageChanged: _onPageViewChange,
      itemBuilder: (BuildContext context, int pos) {
        DocumentSnapshot course = snapshot.data.docs[pos];
        return Container(
          margin: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                // width: width * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: isLargePhone ? 120 : 100,
                        child: OpenContainer(
                          transitionType: ContainerTransitionType.fade,
                          transitionDuration: Duration(milliseconds: 500),
                          openBuilder: (context, _) =>
                              ArchiveDetail(course['postId']),
                          closedElevation: 0,
                          closedBuilder: (context, _) =>
                              Stack(children: <Widget>[
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: Container(
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: course['image'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  alignment: Alignment(0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: <Color>[
                                          Colors.black.withAlpha(0),
                                          Colors.black,
                                          Colors.black12,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        course['title'],
                                        style: TextStyle(
                                            fontFamily: 'Solway',
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 5,
                                top: 5,
                                child: EditButton(course['postId']))
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: count,
    );
  }

  Widget buildSuggestionsIndicatorWithShapeAndBottomPos(
      Shape shape, double bottomPos, count, controller) {
    return Positioned(
      bottom: bottomPos,
      left: 0,
      right: 0,
      child: WormIndicator(
        length: count,
        controller: controller,
        shape: shape,
      ),
    );
  }

  final format = DateFormat("EEE, MMM d,' at' h:mm a");
  bool isUploading = false;
  bool needDate = false;
  DateTime currentValue = DateTime.now();
  DateTime currentValues;
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    bool isLargePhone = Screen.diagonal(context) > 766;

    int status = 0;
    final circleShape = Shape(
      size: 8,
      shape: DotShape.Circle,
      spacing: 8,
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(children: [
          StreamBuilder(
              stream: postsRef
                  .where("userId", isEqualTo: currentUser.id)
                  // .orderBy("startDate")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Container();
                }
                if (snapshot.data.docs.length == 0) {
                  return Container();
                }
                int count = snapshot.data.docs.length;

                for (int i = 0; i < count; i++) {
                  DocumentSnapshot course = snapshot.data.docs[pageNumber];

                  return Container(
                      height: isLargePhone
                          ? MediaQuery.of(context).size.height * .45
                          : MediaQuery.of(context).size.height * .4,
                      child: Column(children: [
                        SizedBox(height: isLargePhone ? 20 : 10),
                        Container(
                            height: 20,
                            child: Center(
                              child: GradientText(
                                "Your Going Lists",
                                gradient: LinearGradient(colors: [
                                  Colors.blue.shade400,
                                  Colors.blue.shade900,
                                ]),
                              ),
                            )),
                        Container(
                          height: isLargePhone ? 160 : 145,
                          child: Stack(
                            children: <Widget>[
                              buildPageView(snapshot, count, _goingController),
                              buildSuggestionsIndicatorWithShapeAndBottomPos(
                                  circleShape,
                                  isLargePhone ? 0 : 10,
                                  count,
                                  _goingController),
                            ],
                          ),
                        ),
                        isLargePhone
                            ? SizedBox(
                                height: 6,
                              )
                            : Container(),
                        Expanded(
                          child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: GoingPage(course['postId'])),
                        )
                      ]));
                }
              }),
          (isUploading)
              ? circularProgress()
              : ExpandablePanel(
                 theme: const ExpandableThemeData(
                   tapHeaderToExpand: true,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                  header: Text("HI"),
                expanded: StreamBuilder(
                      stream: archiveRef
                          .where("userId", isEqualTo: currentUser.id)
                          .snapshots(),
                      builder: (context, snapshot2) {
                        if (!snapshot2.hasData || snapshot2.data == null) {
                          return Container();
                        }
                        int count = snapshot2.data.docs.length;

                        for (int i = 0; i < count; i++) {
                          DocumentSnapshot course2 = snapshot2.data.docs[i];

                          return Container(
              height: isLargePhone
                  ? MediaQuery.of(context).size.height / 3.9
                  : MediaQuery.of(context).size.height / 2.75,
              child: Column(children: [
                SizedBox(height: isLargePhone ? 10 : 10),
                Center(
                  child: GradientText(
                    "Post Again",
                    gradient: LinearGradient(colors: [
                      Colors.blue.shade400,
                      Colors.blue.shade900,
                    ]),
                  ),
                ),
                Container(
                  height: isLargePhone ? 150 : 140,
                  child: Stack(
                    children: <Widget>[
                      buildPageView(
                          snapshot2, count, _againController),
                      buildSuggestionsIndicatorWithShapeAndBottomPos(
                          circleShape,
                          isLargePhone ? 0 : 10,
                          count,
                          _againController),
                    ],
                  ),
                ),
                SizedBox(height: 7),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 300,
                        child: DateTimeField(
                          format: format,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              icon: Icon(Icons.timelapse,
                                  color: TextThemes.ndGold),
                              suffixIcon: Icon(
                                Icons.calendar_today,
                                color: needDate
                                    ? Colors.red
                                    : TextThemes.ndGold,
                              ),
                              labelText: 'Enter Start Time',
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10.0)),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always),
                          onChanged: (DateTime newValue) {
                            setState(() {
                              currentValue =
                                  currentValues; // = newValue;
                              //   newValue = currentValue;
                            });
                          },
                          onShowPicker:
                              (context, currentValue) async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2021),
                              initialDate:
                                  currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context,
                                  Widget child) {
                                return Theme(
                                  data: ThemeData.light().copyWith(
                                    primaryColor: TextThemes.ndGold,
                                    accentColor: TextThemes.ndGold,
                                    colorScheme: ColorScheme.light(
                                        primary: TextThemes.ndBlue),
                                    buttonTheme: ButtonThemeData(
                                        textTheme: ButtonTextTheme
                                            .primary),
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
                                builder: (BuildContext context,
                                    Widget child) {
                                  return Theme(
                                    data:
                                        ThemeData.light().copyWith(
                                      primaryColor:
                                          TextThemes.ndGold,
                                      accentColor:
                                          TextThemes.ndGold,
                                      colorScheme:
                                          ColorScheme.light(
                                              primary: TextThemes
                                                  .ndBlue),
                                      buttonTheme: ButtonThemeData(
                                          textTheme: ButtonTextTheme
                                              .primary),
                                    ),
                                    child: child,
                                  );
                                },
                              );
                              currentValues =
                                  DateTimeField.combine(date, time);
                              return currentValues;
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();

                            if (DateTime.now()
                                    .subtract(Duration(hours: 1))
                                    .isBefore(currentValue) &&
                                DateTime.now()
                                    .add(Duration(hours: 1))
                                    .isAfter(currentValue)) {
                              setState(() {
                                needDate = true;
                              });
                            } else {
                              setState(() {
                                isUploading = true;
                              });
                              final GoogleSignInAccount user =
                                  googleSignIn.currentUser;
                              final strUserId = user.id;
                              print("here");

                              currentUser.isBusiness
                                  ? Database().createBusinessPost(
                                      title: course2['title'],
                                      type: course2['type'],
                                      privacy: course2['privacy'],
                                      description:
                                          course2['description'],
                                      address: course2['address'],
                                      startDate: currentValue,
                                      unix: currentValue
                                          .millisecondsSinceEpoch,
                                      statuses: course2['statuses'],
                                      maxOccupancy:
                                          course2['maxOccupancy'],
                                      venmo: course2['venmo'],
                                      imageUrl: course2['image'],
                                      userId: course2['userId'],
                                      postId:
                                          generateRandomString(20),
                                      posterName:
                                          currentUser.displayName,
                                      push: course2['push'])
                                  : Database().createPost(
                                      title: course2['title'],
                                      type: course2['type'],
                                      privacy: course2['privacy'],
                                      description:
                                          course2['description'],
                                      address: course2['address'],
                                      startDate: currentValue,
                                      unix: currentValue
                                          .millisecondsSinceEpoch,
                                      statuses: course2['statuses'],
                                      maxOccupancy:
                                          course2['maxOccupancy'],
                                      venmo: course2['venmo'],
                                      imageUrl: course2['image'],
                                      userId: course2['userId'],
                                      postId:
                                          generateRandomString(20),
                                      posterName:
                                          currentUser.displayName,
                                      push: course2['push']);

                              setState(() {
                                isUploading = false;
                              });
                            }
                          },
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue[400],
                                    Colors.blue[300]
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius:
                                    BorderRadius.circular(10.0)),
                            child: Text(
                              "Post!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]));
                        }
                        return Container();
                      }),
                )
        ]));
  }
}

class QuickPost extends StatefulWidget {
  QuickPost({Key key}) : super(key: key);

  @override
  _QuickPostState createState() => _QuickPostState();
}

class _QuickPostState extends State<QuickPost> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: archiveRef.where("userId", isEqualTo: currentUser.id).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Container(
              height: 100,
              child: Center(
                  child: Text(
                "Post yoccur",
                style: TextStyle(
                    color: TextThemes.ndBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              )),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (_, index) {
                if (snapshot.data.docs.length == 0) {
                  return Container(
                    height: 100,
                    child: Center(
                        child: Text(
                      "Post yoccur",
                      style: TextStyle(
                          color: TextThemes.ndBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    )),
                  );
                }
                DocumentSnapshot course = snapshot.data.docs[index];

                return Container(
                  alignment: Alignment.center,
                  // width: width * 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: OpenContainer(
                            transitionType: ContainerTransitionType.fade,
                            transitionDuration: Duration(milliseconds: 500),
                            openBuilder: (context, _) =>
                                ArchiveDetail(course['postId']),
                            closedElevation: 0,
                            closedBuilder: (context, _) =>
                                Stack(children: <Widget>[
                              FractionallySizedBox(
                                widthFactor: 1,
                                child: Container(
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: course['image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    alignment: Alignment(0.0, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: <Color>[
                                            Colors.black.withAlpha(0),
                                            Colors.black,
                                            Colors.black12,
                                          ],
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          course['title'],
                                          style: TextStyle(
                                              fontFamily: 'Solway',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

class EditButton extends StatelessWidget {
  String postId;
  EditButton(this.postId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EditArchive(postId))),
      child: Container(
        height: 45,
        width: 70,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.red[300],
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Edit",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
