import 'package:MOOV/pages/home.dart';
import 'package:MOOV/searchWidgets/interestCommunityDetail.dart';
import 'package:MOOV/searchWidgets/interestCommunityMaker.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:reorderables/reorderables.dart';

class CommunityGroups extends StatefulWidget {
  @override
  _CommunityGroupsState createState() => _CommunityGroupsState();
}

class _CommunityGroupsState extends State<CommunityGroups> {
  List<Widget> _tiles4;

  @override
  void initState() {
    super.initState();
    _tiles4 = <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        Widget row = _tiles4.removeAt(oldIndex);
        _tiles4.insert(newIndex, row);
      });
    }

    String groupName;
    String groupId;
    String groupPic;

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FutureBuilder(
            future: communityGroupsRef.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              List<Widget> _tiles4 = [];
              for (int i = 0; i < 5; i++) {
                groupName = snapshot.data.docs[i]['groupName'];
                groupId = snapshot.data.docs[i]['groupId'];
                groupPic = snapshot.data.docs[i]['groupPic'];
                _tiles4.add(BouncingWidget(
                  duration: Duration(milliseconds: 100),
                  scaleFactor: 1.5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InterestCommunityDetail(groupId: groupId)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: 140,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(groupPic),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.darken)),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: TextThemes.ndBlue,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          groupName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.sports_football,
                            size: 40, color: Colors.white),
                      ],
                    ),
                  ),
                ));
              }

              ///create your own
              _tiles4.add(BouncingWidget(
                duration: Duration(milliseconds: 100),
                scaleFactor: 1.5,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => InterestCommunityMaker()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .3,
                  height: 140,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('lib/assets/bouts.jpg'),
                          fit: BoxFit.cover,
                          colorFilter:
                              ColorFilter.mode(Colors.grey, BlendMode.darken)),
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: TextThemes.ndBlue,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.9),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      SizedBox(height: 10),
                      Icon(Icons.add, size: 40, color: Colors.white),
                    ],
                  ),
                ),
              ));

              ///

              for (int i = 5; i < snapshot.data.docs.length; i++) {
                _tiles4.add(BouncingWidget(
                  duration: Duration(milliseconds: 100),
                  scaleFactor: 1.5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              InterestCommunityDetail(groupId: groupId)),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: 140,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(groupPic),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.grey, BlendMode.darken)),
                        color: Colors.white,
                        border: Border.all(
                          width: 2,
                          color: TextThemes.ndBlue,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.25),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          groupName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        SizedBox(height: 10),
                        Icon(Icons.sports_football,
                            size: 40, color: Colors.white),
                      ],
                    ),
                  ),
                ));
              }
              return ReorderableWrap(
                  spacing: 8.0,
                  runSpacing: 25.0,
                  padding: const EdgeInsets.all(8),
                  children: _tiles4,
                  onReorder: _onReorder,
                  onNoReorder: (int index) {
                    //this callback is optional
                    debugPrint(
                        '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                  },
                  onReorderStarted: (int index) {
                    //this callback is optional
                    debugPrint(
                        '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                  });
            }),
      ],
    );

    return Center(
      child: SingleChildScrollView(
        child: column,
      ),
    );
  }
}
