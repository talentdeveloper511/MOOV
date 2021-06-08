import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/ProfilePageWithHeader.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/pages/other_profile.dart';
import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:MOOV/widgets/set_moov.dart';
import 'package:MOOV/widgets/trending_segment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
          List admins = snapshot.data['admins'];
          List notifList = snapshot.data['notifList'];

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
            body: ListView(
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
                                          horizontal: 4.0),
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
                                                  title: Text(
                                                    "View Profile",
                                                  ),
                                                  trailingIcon: Icon(
                                                    Icons.person,
                                                  ),
                                                  onPressed: () {
                                                    if (members[index] ==
                                                        currentUser.id) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ProfilePageWithHeader()));
                                                    } else {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  OtherProfile(
                                                                      members[
                                                                          index])));
                                                    }
                                                  }),
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
                                                    admins.contains(
                                                            members[index])
                                                        ? Colors.blue
                                                        : TextThemes.ndGold,
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
                    _Notifications(notifList, groupId),
                    AddMOOVButton(groupName),
                    CommunityEditButton(members, admins, groupId),
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
                            fontSize: 20, fontWeight: FontWeight.w600),
                      )),
                ),
                CommunityMOOVs(groupId, groupName)
              ],
            ),
          );
        });
  }
}

class _Notifications extends StatefulWidget {
  final List notifList;
  final String groupId;
  _Notifications(this.notifList, this.groupId);

  @override
  __NotificationsState createState() => __NotificationsState();
}

class __NotificationsState extends State<_Notifications> {
  bool _on = false;
  @override
  Widget build(BuildContext context) {
    if (widget.notifList.contains(currentUser.id)) {
      _on = true;
    }
    return GestureDetector(
        onTap: _on ? () {
          communityGroupsRef.doc(widget.groupId).update({
            "notifList": FieldValue.arrayRemove([currentUser.id]),
          }).then((value) => setState(() {}));
          HapticFeedback.lightImpact();
          setState(() {
            _on = false;
          });
        }: () {
          communityGroupsRef.doc(widget.groupId).update({
            "notifList": FieldValue.arrayUnion([currentUser.id]),
          }).then((value) => setState(() {}));
          HapticFeedback.lightImpact();
          setState(() {
            _on = true;
          });
        },
        child: !_on
            ? Icon(Icons.notifications_outlined)
            : Icon(Icons.notifications_active, color: Colors.blue));
  }
}

class AddMOOVButton extends StatefulWidget {
  final String groupName;
  const AddMOOVButton(this.groupName);

  @override
  _AddMOOVButtonState createState() => _AddMOOVButtonState();
}

class _AddMOOVButtonState extends State<AddMOOVButton> {
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset:
            10.0, // Offset value to show menuItem from the selected item
        bottomOffsetHeight:
            80.0, // Offset height to consider, for showing the menu item ( for Suggestions bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options

          FocusedMenuItem(
              title: Text("Add a MOOV"),
              trailingIcon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: SearchSetMOOV(
                          groupName: widget.groupName,
                          pickMOOV: true,
                        ))).then((value) => Navigator.pop(context));
              }),
          FocusedMenuItem(
              title: Text(
                "Make a MOOV",
              ),
              trailingIcon: Icon(
                Icons.create,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: MoovMaker()));
              }),
        ],
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.blue));
  }
}

class CommunityMOOVs extends StatefulWidget {
  final String groupId, groupName;
  CommunityMOOVs(this.groupId, this.groupName);

  @override
  _CommunityMOOVsState createState() => _CommunityMOOVsState();
}

class _CommunityMOOVsState extends State<CommunityMOOVs> {
  String todaysDate = DateFormat('yMd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FutureBuilder(
        future: postsRef
            .where("tags", arrayContains: "m/" + widget.groupName.toLowerCase())
            .where("startDateSimpleString", isEqualTo: todaysDate)
            .orderBy("startDate")
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.docs.length == 0)
            return Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No MOOVs today.\nAdd one.",
                      textAlign: TextAlign.center,
                    ),
                    AddMOOVButton(widget.groupName)
                  ]),
            );
          return Container(
            child: Column(
              children: [
                Container(
                  height: 216,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot course = snapshot.data.docs[index];
                      Timestamp startDate = course["startDate"];
                      // String privacy = course['privacy'];

                      final now = DateTime.now();
                      bool isToday = false;
                      // bool isTomorrow = false;

                      final today = DateTime(now.year, now.month, now.day);

                      // final tomorrow = DateTime(now.year, now.month, now.day + 1);

                      final dateToCheck = startDate.toDate();
                      final aDate = DateTime(
                          dateToCheck.year, dateToCheck.month, dateToCheck.day);

                      if (aDate == today) {
                        isToday = true;
                      }
                      //  else if (aDate == tomorrow) {
                      //   isTomorrow = true;
                      // }

                      // if (privacy == "Friends Only" || privacy == "Invite Only") {
                      //   hide = true;
                      // }

                      if (isToday) {
                        return Column(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * .8,
                                child: BiteSizePostUI(course: course)),
                            CommentPreviewOnPost(
                                postId: course['postId'],
                                postOwnerId: course['userId'],
                                fromCommunity: true)
                          ],
                        );
                      } else {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "No MOOVs today.\nAdd one.",
                                  textAlign: TextAlign.center,
                                ),
                                AddMOOVButton(widget.groupName)
                              ]),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      FutureBuilder(
          future: postsRef
              .where("tags",
                  arrayContains: "m/" + widget.groupName.toLowerCase())
              // .where("startDateSimpleString", isNotEqualTo: todaysDate)
              // .orderBy("startDateSimpleString")\
              .orderBy("startDate")
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Container(
              height: 310,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "UPCOMING",
                          style: GoogleFonts.montserrat(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                  ),
                  Expanded(
                      child: CustomScrollView(
                    // physics: NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverGrid(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            DocumentSnapshot course = snapshot.data.docs[index];
                            bool hide = false;
                            String startDateSimpleString =
                                course['startDateSimpleString'];

                            if (startDateSimpleString == todaysDate) {
                              hide = true;
                            }

                            return PostOnTrending(course);
                            // (hide == false)
                            //     ? PostOnTrending(course)
                            //     : Container();
                          }, childCount: snapshot.data.docs.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          )),
                    ],
                  )),
                ],
              ),
            );
          })
    ]);
  }
}

class CommunityEditButton extends StatefulWidget {
  final String groupId;
  final List members, admins;
  CommunityEditButton(this.members, this.admins, this.groupId);

  @override
  _CommunityEditButtonState createState() => _CommunityEditButtonState();
}

class _CommunityEditButtonState extends State<CommunityEditButton> {
  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
        onPressed: () {},
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true, // Open Focused-Menu on Tap rather than Long Press
        menuOffset:
            10.0, // Offset value to show menuItem from the selected item
        bottomOffsetHeight:
            80.0, // Offset height to consider, for showing the menu item ( for Suggestions bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options

          !widget.members.contains(currentUser.id)
              ? FocusedMenuItem(
                  title: Text("Join community",
                      style: TextStyle(color: Colors.green)),
                  trailingIcon: Icon(
                    Icons.group_add,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    communityGroupsRef.doc(widget.groupId).update({
                      "members": FieldValue.arrayUnion([currentUser.id]),
                    }).then((value) => setState(() {}));
                  })
              : widget.admins.contains(currentUser.id)
                  ? FocusedMenuItem(
                      title: Text(
                        "Edit info",
                      ),
                      trailingIcon: Icon(
                        Icons.edit,
                      ),
                      onPressed: () {})
                  : FocusedMenuItem(
                      title: Text(
                        "Request admin",
                      ),
                      trailingIcon: Icon(
                        Icons.star,
                      ),
                      onPressed: () {}),
          FocusedMenuItem(
              title: Text(
                "Report",
                style: TextStyle(color: Colors.redAccent),
              ),
              trailingIcon: Icon(
                Icons.directions_walk,
                color: Colors.redAccent,
              ),
              onPressed: () {}),
        ],
        child: Icon(Icons.more_vert));
  }
}
