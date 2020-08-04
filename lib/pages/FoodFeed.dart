import 'package:MOOV3/widgets/segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'package:MOOV3/helpers/themes.dart';

class FoodFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: MyAppBar(
          title: Text(
        'FOOD',
        style: TextThemes.extraBoldWhite,
        textScaleFactor: 1.2,
      )),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(flex: 1, child: SegmentedControl()),
          // Flexible(
          //   flex: 4,
          //   fit: FlexFit.loose,
          //   child: ListView.builder(
          //       itemCount: DemoValues.posts.length,
          //       itemBuilder: (BuildContext context, int index) {
          //         return PostCard(postData: DemoValues.posts[index]);
          //       }),
          // ),
        ],
      ),
    );
  }
}
