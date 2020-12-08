import 'dart:convert';

import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/widgets/segmented_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class FoodFeed extends StatefulWidget {
  FoodFeed({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FoodFeedState createState() => _FoodFeedState();
}

class _FoodFeedState extends State<FoodFeed> {
  bool _isPressed; // = false;

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;

    /*final DateTime nows = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(nows);
    print(formatted);

    final format = DateFormat("EEE, MMM d,' at' h:mm a");
    DateTime now = DateTime.now();
    String updatedDt = format.format(now);
    print(updatedDt);*/

    //   var now = new DateTime.now();
    //   var updatedDt = now.millisecondsSinceEpoch;
    //   print(updatedDt);

    // .where("endDate", isGreaterThanOrEqualTo: updatedDt)
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TextThemes.ndBlue,
          title: Text(
            'FOOD & DRINKS',
            style: TextStyle(color: Color(0xffFFFFFF)),
          ),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 26.0,
            ),
          ),
          //pinned: true,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(Icons.search),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () {
                // Implement navigation to shopping cart page here...
                print('Click Search');
              },
            ),
            IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(Icons.notifications_active),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () {
                // Implement navigation to shopping cart page here...
                print('Click Message');
              },
            ),
          ],
        ),
        body: SegmentedControl()
        // StreamBuilder(
        //     stream: Firestore.instance
        //         .collection('food')
        //         .where("type", isEqualTo: "Food")
        //         .orderBy("startDate")
        //         .snapshots(),
        //     builder: (context, snapshot) {
        //       if (!snapshot.hasData) return Text('Loading data...');
        //
        //       return ListView.builder(
        //         itemCount: snapshot.data.documents.length,
        //         itemBuilder: (context, index) {
        //           DocumentSnapshot course = snapshot.data.documents[index];
        //           // DateTime now=DateTime.now();
        //          // print(course['startDate']);
        //           print(course['endDate']);
        //           var date1 = course['endDate'].toDate();
        //           //  String formattedDate = DateFormat.MMMMd().format(date1);
        //           DateTime yesterday = date1.subtract(Duration(days: 1));
        //           DateTime local = date1.toLocal();
        //         //  print(yesterday);
        //           print("Start11");
        //       //   print(local);
        //           print(date1);
        //           print("Start");
        //           if (date1.day== yesterday.day) {
        //             print(snapshot.data[index]);
        //             print("DATA");
        //           }
        //           List<dynamic> likedArray = course["liked"];
        //           List<String> uidArray = List<String>();
        //           if (likedArray != null) {
        //             likeCount = likedArray.length;
        //             for (int i = 0; i < likeCount; i++) {
        //               var id = likedArray[i]["uid"];
        //               uidArray.add(id);
        //             }
        //           }
        //           else {
        //             likeCount = 0;
        //           }
        //
        //           if (uidArray != null && uidArray.contains(strUserId)) {
        //             _isPressed = true;
        //           } else {
        //             _isPressed = false;
        //           }
        //
        //           return Card(
        //               color: Colors.white,
        //               clipBehavior: Clip.antiAlias,
        //               child: new InkWell(
        //                 onTap: () {
        //                   Navigator.of(context).push(MaterialPageRoute(
        //                       builder: (context) => PostDetail(
        //                           course['image'],
        //                           course['title'],
        //                           course['description'],
        //                           course['startDate'],
        //                           course['profilePic'],
        //                           course['userName'],
        //                           course['userEmail'],
        //                           likedArray,
        //                           course.documentID)));
        //                 },
        //                 child: Column(
        //                   children: [
        //                     ListTile(
        //                       title: Row(children: <Widget>[
        //                         Expanded(
        //                           child: Padding(
        //                             padding: const EdgeInsets.all(5.0),
        //                             child: Container(
        //                               decoration: BoxDecoration(
        //                                   border: Border.all(
        //                                 color: Color(0xff000000),
        //                                 width: 1,
        //                               )),
        //                               child: Image.network(course['image'],
        //                                   fit: BoxFit.cover,
        //                                   height: 130,
        //                                   width: 50),
        //                             ),
        //                           ),
        //                         ),
        //                         Expanded(
        //                             child: Column(children: <Widget>[
        //                           Padding(padding: const EdgeInsets.all(8.0)),
        //                           Padding(
        //                               padding: const EdgeInsets.all(2.0),
        //                               child: Text(course['title'].toString(),
        //                                   style: TextStyle(
        //                                       color: Colors.blue[900],
        //                                       fontSize: 20.0,
        //                                       fontWeight: FontWeight.bold),
        //                                   textAlign: TextAlign.center)),
        //                           Padding(
        //                             padding: const EdgeInsets.all(10.0),
        //                             child: Text(
        //                               course['description'].toString(),
        //                               textAlign: TextAlign.center,
        //                               style: TextStyle(
        //                                   fontSize: 12.0,
        //                                   color:
        //                                       Colors.black.withOpacity(0.6)),
        //                             ),
        //                           ),
        //                           Padding(padding: const EdgeInsets.all(5.0)),
        //                           Padding(
        //                               padding: const EdgeInsets.all(3.0),
        //                               child: Align(
        //                                 alignment: Alignment.bottomRight,
        //                                 child: Text(
        //                                     DateFormat('EEEE, MMM d, yyyy')
        //                                         .format(course['startDate']
        //                                             .toDate()),
        //                                     style: TextStyle(
        //                                         fontSize: 12.0,
        //                                         fontWeight: FontWeight.bold)),
        //                               )),
        //                         ]))
        //                       ]),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 1.0),
        //                       child: Container(
        //                         height: 1.0,
        //                         width: 500.0,
        //                         color: Colors.grey[300],
        //                       ),
        //                     ),
        //                     Container(
        //                         child: Row(
        //                       children: [
        //                         Padding(
        //                             padding: const EdgeInsets.fromLTRB(
        //                                 12, 10, 4, 10),
        //                             child: CircleAvatar(
        //                               radius: 22.0,
        //                               backgroundImage:
        //                                   NetworkImage(course['profilePic']),
        //                               backgroundColor: Colors.transparent,
        //                             )),
        //                         Container(
        //                           child: Column(
        //                             //  mainAxisAlignment: MainAxisAlignment.start,
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.start,
        //                             children: [
        //                               Padding(
        //                                 padding:
        //                                     const EdgeInsets.only(left: 2.0),
        //                                 child: Text(course['userName'],
        //                                     style: TextStyle(
        //                                         fontSize: 14,
        //                                         color: TextThemes.ndBlue,
        //                                         decoration:
        //                                             TextDecoration.none)),
        //                               ),
        //                               Padding(
        //                                 padding:
        //                                     const EdgeInsets.only(left: 2.0),
        //                                 child: Text(course['userEmail'],
        //                                     style: TextStyle(
        //                                         fontSize: 12,
        //                                         color: TextThemes.ndBlue,
        //                                         decoration:
        //                                             TextDecoration.none)),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                         Spacer(),
        //                         Container(
        //                           child: Column(
        //                             //  mainAxisAlignment: MainAxisAlignment.start,
        //                             crossAxisAlignment:
        //                                 CrossAxisAlignment.end,
        //                             children: [
        //                               Padding(
        //                                 padding:
        //                                     const EdgeInsets.only(right: 6.0),
        //                                 child: IconButton(
        //                                   icon: (_isPressed)
        //                                       ? new Icon(Icons.favorite)
        //                                       : new Icon(
        //                                           Icons.favorite_border),
        //                                   color: Colors.pink,
        //                                   iconSize: 24.0,
        //                                   splashColor: Colors.pink,
        //                                   // splashRadius: 7.0,
        //                                   highlightColor: Colors.pink,
        //                                   onPressed: () {
        //                                     // Perform action
        //                                     setState(() {
        //                                       List<dynamic> likedArray =
        //                                           course["liked"];
        //                                       List<String> uidArray =
        //                                           List<String>();
        //                                       if (likedArray != null) {
        //                                         likeCount = likedArray.length;
        //                                         for (int i = 0;
        //                                             i < likeCount;
        //                                             i++) {
        //                                           var id =
        //                                               likedArray[i]["uid"];
        //                                           uidArray.add(id);
        //                                         }
        //                                       }
        //
        //                                       if (uidArray != null &&
        //                                           uidArray
        //                                               .contains(strUserId)) {
        //                                         Database().removeGoing(
        //                                             strUserId,
        //                                             course.documentID,
        //                                             strUserName,
        //                                             strUserPic);
        //                                       } else {
        //                                         Database()
        //                                             .addGoing(
        //                                                 strUserId,
        //                                                 course.documentID,
        //                                                 strUserName,
        //                                                 strUserPic);
        //                                       }
        //                                     });
        //                                   },
        //                                 ),
        //                               ),
        //                               Padding(
        //                                 padding: const EdgeInsets.fromLTRB(
        //                                     0, 0, 24.0, 10),
        //                                 child: Text('$likeCount',
        //                                     style: TextStyle(
        //                                         fontSize: 12,
        //                                         color: TextThemes.ndBlue,
        //                                         decoration:
        //                                             TextDecoration.none)),
        //                               ),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     )),
        //                     /*ButtonBar(
        //                    alignment: MainAxisAlignment.end,
        //                    children: [
        //                      FlatButton(
        //                        textColor: const Color(0xFF6200EE),
        //                        onPressed: () {
        //                          // Perform some action
        //                        },
        //                        child: Padding(
        //                            padding: const EdgeInsets.all(2.0),
        //                            child: Text("WHO'S GOING?",
        //                                style: TextStyle(
        //                                    color: Colors.blue[500],
        //                                    fontSize: 15.0,
        //                                    fontWeight: FontWeight.bold),
        //                                textAlign: TextAlign.left)),
        //                      ),
        //                      FlatButton(
        //                        textColor: const Color(0xFF6200EE),
        //                        onPressed: () {
        //                          // Perform some action
        //                        },
        //                        child: IconButton(
        //                          icon: (_isPressed)
        //                              ? new Icon(Icons.favorite)
        //                              : new Icon(Icons.favorite_border),
        //                          color: Colors.pink,
        //                          iconSize: 24.0,
        //                          splashColor: Colors.pink,
        //                          splashRadius: 7.0,
        //                          highlightColor: Colors.pink,
        //                          onPressed: () {
        //                            // Perform action
        //                            setState(() {
        //                              List<dynamic> likedArray = course["liked"];
        //                              if (likedArray != null && likedArray.contains(strUserId)) {
        //                                Database().removeGoing(strUserId, course.documentID);
        //                              } else {
        //                                Database().addLike(strUserId, course.documentID);
        //                              }
        //
        //                            });
        //                          },
        //                        ),
        //                      )
        //                    ],
        //                  ),*/
        //                   ],
        //                 ),
        //               ));
        //         },
        //       );
        //     }),
        );
  }
}
