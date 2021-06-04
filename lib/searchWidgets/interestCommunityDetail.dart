import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:MOOV/widgets/post_card_new.dart';
import 'package:MOOV/widgets/set_moov.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class InterestCommunityDetail extends StatelessWidget {
  final String groupId;
  const InterestCommunityDetail({@required this.groupId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: communityGroupsRef.doc(groupId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          String groupName = snapshot.data['groupName'];
          String groupPic = snapshot.data['groupPic'];
          List members = snapshot.data['members'];

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
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
              flexibleSpace: Image.network(
                groupPic,
                fit: BoxFit.cover,
                colorBlendMode: BlendMode.darken,
                color: Colors.black38,
              ),
              title: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: "M",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            color: TextThemes.ndGold),
                      ),
                      TextSpan(
                        text: "/" + groupName,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: 20),
                      ),
                    ]),
              ),
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                        elevation: 20,
                        color: Colors.blue[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          height: 40,
                          child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: members.length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder(
                                  stream:
                                      usersRef.doc(members[index]).snapshots(),
                                  builder: (context, snapshot2) {
                                    if (!snapshot2.hasData ||
                                        snapshot2.data == null) {
                                      return Container();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 4),
                                          FocusedMenuHolder(
                                            menuWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            blurSize: 5.0,
                                            menuItemExtent: 45,
                                            menuBoxDecoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15.0))),
                                            duration:
                                                Duration(milliseconds: 100),
                                            animateMenuItems: true,
                                            blurBackgroundColor: Colors.black54,
                                            openWithTap:
                                                true, // Open Focused-Menu on Tap rather than Long Press
                                            menuOffset:
                                                10.0, // Offset value to show menuItem from the selected item
                                            bottomOffsetHeight:
                                                80.0, // Offset height to consider, for showing the menu item ( for Suggestions bottom navigation bar), so that the popup menu will be shown on top of selected item.
                                            menuItems: <FocusedMenuItem>[
                                              // Add Each FocusedMenuItem  for Menu Options

                                              FocusedMenuItem(
                                                  title: Text("DM"),
                                                  trailingIcon:
                                                      Icon(Icons.message),
                                                  onPressed: () {}),
                                              FocusedMenuItem(
                                                  title: Text(
                                                    "View Profile",
                                                  ),
                                                  trailingIcon: Icon(
                                                    Icons.person,
                                                  ),
                                                  onPressed: () {}),
                                              FocusedMenuItem(
                                                  title: Text(
                                                    "Report",
                                                    style: TextStyle(
                                                        color:
                                                            Colors.redAccent),
                                                  ),
                                                  trailingIcon: Icon(
                                                    Icons.directions_walk,
                                                    color: Colors.redAccent,
                                                  ),
                                                  onPressed: () {}),
                                            ],
                                            onPressed: () {},
                                            child: CircleAvatar(
                                                radius: 16,
                                                backgroundColor:
                                                    // memberStatus[index] == -1
                                                    //     ? Colors.blue
                                                    //     : memberStatus[index] == 1
                                                    //         ? Colors.red
                                                    TextThemes.ndGold,
                                                child: CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot2
                                                          .data['photoUrl']),
                                                  radius: 15,
                                                  backgroundColor:
                                                      TextThemes.ndBlue,
                                                )),
                                          ),
                                          SizedBox(height: 4),
                                        ],
                                      ),
                                    );
                                  });
                            },
                          ),
                        )),
                    FocusedMenuHolder(
                      menuWidth: MediaQuery.of(context).size.width * 0.50,
                      blurSize: 5.0,
                      menuItemExtent: 45,
                      menuBoxDecoration: BoxDecoration(
                          color: Colors.white,
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
                          80.0, // Offset height to consider, for showing the menu item ( for Suggestions bottom navigation bar), so that the popup menu will be shown on top of selected item.
                      menuItems: <FocusedMenuItem>[
                        // Add Each FocusedMenuItem  for Menu Options

                        FocusedMenuItem(
                            title: Text("DM"),
                            trailingIcon: Icon(Icons.message),
                            onPressed: () {}),
                        FocusedMenuItem(
                            title: Text(
                              "View Profile",
                            ),
                            trailingIcon: Icon(
                              Icons.person,
                            ),
                            onPressed: () {}),
                      ],
                      child:
                      Icon(Icons.person_add, color: Colors.blue),
                      //  Text(
                      //   members.contains(currentUser.id) ? "Invite" : "  Join",
                      //   style: TextStyle(
                      //       color: Colors.blue,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 17),
                      // ),
                      onPressed: () {},
                    ),
                    _Notifications(),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                                                context,
                                                PageTransition(
                                                    type: PageTransitionType
                                                        .bottomToTop,
                                                    child: SearchSetMOOV(
                                                        groupId: groupId,
                                                        pickMOOV: true,
                                                        )));},
                                           
                      child: Icon(Icons.add, color: Colors.blue)),
                    SizedBox(width: 5),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "TODAY",
                        style: GoogleFonts.montserrat(
                            fontSize: 30, fontWeight: FontWeight.w600),
                      )),
                ),
                FutureBuilder(
                  future: postsRef
                      .where("tags", arrayContains: "m/"+groupName.toLowerCase())
                      .orderBy("startDate")
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.docs.length == 0)
                      return Container();

                    return Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot course = snapshot.data.docs[index];
                          Timestamp startDate = course["startDate"];
                          String privacy = course['privacy'];

                          bool hide = false;

                          final now = DateTime.now();
                          bool isToday = false;
                          bool isTomorrow = false;

                          final today = DateTime(now.year, now.month, now.day);
                          final yesterday =
                              DateTime(now.year, now.month, now.day - 1);
                          final tomorrow =
                              DateTime(now.year, now.month, now.day + 1);

                          final dateToCheck = startDate.toDate();
                          final aDate = DateTime(dateToCheck.year,
                              dateToCheck.month, dateToCheck.day);

                          if (aDate == today) {
                            isToday = true;
                          } else if (aDate == tomorrow) {
                            isTomorrow = true;
                          }
                          // if (isToday == false && todayOnly == 1) {
                          //   hide = true;
                          // }
                          // if (course['featured'] != true &&
                          //     privacyDropdownValue == "Featured") {
                          //   hide = true;
                          // }
                          if (privacy == "Friends Only" ||
                              privacy == "Invite Only") {
                            hide = true;
                          }
                          // if (privacyDropdownValue == "Private" &&
                          //     (privacy != "Friends Only" ||
                          //         privacy != "Invite Only")) {
                          //   hide = true;
                          // }
                          // if (privacy == "Friends Only" &&
                          //     privacyDropdownValue == "Private" &&
                          //     currentUser.friendArray
                          //         .contains(course['userId'])) {
                          //   hide = false;
                          // }
                          // if (privacy == "Invite Only" &&
                          //     privacyDropdownValue == "Private" &&
                          //     course['statuses'].keys.contains(currentUser.id)) {
                          //   hide = false;
                          // }

                          ValueNotifier<double> _notifier =
                              ValueNotifier<double>(0);

                          return (hide == false)
                              ? BiteSizePostUI(course: course)
                              : Container();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }
}

class _Notifications extends StatefulWidget {
  _Notifications();

  @override
  __NotificationsState createState() => __NotificationsState();
}

class __NotificationsState extends State<_Notifications> {
  bool _on = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _on = !_on;
          });
        },
        child: _on
            ? Icon(Icons.notifications_outlined)
            : Icon(Icons.notifications_active, color: Colors.blue));
  }
}
