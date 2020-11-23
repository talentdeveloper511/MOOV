import 'package:MOOV/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FriendGroupsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: Colors.white
          .withOpacity(.7), //set this opacity as per your requirement

      onPressed: (){
      
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(Icons.people, color: TextThemes.ndGold),
          ),
          Container(
              child: Text('Friend Groups',
                  style: TextStyle(color: TextThemes.ndBlue))),
        ],
      ),
    );
  }
}
