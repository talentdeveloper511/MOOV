import 'package:MOOV/pages/home.dart';
import 'package:MOOV/searchWidgets/interestCommunityDetail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:reorderables/reorderables.dart';

class WrapExample extends StatefulWidget {
  @override
  _WrapExampleState createState() => _WrapExampleState();
}

class _WrapExampleState extends State<WrapExample> {
  final double _iconSize = 90;
  List<Widget> _tiles4;
  List _tiles2 = [];

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

    var column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 40),
        FutureBuilder(
            future: communityGroupsRef.get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              List<Widget> _tiles4 = [];
              for (int i = 0; i < 4; i++) {
                _tiles4.add(BouncingWidget(
                  duration: Duration(milliseconds: 100),
                  scaleFactor: 1.5,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InterestCommunityDetail(groupId:"1xDa2SqY77XVVEIYlTDI")),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * .3,
                    height: 140,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('lib/assets/bouts.jpg'),
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
                          snapshot.data.docs[i]['groupName'],
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

    return Scaffold(
      body: SingleChildScrollView(
        child: column,
      ),
    );
  }
}
