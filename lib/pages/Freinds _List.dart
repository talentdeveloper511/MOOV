import 'package:flutter/material.dart';
import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/pages/ProfilePage.dart';
import 'package:MOOV/pages/notification_details.dart';

class FreindsList extends StatefulWidget {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;

  FreindsList(this.moovId, this.likedArray);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return FreindsListState(this.moovId, this.likedArray);
  }
}

class FreindsListState extends State<FreindsList> {
  dynamic moovId;
  TextEditingController searchController = TextEditingController();
  List<dynamic> likedArray;

  FreindsListState(this.moovId, this.likedArray);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TextThemes.ndBlue,
          title: Text(
            "Friends",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 4.0),
          child: ListView.builder(
              shrinkWrap: true, //MUST TO ADDED
              physics: NeverScrollableScrollPhysics(),
              itemCount: 1,
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
                                    child: CircleAvatar(
                                      radius: 22.0,
                                      backgroundImage:
                                      AssetImage('lib/assets/me.jpg')
                                      // NetworkImage(likedArray[index]['strPic']),

                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text("Kev",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: TextThemes.ndBlue,
                                        decoration: TextDecoration.none)),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: RaisedButton(
                                  padding: const EdgeInsets.all(2.0),
                                  color: TextThemes.ndBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                  onPressed: () {
                                    print("Click Freinds");

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
                                  },
                                  child: Text(
                                    "View Profile",
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                );
              }),
        ));
  }
}
