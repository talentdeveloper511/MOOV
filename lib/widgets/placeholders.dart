import 'package:MOOV/main.dart';
import 'package:MOOV/pages/create_account.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class Placeholders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Container(
        height: 200,
        child: Column(
          children: [
            Text("Placeholders"),
            Divider(
              color: TextThemes.ndBlue,
              height: 20,
              thickness: 2,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
                child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      // DocumentSnapshot course =
                      //     snapshot.data.docs[index];

                      return Image.network(
                        'alvin.png',
                        fit: BoxFit.cover,
                        height: 40,
                        width: 20,
                      );
                    }, childCount: 1),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    )),
              ],
            )),
          ],
        ),
      ),
    ));
  }
}
