import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:MOOV/helpers/themes.dart';

import 'ProfilePage.dart';
import 'notification_details.dart';

class NotificationPage extends StatefulWidget {
  dynamic moovId;
  List<dynamic> likedArray;

  NotificationPage(this.moovId, this.likedArray);

  @override
  _NotificationState createState() {
    return _NotificationState(this.moovId, this.likedArray);
  }
}

class _NotificationState extends State<NotificationPage> {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;

  _NotificationState(this.moovId, this.likedArray);

  Container buildNoContent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(

      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.search),
            
            Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontSize: 60.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true, //MUST TO ADDED
            physics: NeverScrollableScrollPhysics(),
            itemCount: likedArray.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  children: [
                    Container(
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: TextThemes.ndBlue,
                                  child: CircleAvatar(
                                    radius: 22.0,
                                    backgroundImage:
                                    NetworkImage(likedArray[index]['strPic']),
                                    backgroundColor: Colors.transparent,
                                  )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(likedArray[index]['strName']+" has sent you a friend request",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: TextThemes.ndBlue,
                                      decoration: TextDecoration.none)),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: RaisedButton(
                                padding: const EdgeInsets.all(2.0),
                                color: TextThemes.ndBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                                onPressed: () {
                                  if(likedArray[index]['uid'] == moovId){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder:(context)=>ProfilePage()
                                        )
                                    );
                                  } else {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder:(context)=>NotificationDetails(likedArray[index]['strPic'],
                                                likedArray[index]['strName'], likedArray[index]['uid'],
                                                likedArray[index]['strName'], likedArray[index]['strName'])
                                        )
                                    );
                                  }
                                },
                                child: Text("View Detail",
                                  style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ),
              );
            }),
        Container(child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            children: [
              Container(
                  color: Colors.grey[300],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: CircleAvatar(
                            radius: 22,
                            backgroundColor: TextThemes.ndBlue,
                            child: CircleAvatar(
                              radius: 22.0,
                              backgroundImage:
                              AssetImage('lib/assets/me.jpg'),
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text("Heena Dhawan has Created Food Event",
                            style: TextStyle(
                                fontSize: 12,
                                color: TextThemes.ndBlue,
                                decoration: TextDecoration.none)),
                      ),
                      Spacer(),
                    ],
                  )),
            ],
          ),
        ),)
      ],);
  }

  void getNotificationList() async {
    Firestore.instance.collection("users").document(moovId).get().then((docSnapshot) => {
      likedArray = docSnapshot.data['request'],
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  //  getNotificationList();
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: TextThemes.ndBlue,
    //     title: Text('Notification',
    //       style: TextStyle(color: Color(0xffFFFFFF)),
    //     ),
    //     leading: InkWell(
    //       onTap: () => Navigator.of(context).pop(),
    //       child: Icon(
    //         Icons.arrow_back,
    //         color: Colors.white,
    //         size: 26.0,
    //       ),
    //     ),
    //   ),
    //   body: likedArray == null ? buildNoContent() : buildSearchResults(),
    // );

   /* return Scaffold(



      body: userList != null
          ? ListView.builder(
          shrinkWrap: true, //MUST TO ADDED
          physics: NeverScrollableScrollPhysics(),
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                children: [
                  Container(
                      color: Colors.grey[300],
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: CircleAvatar(
                                radius: 22,
                                backgroundColor: TextThemes.ndBlue,
                                child: CircleAvatar(
                                  radius: 22.0,
                                  backgroundImage:
                                  NetworkImage(userList[index]['strPic']),
                                  backgroundColor: Colors.transparent,
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22.0),
                            child: Text(userList[index]['strName'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: TextThemes.ndBlue,
                                    decoration: TextDecoration.none)),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: RaisedButton(
                              padding: const EdgeInsets.all(2.0),
                              color: TextThemes.ndBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(3.0))),
                              onPressed: () {
                                 if(userList[index]['uid'] == moovId){
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:(context)=>ProfilePage()
                                    )
                                );
                              } else {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder:(context)=>NotificationDetails(userList[index]['strPic'],
                                            userList[index]['strName'], userList[index]['uid'],
                                            userList[index]['strName'], userList[index]['strName'])
                                    )
                                );
                              }
                              },
                              child: Text("View Detail",
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            );
          })
          : Center(child: Image.asset('lib/assets/chens.jpg', height: 40,)),
    );*/
  }
}

class UserResult extends StatelessWidget {
  final User user;
  final List<dynamic> likedArray;

  UserResult(this.user, this.likedArray);

  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount userMe = googleSignIn.currentUser;
    final strUserId = userMe.id;
    return Container(

      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => print('tapped'),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl),
              ),
              title: Text(
                user.displayName,
                style:
                TextStyle(color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
              trailing: RaisedButton(
                padding: const EdgeInsets.all(2.0),
                color: TextThemes.ndBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3.0))),
                onPressed: () {

                  if(user.id == strUserId){
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder:(context)=>ProfilePage()
                        )
                    );
                  }
                  else {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder:(context)=>NotificationDetails(user.photoUrl,
                                user.displayName, user.id,
                                user.email, user.username)
                        )
                    );
                  }
                },
                child: Text("View Detail",
                  style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                ),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }
}
