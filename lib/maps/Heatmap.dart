import 'package:MOOV/pages/HomePage.dart';
import 'package:MOOV/pages/NewSearch.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;

///Core theme import
import 'package:syncfusion_flutter_core/theme.dart';

///Map import
// ignore: import_of_legacy_library_into_null_safe
import 'package:syncfusion_flutter_maps/maps.dart';

/// Renders the map widget with range color mapping
class MapRangeColorMappingPage extends SampleView {
  /// Creates the map widget with range color mapping
  const MapRangeColorMappingPage(Key key) : super(key: key);

  @override
  _MapRangeColorMappingPageState createState() =>
      _MapRangeColorMappingPageState();
}

class _MapRangeColorMappingPageState extends SampleViewState {
  List<_CountryDensity> _worldPopulationDensity;

  // The format which is used for formatting the tooltip text.
  final NumberFormat _numberFormat = NumberFormat('#.#');

  MapShapeSource _mapSource;

  @override
  void initState() {
    super.initState();

    // Data source to the map.
    //
    // [countryName]: Field name in the .json file to identify the shape.
    // This is the name to be mapped with shapes in .json file.
    // This should be exactly same as the value of the [shapeDataField]
    // in the .json file
    //
    // [density]: On the basis of this value, color mapping color has been
    // applied to the shape.
    _worldPopulationDensity = <_CountryDensity>[
      _CountryDensity('Morrissey Hall', 2),
      _CountryDensity("Howard Hall", 10),
      _CountryDensity("Fisher Hall", 30),
      _CountryDensity("O'Rourke's", 40),
      _CountryDensity('Notre Dame Stadium', 10),
    ];

    _mapSource = MapShapeSource.asset(
      // Path of the GeoJSON file.
      'lib/assets/ndMap.json',
      // Field or group name in the .json file
      // to identify the shapes.
      //
      // Which is used to map the respective
      // shape to data source.
      //
      // On the basis of this value,
      // shape tooltip text is rendered.
      shapeDataField: 'name',
      // The number of data in your data source collection.
      //
      // The callback for the [primaryValueMapper]
      // will be called the number of times equal
      // to the [dataCount].
      // The value returned in the [primaryValueMapper]
      // should be exactly matched with the value of the
      // [shapeDataField] in the .json file. This is how
      // the mapping between the data source and the shapes
      // in the .json file is done.
      dataCount: _worldPopulationDensity.length,
      primaryValueMapper: (int index) =>
          _worldPopulationDensity[index].countryName,
      // Used for color mapping.
      //
      // The value of the [MapColorMapper.from]
      // and [MapColorMapper.to]
      // will be compared with the value returned in the
      // [shapeColorValueMapper] and the respective
      // [MapColorMapper.color] will be applied to the shape.
      shapeColorValueMapper: (int index) =>
          _worldPopulationDensity[index].density,
      // Group and differentiate the shapes using the color
      // based on [MapColorMapper.from] and
      //[MapColorMapper.to] value.
      //
      // The value of the [MapColorMapper.from] and
      // [MapColorMapper.to] will be compared with the value
      // returned in the [shapeColorValueMapper] and
      // the respective [MapColorMapper.color] will be applied
      // to the shape.
      //
      // [MapColorMapper.text] which is used for the text of
      // legend item and [MapColorMapper.color] will be used for
      // the color of the legend icon respectively.
      shapeColorMappers: const <MapColorMapper>[
        MapColorMapper(
            from: 0,
            to: 5,
            color: Color.fromRGBO(255, 204, 204, 1),
            text: '{0},{5}'),
        MapColorMapper(
            from: 5,
            to: 10,
            color: Color.fromRGBO(255, 153, 153, 1),
            text: '10'),
        MapColorMapper(
            from: 10,
            to: 30,
            color: Color.fromRGBO(255, 102, 102, 1),
            text: '30'),
        MapColorMapper(
            from: 30,
            to: 50,
            color: Color.fromRGBO(255, 51, 51, 1),
            text: '50'),
        MapColorMapper(
            from: 50,
            to: 500,
            color: Color.fromRGBO(204, 0, 0, 1),
            text: '500'),
      ],
    );
  }

  @override
  void dispose() {
    _worldPopulationDensity.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildMapsWidget();
  }

  Widget _buildMapsWidget() {
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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        backgroundColor: TextThemes.ndBlue,
        flexibleSpace: FlexibleSpaceBar(
            titlePadding: EdgeInsets.only(top: 30),
            title: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    GradientText(
                      "MOOV Heatmap",
                      20,
                      gradient: LinearGradient(colors: [
                        Colors.red.shade200,
                        Colors.red.shade900,
                      ]),
                    ),
                    Text(
                      "Find tonight's hottest MOOVs, on and off campus",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontStyle: FontStyle.italic),
                    )
                  ],
                ))),
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.05,
        ),
        child: SfMapsTheme(
          data: SfMapsThemeData(
            shapeHoverColor: Color.fromRGBO(176, 237, 131, 1),
          ),
          child: Column(children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    "lib/assets/nd.png",
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover
                  ),
                  SfMaps(
                    layers: <MapLayer>[
                      MapShapeLayer(
                        loadingBuilder: (BuildContext context) {
                          return Container(
                            height: 25,
                            width: 25,
                            child: const CircularProgressIndicator(
                              strokeWidth: 10,
                            ),
                          );
                        },
                        source: _mapSource,
                        // Returns the custom tooltip for each shape.
                        shapeTooltipBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                _worldPopulationDensity[index].countryName +
                                    ' : ' +
                                    _numberFormat
                                        .format(_worldPopulationDensity[index]
                                            .density)
                                        .toString() +
                                    ' people going',
                                style: Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface)),
                          );
                        },
                        strokeColor: Colors.white30,
                        legend: MapLegend.bar(MapElement.shape,
                            position: MapLegendPosition.bottom,
                            overflowMode: MapLegendOverflowMode.wrap,
                            labelsPlacement:
                                MapLegendLabelsPlacement.betweenItems,
                            padding: EdgeInsets.only(top: 15),
                            spacing: 1.0,
                            segmentSize: Size(55.0, 9.0)),
                        tooltipSettings: MapTooltipSettings(
                            color: Color.fromRGBO(0, 32, 128, 1)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      )),
    );
  }
}

class _CountryDensity {
  _CountryDensity(this.countryName, this.density);

  final String countryName;
  final double density;
}

abstract class SampleView extends StatefulWidget {
  /// base class constructor of sample's stateful widget class
  const SampleView({Key key}) : super(key: key);
}

/// Base class of the sample's state class
abstract class SampleViewState extends State<SampleView> {
  /// Holds the SampleModel information

  /// Holds the information of current page is card view or not
  bool isCardView;

  @override
  void initState() {
    super.initState();
  }

  @override

  /// Must call super.
  void dispose() {
    super.dispose();
  }

  /// Get the settings panel content.
  Widget buildSettings(BuildContext context) {
    return null;
  }
}

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color pointColor;

  /// Holds size of the datapoint
  final num size;

  /// Holds datalabel/text value mapper of the datapoint
  final String text;

  /// Holds open value of the datapoint
  final num open;

  /// Holds close value of the datapoint
  final num close;

  /// Holds low value of the datapoint
  final num low;

  /// Holds high value of the datapoint
  final num high;

  /// Holds open value of the datapoint
  final num volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color color;

  /// Date time value of the data point
  final DateTime date;
}
