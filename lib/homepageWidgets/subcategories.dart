import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Subcategories extends StatelessWidget {
  final ValueNotifier<double> notifier;
  final String type;

  Subcategories({this.notifier, this.type});
  Color colorTween(Color begin, Color end, _notifier) {
    return ColorTween(begin: begin, end: end).transform(_notifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
                          color: colorTween(Colors.white, Colors.black87, notifier),

        height: 200,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
            stream: postsRef.where("tags", arrayContains: type).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.docs.length == 0)
                return Center(
                  child: Container(),
                );

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: colorTween(Colors.white, Colors.black87, notifier),
                  ),
                  width: MediaQuery.of(context).size.width * .95,
                  height: 90,
                  child: Column(
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, top: 10),
                            child: Text(
                              "Try Something New",
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorTween(
                                    Colors.black, Colors.white, notifier),
                              ),
                            ),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 90,
                                    width:
                                        MediaQuery.of(context).size.width * .75,
                                    child: BiteSizePostUI(
                                        course: snapshot.data.docs[index]));
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }
}
