import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/Friends_List.dart';

class FriendButton extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId;
  final userFriends;
  FriendButton({this.userFriends});
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white
          .withOpacity(.7), //set this opacity as per your requirement
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                friendsList(likedArray, moovId, userFriends: userFriends)));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.people,
              color: TextThemes.ndGold,
            ),
          ),
          Container(
              child: Text(
            'Friend Network', style: TextStyle(color: TextThemes.ndBlue),
            //   style: TextStyle(color: TextThemes.ndBlue)
          )),
        ],
      ),
    );
  }
}
