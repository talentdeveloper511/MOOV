
import 'dart:ui';

import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/going.dart';
import 'package:MOOV/models/going_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoingPage extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId;

  GoingPage(this.likedArray, this.moovId);

  @override
  Widget build(BuildContext context) {


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
                                backgroundImage:
                                NetworkImage(likedArray[index]['strPic']),
                                backgroundColor: Colors.transparent,
                              )
                          ),
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
        : Center(child: Image.asset('lib/assets/chens.jpg', height: 40,));
  }
}