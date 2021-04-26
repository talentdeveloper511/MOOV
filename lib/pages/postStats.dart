import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PostStats extends StatefulWidget {
  final String postId;
  PostStats(this.postId);

  @override
  PostStatsState createState() => PostStatsState();
}

class PostStatsState extends State<PostStats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Image.asset(
                  'lib/assets/moovblue.png',
                  fit: BoxFit.cover,
                  height: 50.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: postsRef.doc(widget.postId).get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }
            bool isMoovMountain;
            return Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text("MOOV Stats",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
                Text('"Ratio!"'),
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * .7,
                      child: Center(
                          child: SfCircularChart(
                              legend: Legend(isVisible: true),
                              series: <PieSeries<PieData, String>>[
                            PieSeries<PieData, String>(
                                explode: true,
                                explodeIndex: 0,
                                dataSource: [
                                  PieData("guys", 2),
                                  PieData("girls", 1)
                                ],
                                xValueMapper: (PieData data, _) => data.xData,
                                yValueMapper: (PieData data, _) => data.yData,
                                dataLabelMapper: (PieData data, _) => data.text,
                                dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    textStyle: TextStyle(fontSize: 20)))
                          ])),
                    ),
                    Positioned(
                        top: 10,
                        left: 0,
                        child: Column(
                          children: [
                            Text("Ratio"),
                            Text(
                              "Going List",
                              style: TextStyle(fontSize: 8),
                            )
                          ],
                        ))
                  ],
                ),

                //MOOV Mountain Indicator
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, right: 8),
                      child: Image.asset(
                        'lib/assets/greenmountain.png',
                        height: 40,
                        color: Colors.grey,
                      ),
                    ),
                    Text("not ", style: TextStyle(color: Colors.red)),
                    Text("a MOOV Mountain event."),
                    SizedBox(width: 7.5),
                    GestureDetector(
                      onTap: () => showDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                                  title: Text("Make a Difference."),
                                  content: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                        "MOOV Mountain events are those considered to be forces for good. \n\nGo to these and earn sweet rewards!"),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: Text(
                                        "Recommend for Mountain",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      onPressed: () => Navigator.pop(context)
                                    )
                                  ]),
                          barrierDismissible: true),
                      child: CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.teal,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                            "Why?",
                            style: TextStyle(fontSize: 8),
                          ),
                          radius: 15,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );
  }
}

class PieData {
  PieData(this.xData, this.yData, [this.text]);
  final String xData;
  final num yData;
  final String text;
}
