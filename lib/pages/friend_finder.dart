import 'package:MOOV/helpers/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:MOOV/pages/SportFeed.dart';

class FriendFinder extends StatelessWidget {
  dynamic startDate, moovId;
  List<dynamic> likedArray;
  String eventprofile, title;

  FriendFinder(this.likedArray, this.eventprofile, this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TextThemes.ndBlue,
        title: Text(
          "Friend Finder",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
          child: likedArray != null
              ? ListView.builder(
                  shrinkWrap: true, //MUST TO ADDED
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: likedArray.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(children: [
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, right: 5),
                                  child: Text('is Going',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: CupertinoColors.activeGreen,
                                          decoration: TextDecoration.none)),
                                ),
                                Text('to',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CupertinoColors.black,
                                        decoration: TextDecoration.none)),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 32, left: 0.0),
                                    child: Row(
                                      children: [
                                        // Container(
                                        //   margin: EdgeInsets.only(
                                        //       bottom: 30, left: 5),
                                        //   child: CircleAvatar(
                                        //       radius: 22,
                                        //       backgroundColor:
                                        //           TextThemes.ndBlue,
                                        //       child: CircleAvatar(
                                        //         radius: 22.0,
                                        //         backgroundImage:
                                        //             NetworkImage(eventprofile),
                                        //         backgroundColor:
                                        //             Colors.transparent,
                                        //       )),
                                        // ),
                                        GestureDetector(
                                          onTap: () {
                                            print("Friend's Event Clicked");
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SportFeed()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: const EdgeInsets.only(
                                                top: 0.0, bottom: 22, left: 5),
                                            child: Text(title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color:
                                                        CupertinoColors.black,
                                                    decoration:
                                                        TextDecoration.none)),
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          )
                        ]));
                  })
              : Center(
                  child: Image.asset(
                  'lib/assets/chens.jpg',
                  height: 40,
                ))),
    );
  }
}
