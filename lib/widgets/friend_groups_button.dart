
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:MOOV/pages/Freinds _List.dart';


class FriendGroupsButton extends StatelessWidget {
  List<dynamic> likedArray;
  dynamic moovId;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white
          .withOpacity(.7), //set this opacity as per your requirement
      onPressed: (){
        Navigator.of(context).push(
            MaterialPageRoute(
                builder:(context)=>FreindsList(likedArray,moovId)
            )
        );
        },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.people, ),
          ),
          Container(
              child: Text('Friend Groups',
               //   style: TextStyle(color: TextThemes.ndBlue)
              )),
        ],
      ),
    );
  }
}
