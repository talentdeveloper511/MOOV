import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetail extends StatefulWidget {
  String bannerImage, title, description, profilePic, userName, userEmail;
  dynamic startDate, moovId;
  List<dynamic> likedArray;
  PostDetail(
      this.bannerImage,
      this.title,
      this.description,
      this.startDate,
      this.profilePic,
      this.userName,
      this.userEmail,
      this.likedArray,
      this.moovId);

  @override
  State<StatefulWidget> createState() {
    return _PostDetailState(
        this.bannerImage,
        this.title,
        this.description,
        this.startDate,
        this.profilePic,
        this.userName,
        this.userEmail,
        this.likedArray,
        this.moovId);
  }
}

class _PostDetailState extends State<PostDetail> {
  String bannerImage, title, description, profilePic, userName, userEmail;
  dynamic startDate, moovId;
  List<dynamic> likedArray;
  _PostDetailState(
      this.bannerImage,
      this.title,
      this.description,
      this.startDate,
      this.profilePic,
      this.userName,
      this.userEmail,
      this.likedArray,
      this.moovId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TextThemes.ndBlue,
          title: Text(
            title,
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
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(Icons.search),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () {
                print('Click Search');
              },
            ),
            IconButton(
              padding: EdgeInsets.all(5.0),
              icon: Icon(Icons.notifications_active),
              color: Colors.white,
              splashColor: Color.fromRGBO(220, 180, 57, 1.0),
              onPressed: () {
                print('Click Message');
              },
            ),
          ],
        ),
        body: Container(
          color: const Color(0x50D7D7D7),
          child: ListView(
            children: <Widget>[
              _BannerImage(bannerImage),
              _NonImageContents(description, startDate, profilePic, userName,
                  userEmail, likedArray, moovId),
            ],
          ),
        ));
  }
}

class _BannerImage extends StatelessWidget {
  String bannerImage;
  _BannerImage(this.bannerImage);

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      ClipRRect(
        child: Container(
          margin:
              const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Image.network(
            bannerImage,
            fit: BoxFit.fill,
            height: 200,
            width: double.infinity,
          ),
        ),
      ),
    ]);
  }
}

class _NonImageContents extends StatelessWidget {
  String description, profilePic, userName, userEmail;
  dynamic startDate, moovId;
  List<dynamic> likedArray;

  _NonImageContents(this.description, this.startDate, this.profilePic,
      this.userName, this.userEmail, this.likedArray, this.moovId);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Summary(description),
          PostTimeStamp(startDate),
          _AuthorContent(profilePic, userName, userEmail),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.0),
            child: Container(
              height: 1.0,
              width: 500.0,
              color: Colors.grey[700],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Text(
              'Going',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 20.0, color: Colors.black.withOpacity(0.6)),
            ),
          ),
          GoingPage(likedArray, moovId),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  String description;
  _Summary(this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(
          description,
          textAlign: TextAlign.center,
          style: TextThemes.headline1,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class PostTimeStamp extends StatelessWidget {
  dynamic startDate;

  PostTimeStamp(this.startDate);

  @override
  Widget build(BuildContext context) {
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(DateFormat('EEEE, MMM d, yyyy').format(startDate.toDate()),
          style: timeTheme),
    );
  }
}

class _AuthorContent extends StatelessWidget {
  String profilePic, userName, userEmail;
  _AuthorContent(this.profilePic, this.userName, this.userEmail);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
          child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
              child: CircleAvatar(
                radius: 22.0,
                backgroundImage: NetworkImage(profilePic),
                backgroundColor: Colors.transparent,
              )),
          Container(
            child: Column(
              //  mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(userName,
                      style: TextStyle(
                          fontSize: 14,
                          color: TextThemes.ndBlue,
                          decoration: TextDecoration.none)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Text(userEmail,
                      style: TextStyle(
                          fontSize: 12,
                          color: TextThemes.ndBlue,
                          decoration: TextDecoration.none)),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(Icons.people_outline, color: TextThemes.ndBlue),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}

class GoingPage extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId;
  GoingPage(this.likedArray, this.moovId);

  @override
  Widget build(BuildContext context) {
    /*Going exercise;
    Set setInst;
    Firestore.instance.collection("food").document(moovId).get().then((docSnapshot) => {
      exercise = Going.fromMap(docSnapshot.data),
      exercise.liked.forEach((set) {
        setInst = set as Set;
        log("Name :" + setInst.strName.toString());
        log("pic :" + setInst.strPic.toString());
      })
    });*/

    return likedArray != null
        ? ListView.builder(
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
                                    backgroundImage: NetworkImage(
                                        likedArray[index]['strPic']),
                                    backgroundColor: Colors.transparent,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 22.0),
                              child: Text(likedArray[index]['strName'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: TextThemes.ndBlue,
                                      decoration: TextDecoration.none)),
                            ),
                          ],
                        )),
                  ],
                ),
              );
            })
        : Center(
            child: Image.asset(
            'lib/assets/chens.jpg',
            height: 40,
          ));
  }
}
