import 'package:MOOV/main.dart';
import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'home.dart';

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  String title1, title2, title3, title4, title5;
  double likes1, likes2, likes3, likes4, likes5;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 280,
      child: StreamBuilder(
          stream: Firestore.instance
              .collection('food')
              // .where("MOTD", isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            // title = snapshot.data['title'];
            // pic = snapshot.data['pic'];
            if (!snapshot.hasData) return Text('Loading data...');

            return Container(
              height: 270,
              child: MediaQuery(
                data: MediaQuery.of(context).removePadding(removeTop: true),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      bool isLargePhone = Screen.diagonal(context) > 766;

                      title1 = snapshot.data.documents[0]['title'];
                      likes1 =
                          snapshot.data.documents[0]['liker'].length.toDouble();
                      title2 = snapshot.data.documents[1]['title'];
                      likes2 =
                          snapshot.data.documents[1]['liker'].length.toDouble();
                      title3 = snapshot.data.documents[2]['title'];
                      likes3 =
                          snapshot.data.documents[2]['liker'].length.toDouble();
                      // title4 = snapshot.data.documents[0]['title'];
                      // likes4 =
                      //     snapshot.data.documents[0]['liker'].length.toDouble();
                      // title5 = snapshot.data.documents[0]['title'];
                      // likes5 =
                      //     snapshot.data.documents[0]['liker'].length.toDouble();
                      List<_SalesData> data = [
                        _SalesData(title1, likes1),
                        _SalesData(title2, likes2),
                        _SalesData(title3, likes3),
                        // _SalesData(title4, likes4),
                        // _SalesData(title5, likes5)
                      ];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 18.0),
                        child: SfCartesianChart(
                        
                            margin: EdgeInsets.fromLTRB(10, 00, 10, 160),
                            primaryYAxis: CategoryAxis(zoomFactor: 2),
                            primaryXAxis: CategoryAxis(
                              
                              labelRotation: 0,
                              labelsExtent: 90,
                              labelStyle: TextStyle(
                                  color: TextThemes.ndBlue, fontSize: 13),
                              maximumLabelWidth: 90,
                            ),
                            // Chart title
                            title: ChartTitle(
                                text: 'HOT MOOVS TONIGHT',
                                textStyle: GoogleFonts.robotoCondensed(
                                    fontSize: 20,
                                    decoration: TextDecoration.none)),
                            // Enable legend
                            legend: Legend(
                                overflowMode: LegendItemOverflowMode.scroll,
                                isVisible: false,
                                toggleSeriesVisibility: false,
                                alignment: ChartAlignment.center,
                                title: LegendTitle(text: "HEAD Count"),
                                position: LegendPosition.top),
                            // Enable tooltip
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <ChartSeries<_SalesData, String>>[
                              LineSeries<_SalesData, String>(
                                  dataSource: data,
                                  xValueMapper: (_SalesData sales, _) =>
                                      sales.year,
                                  yValueMapper: (_SalesData sales, _) =>
                                      sales.sales,

                                  // Enable data label
                                  dataLabelSettings: DataLabelSettings(
                              
                                    isVisible: true,
                                  ))
                            ]),
                      );
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   //Initialize the spark charts widget
                      //   child: SfSparkLineChart.custom(
                      //     //Enable the trackball
                      //     trackball: SparkChartTrackball(
                      //         activationMode: SparkChartActivationMode.tap),
                      //     //Enable marker
                      //     marker: SparkChartMarker(
                      //         displayMode: SparkChartMarkerDisplayMode.all),
                      //     //Enable data label
                      //     labelDisplayMode: SparkChartLabelDisplayMode.all,
                      //     xValueMapper: (int index) => data[index].year,
                      //     yValueMapper: (int index) => data[index].sales,
                      //     dataCount: 5,
                      //   ),
                      // )
                    }),
              ),
            );
          }),
    );
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
