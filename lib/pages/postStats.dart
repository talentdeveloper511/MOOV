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
            int maleCount = 0;
            int femaleCount = 0;
            int otherGenderCount = 0;
            int blackCount = 0;
            int latinoCount = 0;
            int asianCount = 0;
            int whiteCount = 0;
            int otherRaceCount = 0;

            Map stats = snapshot.data['stats'];
           
            if (stats.containsKey('maleCount')) {
              maleCount = stats['maleCount'];
            }
            if (stats.containsKey('femaleCount')) {
              femaleCount = stats['femaleCount'];
            }
            if (stats.containsKey('otherGenderCount')) {
              otherGenderCount = stats['otherGenderCount'];
            }
            if (stats.containsKey('blackCount')) {
              blackCount = stats['blackCount'];
            }
            if (stats.containsKey('latinoCount')) {
              latinoCount = stats['latinoCount'];
            }
            if (stats.containsKey('asianCount')) {
              asianCount = stats['asianCount'];
            }
            if (stats.containsKey('whiteCount')) {
              whiteCount = stats['whiteCount'];
            }
            if (stats.containsKey('otherRaceCount')) {
              otherRaceCount = stats['otherRaceCount'];
            }

            return Column(
              children: [
                SizedBox(height: 30),
                Center(
                  child: Text("MOOV Stats",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                ),
                Text('"Ratio!"'),
                SizedBox(height: 30),
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * .7,
                      child: Center(
                          child: SfCircularChart(
                              palette: [
                                Colors.blue[400],
                                Colors.pink[200],
                                Colors.purple[200],
                              ],
                              legend: Legend(isVisible: true),
                              series: <PieSeries<PieData, String>>[
                                PieSeries<PieData, String>(
                                    explode: true,
                                    explodeIndex:
                                        currentUser.gender == "Female" ? 0 : 1,
                                    dataSource: [
                                      PieData("Guys", maleCount),
                                      PieData("Girls", femaleCount),
                                      PieData("Other", otherGenderCount)
                                    ],
                                    xValueMapper: (PieData data, _) =>
                                        data.xData,
                                    yValueMapper: (PieData data, _) =>
                                        data.yData,
                                    dataLabelMapper: (PieData data, _) =>
                                        data.text,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        showZeroValue: false,
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
                        )),
                    (maleCount > femaleCount + otherGenderCount)
                        ? Positioned(
                            bottom: 0,
                            left: 45,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text("Sausage Fest",
                                        style: TextStyle(color: Colors.brown)),
                                    SizedBox(width: 5),
                                    Image.asset('lib/assets/sausage.png',
                                        height: 10)
                                  ],
                                ),
                                Text(
                                  "(Majority Guys!)",
                                  style: TextStyle(fontSize: 8),
                                ),
                              ],
                            ))
                        : Container()
                  ],
                ),
                (maleCount > femaleCount + otherGenderCount)
                    ? SizedBox(height: 7.5)
                    : Container(),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(thickness: 2),
                ),

                //MOOV Mountain Indicator
                SizedBox(
                  height: 20,
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
                                        "MOOV Mountain events are those considered to be forces for good. \n\n Examples of these include: \n-Volunteering in the community\n-Intermixing in diverse events\n-Making someone's day \n\nGo to these and earn sweet rewards!"),
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                        child: Text(
                                          "Recommend for Mountain",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        onPressed: () => Navigator.pop(context))
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
                ),
                SizedBox(height: 15),

                //race pie chart
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * .7,
                      child: Center(
                          child: SfCircularChart(
                              palette: [
                                Colors.brown[400],
                                Colors.orange[300],
                                Colors.red[200],
                                Colors.amber[50],
                                Colors.blue[100]
                              ],
                              legend: Legend(isVisible: true),
                              series: <PieSeries<PieData, String>>[
                                PieSeries<PieData, String>(
                                    // explode: true,
                                    // explodeIndex: 0,
                                    dataSource: [
                                      PieData("Black", blackCount),
                                      PieData("Latino", latinoCount),
                                      PieData("Asian", asianCount),
                                      PieData("White", whiteCount),
                                      PieData("Other", otherRaceCount)
                                    ],
                                    xValueMapper: (PieData data, _) =>
                                        data.xData,
                                    yValueMapper: (PieData data, _) =>
                                        data.yData,
                                    dataLabelMapper: (PieData data, _) =>
                                        data.text,
                                    dataLabelSettings: DataLabelSettings(
                                        isVisible: true,
                                        showZeroValue: false,
                                        textStyle: TextStyle(fontSize: 20)))
                              ])),
                    ),
                    Positioned(
                        top: 10,
                        left: 0,
                        child: Column(
                          children: [
                            Text("Diversity"),
                            Text(
                              "Going List",
                              style: TextStyle(fontSize: 8),
                            )
                          ],
                        ))
                  ],
                ),
                Text("The more diverse the pie, \nthe bigger your reward!",
                    textAlign: TextAlign.center),
                SizedBox(height: 4),
                Text("—Must be on Going List, 10+ people—",
                    style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic))
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
