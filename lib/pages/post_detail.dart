import 'dart:developer';
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/widgets/frosted_appbar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:MOOV/pages/Going_event.dart';

class PostDetail extends StatefulWidget {
  String bannerImage,
      title,
      description,
      location,
      profilePic,
      userName,
      userEmail;
  dynamic startDate, address, moovId;
  List<dynamic> likedArray;
  PostDetail(
      this.bannerImage,
      this.title,
      this.description,
      this.startDate,
      this.location,
      this.address,
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
        this.location,
        this.address,
        this.profilePic,
        this.userName,
        this.userEmail,
        this.likedArray,
        this.moovId);
  }
}

class _PostDetailState extends State<PostDetail> {
  String bannerImage,
      title,
      description,
      location,
      profilePic,
      userName,
      userEmail;
  dynamic startDate, address, moovId;
  List<dynamic> likedArray;
  _PostDetailState(
      this.bannerImage,
      this.title,
      this.description,
      this.startDate,
      this.location,
      this.address,
      this.profilePic,
      this.userName,
      this.userEmail,
      this.likedArray,
      this.moovId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
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
        body: SafeArea(
      top: false,
      child: Stack(children: [
        Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              _BannerImage(bannerImage),
              _NonImageContents(
                  title,
                  description,
                  startDate,
                  address,
                  location,
                  profilePic,
                  userName,
                  userEmail,
                  likedArray,
                  moovId),
            ],
          ),
        ),
        // FrostedAppBar(
        //   blurStrengthX: 20,
        //   blurStrengthY: 20,
        //   leading: IconButton(
        //     icon: Icon(
        //       Icons.arrow_back,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       Navigator.pop(
        //         context,
        //         MaterialPageRoute(builder: (context) => HomePage()),
        //       );
        //     },
        //   ),
        //   title: Center(
        //       child: Image.asset(
        //     'lib/assets/moovlogo2.png',
        //     height: 50,
        //   )),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: IconButton(
        //         icon: Icon(
        //           Icons.list,
        //           color: Colors.white,
        //         ),
        //         onPressed: () {},
        //       ),
        //     )
        //   ],
        //   height: 120,
        // ),
      ]),
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
            fit: BoxFit.fitWidth,
            height: 200,
            width: double.infinity,
          ),
        ),
      ),
    ]);
  }
}

class _NonImageContents extends StatelessWidget {
  String title, description, location, profilePic, userName, userEmail;
  dynamic startDate, address, moovId;
  List<dynamic> likedArray;

  _NonImageContents(
      this.title,
      this.description,
      this.startDate,
      this.location,
      this.address,
      this.profilePic,
      this.userName,
      this.userEmail,
      this.likedArray,
      this.moovId);

  @override
  Widget build(BuildContext context) {
    return Container(
      //  margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _Title(title),
          _Description(description),
          PostTimeAndPlace(startDate, address, location),
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
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Icon(Icons.directions_run, color: Colors.green),
                ),
                Text(
                  'Going',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          GoingPage(likedArray, moovId),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  String title;
  _Title(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextThemes.headline1,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  String description;
  _Description(this.description);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 15.0),
      child: Center(
        child: Text(
          description,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class PostTimeAndPlace extends StatelessWidget {
  dynamic startDate, address;
  String location;

  PostTimeAndPlace(this.startDate, this.location, this.address);

  @override
  Widget build(BuildContext context) {
    final TextStyle timeTheme = TextThemes.dateStyle;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                child: Icon(Icons.timer, color: TextThemes.ndGold),
              ),
              Text('WHEN: ', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                DateFormat('MMMd').add_jm().format(startDate.toDate()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                  child: Icon(
                    Icons.place,
                    color: TextThemes.ndGold,
                  ),
                ),
                Text('WHERE: ', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(address)
              ],
            ),
          )
        ],
      ),
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
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(userName,
                      style: TextStyle(
                          fontSize: 14,
                          color: TextThemes.ndBlue,
                          decoration: TextDecoration.none)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
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
                  Icon(Icons.group_add, color: TextThemes.ndBlue),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
