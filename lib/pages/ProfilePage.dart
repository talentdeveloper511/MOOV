import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/contacts_button.dart';
import 'package:MOOV/widgets/friend_groups_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/notification_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  final Home user;
  ProfilePage({Key key, this.user}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    final strUserId = user.id;
    final strUserName = user.displayName;
    final strUserPic = user.photoUrl;
    dynamic likeCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TextThemes.ndBlue,
        //pinned: true,
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.insert_chart),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              // Implement navigation to shopping cart page here...
              print('Leaderboards clicked');
            },
          ),
          IconButton(
            padding: EdgeInsets.all(5.0),
            icon: Icon(Icons.notifications_active),
            color: Colors.white,
            splashColor: Color.fromRGBO(220, 180, 57, 1.0),
            onPressed: () {
              // Implement navigation to notifications page here...
              List<dynamic> likedArray;
              Firestore.instance
                  .collection("users")
                  .document(strUserId)
                  .get()
                  .then((docSnapshot) => {
                        likedArray = docSnapshot.data['request'],
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NotificationPage(strUserId, likedArray))),
                      });
              print('Notifications clicked');
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
                height: 55.0,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 10),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: TextThemes.ndGold,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: TextThemes.ndBlue,
                    child: CircleAvatar(
                      backgroundImage: (currentUser.photoUrl == null)
                          ? AssetImage('images/user-avatar.png')
                          : NetworkImage(currentUser.photoUrl),
                      // backgroundImage: NetworkImage(currentUser.photoUrl),
                      radius: 50,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentUser.displayName != null
                    ? currentUser.displayName
                    : "Heena-Android",
                style: TextThemes.extraBold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '42 Friends',
                  style: TextThemes.bodyText1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text('•'),
                ),
                Text(
                  '2 upcoming MOOVS',
                  style: TextThemes.bodyText1,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7.5, bottom: 30, top: 15.5),
              child: SizedBox(
                height: 35.0,
                width: 300,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  icon: Icon(Icons.edit),
                  backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
                  label: Text("Edit profile"),
                  foregroundColor: Colors.white,
                  elevation: 15,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SeeContactsButton(),
                FriendButton()
                // Padding(
                //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                //   child: Text(''),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: RaisedButton(
                //     color: Colors.white.withOpacity(0.7),
                //     onPressed: null,
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.only(right: 8.0),
                //           child: Icon(Icons.directions_run,
                //               color: TextThemes.ndGold),
                //         ),
                //         Container(
                //             child: Text('Previous MOOVs',
                //                 style: TextStyle(color: TextThemes.ndBlue))),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 45.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [Text('Mountains MOOVed this week')],
            //   ),
            // ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Spacer(flex: 3),
            //             Column(
            //               children: [
            //                 Image.asset('lib/assets/greenmountain.png'),
            //                 Padding(
            //                   padding: const EdgeInsets.only(top: 10.0),
            //                   child: Text(
            //                     """One Mountain
            // MOOVed!""",
            //                     textScaleFactor: .85,
            //                     overflow: TextOverflow.ellipsis,
            //                     maxLines: 2,
            //                     style: TextStyle(color: Colors.green),
            //                   ),
            //                 )
            //               ],
            //             ),
            //             Spacer(flex: 1),
            //             Column(
            //               children: [
            //                 Image.asset('lib/assets/greymountain.png'),
            //               ],
            //             ),
            //             Spacer(flex: 1),
            //             Image.asset('lib/assets/greymountain.png'),
            //             Spacer(flex: 3),
            //           ],
            //         ),
            Positioned(
              bottom: 10,
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: RaisedButton(
                    color: TextThemes.ndBlue,
                    textColor: Colors.white,
                    child: Text('Sign out'),
                    onPressed: () => googleSignIn.signOut()),
              ),
            )
          ],
        ),
      ),
      /*child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 10),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: TextThemes.ndGold,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: TextThemes.ndBlue,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: TextThemes.ndBlue,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(currentUser.photoUrl),
                          radius: 50,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    currentUser.displayName,
                    style: TextThemes.extraBold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '42 Friends',
                      style: TextThemes.bodyText1,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text('•'),
                    ),
                    Text(
                      '2 upcoming MOOVS',
                      style: TextThemes.bodyText1,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 7.5, bottom: 30, top: 15.5),
                  child: SizedBox(
                    height: 35.0,
                    width: 300,
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                      backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
                      label: Text("Edit profile"),
                      foregroundColor: Colors.white,
                      elevation: 15,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SeeContactsButton(),
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    //   child: Text(''),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: RaisedButton(
                    //     color: Colors.white.withOpacity(0.7),
                    //     onPressed: null,
                    //     child: Row(
                    //       mainAxisSize: MainAxisSize.min,
                    //       children: [
                    //         Padding(
                    //           padding: const EdgeInsets.only(right: 8.0),
                    //           child: Icon(Icons.directions_run,
                    //               color: TextThemes.ndGold),
                    //         ),
                    //         Container(
                    //             child: Text('Previous MOOVs',
                    //                 style: TextStyle(color: TextThemes.ndBlue))),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 45.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [Text('Mountains MOOVed this week')],
                //   ),
                // ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Spacer(flex: 3),
                //             Column(
                //               children: [
                //                 Image.asset('lib/assets/greenmountain.png'),
                //                 Padding(
                //                   padding: const EdgeInsets.only(top: 10.0),
                //                   child: Text(
                //                     """One Mountain
                // MOOVed!""",
                //                     textScaleFactor: .85,
                //                     overflow: TextOverflow.ellipsis,
                //                     maxLines: 2,
                //                     style: TextStyle(color: Colors.green),
                //                   ),
                //                 )
                //               ],
                //             ),
                //             Spacer(flex: 1),
                //             Column(
                //               children: [
                //                 Image.asset('lib/assets/greymountain.png'),
                //               ],
                //             ),
                //             Spacer(flex: 1),
                //             Image.asset('lib/assets/greymountain.png'),
                //             Spacer(flex: 3),
                //           ],
                //         ),
                Positioned(
                  bottom: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 35.0),
                    child: RaisedButton(
                        color: TextThemes.ndBlue,
                        textColor: Colors.white,
                        child: Text('Sign out'),
                        onPressed: () => googleSignIn.signOut()),
                  ),
                )
              ],
            ),
          ),*/
    );
  }
}
