import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/main.dart';
import 'package:MOOV/models/user.dart';
import 'package:MOOV/pages/Friends_List.dart';
import 'package:MOOV/pages/contactsPage.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/leaderboard.dart';
import 'package:MOOV/pages/edit_profile.dart';
import 'package:MOOV/pages/notification_feed.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

class ProfilePage extends StatefulWidget {
  User user;
  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var strUserPic = currentUser.photoUrl;
    var userYear = currentUser.year;
    var userDorm = currentUser.dorm;
    var userBio;
    var userHeader = currentUser.header;
    var userFriends = currentUser.friendArray;
    var userMoovs = currentUser.likedMoovs;
    var userGroups = currentUser.friendGroups;
    // var userFriendsLength = "0";
    bool isAmbassador = currentUser.isAmbassador;

    return StreamBuilder(
        stream: Firestore.instance
            .collection('users')
            .document(currentUser.id)
            .snapshots(),
        builder: (context, snapshot) {
          List<dynamic> likedArray;
          dynamic moovId;
          bool isLargePhone = Screen.diagonal(context) > 766;

          if (!snapshot.hasData) return CircularProgressIndicator();
          userBio = snapshot.data['bio'];
          userDorm = snapshot.data['dorm'];
          userHeader = snapshot.data['header'];
          strUserPic = snapshot.data['photoUrl'];
          isAmbassador = snapshot.data['isAmbassador'];
          userFriends = snapshot.data['friendArray'];

          return Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset('lib/assets/ndlogo.png', height: 70),
              ),
              backgroundColor: TextThemes.ndBlue,
              //pinned: true,
              actions: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(5.0),
                  icon: Icon(Icons.insert_chart),
                  color: Colors.white,
                  splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                  onPressed: () {
                    // Implement navigation to leaderboard page here...
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeaderBoardPage()));
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(5.0),
                  icon: Icon(Icons.notifications_active),
                  color: Colors.white,
                  splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationFeed()));
                  },
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.all(5),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'lib/assets/moovblue.png',
                      fit: BoxFit.cover,
                      height: 50.0,
                    ),
                  ],
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(children: [
                Container(
                  height: 130,
                  child: GestureDetector(
                    onTap: () {},
                    child: Stack(children: <Widget>[
                      FractionallySizedBox(
                        widthFactor: isLargePhone ? 1.17 : 1.34,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: userHeader == null
                                ? null
                                : Image.network(
                                    userHeader,
                                    fit: BoxFit.fitWidth,
                                  ),
                          ),
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                Positioned(
                    top: 60,
                    right: 75,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Icon(
                          Icons.edit,
                          size: 35,
                        ))),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditProfile()));
                          },
                          child: CircleAvatar(
                            radius: 55,
                            backgroundColor: TextThemes.ndGold,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: TextThemes.ndBlue,
                              child: CircleAvatar(
                                backgroundImage: (strUserPic == null)
                                    ? AssetImage('images/user-avatar.png')
                                    : NetworkImage(strUserPic),
                                // backgroundImage: NetworkImage(currentUser.photoUrl),
                                radius: 50,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.displayName != ""
                                  ? currentUser.displayName
                                  : "Username not found",
                              style: TextThemes.extraBold,
                            ),
                            isAmbassador
                                ? Image.asset('lib/assets/verif.png',
                                    height: 35)
                                : Text("")
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, bottom: 14.0),
                        child: Text(
                          userYear != "" && userDorm != ""
                              ? userYear + ' in ' + userDorm
                              : "",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: [
                              Text(
                                userMoovs.length == null
                                    ? "0"
                                    : userMoovs.length.toString(),
                                style: TextThemes.extraBold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Next MOOVs   ',
                                  style: TextThemes.bodyText1,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => friendsList(
                                        likedArray, moovId,
                                        userFriends: userFriends)));
                              },
                              child: Column(
                                children: [
                                  Text(
                                    userFriends.length == null
                                        ? "0"
                                        : userFriends.length.toString(),
                                    style: TextThemes.extraBold,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      'Friends',
                                      style: TextThemes.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Text(
                                userGroups.length == null
                                    ? "0"
                                    : userGroups.length.toString(),
                                style: TextThemes.extraBold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  'Friend Groups',
                                  style: TextThemes.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, bottom: 20, top: 10),
                          color: TextThemes.ndBlue,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, bottom: 2, top: 8),
                                child: RichText(
                                  textScaleFactor: 1.75,
                                  text: TextSpan(
                                      style: TextThemes.mediumbody,
                                      children: [
                                        TextSpan(
                                            text: "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w200,
                                                color: TextThemes.ndGold)),
                                      ]),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 35),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: RichText(
                                      textScaleFactor: 1.3,
                                      text: TextSpan(
                                          style: TextThemes.mediumbody,
                                          children: [
                                            TextSpan(
                                                text: "\"" + userBio + "\"",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontStyle:
                                                        FontStyle.italic)),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: SeeContactsButton(),
                          ),
                          FocusedMenuHolder(
                            menuWidth: MediaQuery.of(context).size.width * 0.5,
                            blurSize: 5.0,
                            menuItemExtent: 45,
                            menuBoxDecoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            duration: Duration(milliseconds: 100),
                            animateMenuItems: true,
                            blurBackgroundColor: Colors.black54,
                            openWithTap:
                                true, // Open Focused-Menu on Tap rather than Long Press
                            menuOffset:
                                10.0, // Offset value to show menuItem from the selected item
                            bottomOffsetHeight:
                                80.0, // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
                            menuItems: <FocusedMenuItem>[
                              // Add Each FocusedMenuItem  for Menu Options

                              FocusedMenuItem(
                                  title: Text("Edit Profile"),
                                  trailingIcon: Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => EditProfile()));
                                  }),
                              // FocusedMenuItem(
                              //     title: Text("Invite Contacts"),
                              //     trailingIcon: Icon(Icons.contact_mail),
                              //     onPressed: () {
                              //       Navigator.push(
                              //           context,
                              //           MaterialPageRoute(
                              //               builder: (context) => ContactsPage()));
                              //     }),
                              // FocusedMenuItem(
                              //     title: Text("Share MOOV"),
                              //     trailingIcon: Icon(Icons.send),
                              //     onPressed: () {}),

                              FocusedMenuItem(
                                  title: Text(
                                    "Sign Out",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  trailingIcon: Icon(
                                    Icons.directions_walk,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    showAlertDialog(context);
                                  }),
                            ],
                            onPressed: () {},
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 18.0, top: 8),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Icon(Icons.more_vert,
                                            color: Colors.white),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 15.0),
                                            child: Text(
                                              "Settings",
                                              style: TextStyle(
                                                  fontSize: 20, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  width: MediaQuery.of(context).size.width * .4,
                                  height: 50,
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    gradient: LinearGradient(
                                      colors: [Colors.pink[300], Colors.pink[200]],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ]),
            ),
          );
        });
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text("Sign out?",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        content: Text("\nWhere you goin'?"),
        actions: [
          CupertinoDialogAction(
              isDefaultAction: true,
              child:
                  Text("Yes, sign me out", style: TextStyle(color: Colors.red)),
              onPressed: () {
                googleSignIn.signOut();
                Navigator.of(context).pop(true);
              }),
          CupertinoDialogAction(
            child: Text("Nah, my mistake"),
            onPressed: () => Navigator.of(context).pop(true),
          )
        ],
      ),
    );
  }
}
