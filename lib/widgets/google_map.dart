import 'package:MOOV/pages/create_account.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

typedef void Callback(String val);

class GoogleMap extends StatefulWidget {
  final Callback callback;
  final Callback callback2;

  GoogleMap({this.callback, this.callback2});

  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<GoogleMap> {
  PickResult selectedPlace;
  Future<List<Location>> locationFromAddress(
    String address, {
    String localeIdentifier,
  }) =>
      GeocodingPlatform.instance.locationFromAddress(
        address,
      );

   Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    determinePosition();
    return Container(
        height: 300,
        width: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  height: 500,
                  child: PlacePicker(
                    apiKey: "AIzaSyCXudnefDivWtB4O7nrToB-3Bu13-TEF8A",
                    initialPosition: GoogleMap.kInitialPosition,
                    useCurrentLocation: true,
                    selectInitialPosition: true,

                    //usePlaceDetailSearch: true,
                    onPlacePicked: (result) {
                      selectedPlace = result;

                      // Navigator.of(context).pop();
                      setState(() {});
                    },
                    //forceSearchOnZoomChanged: true,
                    //automaticallyImplyAppBarLeading: false,
                    //autocompleteLanguage: "ko",
                    //region: 'au',
                    //selectInitialPosition: true,
                    // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
                    //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
                    //   return isSearchBarFocused
                    //       ? Container()
                    //       : FloatingCard(
                    //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                    //           leftPosition: 0.0,
                    //           rightPosition: 0.0,
                    //           width: 500,
                    //           borderRadius: BorderRadius.circular(12.0),
                    //           child: state == SearchingState.Searching
                    //               ? Center(child: CircularProgressIndicator())
                    //               : RaisedButton(
                    //                   child: Text("Pick Here"),
                    //                   onPressed: () {
                    //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                    //                     //            this will override default 'Select here' Button.
                    //                     print("do something with [selectedPlace] data");
                    //                     Navigator.of(context).pop();
                    //                   },
                    //                 ),
                    //         );
                    // },
                    // pinBuilder: (context, state) {
                    //   if (state == PinState.Idle) {
                    //     return Icon(Icons.favorite_border);
                    //   } else {
                    //     return Icon(Icons.favorite);
                    //   }
                    // },
                  ),
                ),
              ),
              SizedBox(height: 20),

              // RaisedButton(
              //   child: Text("Load Google Map"),
              //   onPressed: () {
              //     _determinePosition();
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) {
              //           return PlacePicker(
              //             apiKey: "AIzaSyCXudnefDivWtB4O7nrToB-3Bu13-TEF8A",
              //             initialPosition: GoogleMap.kInitialPosition,
              //             useCurrentLocation: true,
              //             selectInitialPosition: true,

              //             //usePlaceDetailSearch: true,
              //             onPlacePicked: (result) {
              //               selectedPlace = result;

              //               // Navigator.of(context).pop();
              //               setState(() {});
              //             },
              //             //forceSearchOnZoomChanged: true,
              //             //automaticallyImplyAppBarLeading: false,
              //             //autocompleteLanguage: "ko",
              //             //region: 'au',
              //             //selectInitialPosition: true,
              //             // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
              //             //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              //             //   return isSearchBarFocused
              //             //       ? Container()
              //             //       : FloatingCard(
              //             //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
              //             //           leftPosition: 0.0,
              //             //           rightPosition: 0.0,
              //             //           width: 500,
              //             //           borderRadius: BorderRadius.circular(12.0),
              //             //           child: state == SearchingState.Searching
              //             //               ? Center(child: CircularProgressIndicator())
              //             //               : RaisedButton(
              //             //                   child: Text("Pick Here"),
              //             //                   onPressed: () {
              //             //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
              //             //                     //            this will override default 'Select here' Button.
              //             //                     print("do something with [selectedPlace] data");
              //             //                     Navigator.of(context).pop();
              //             //                   },
              //             //                 ),
              //             //         );
              //             // },
              //             // pinBuilder: (context, state) {
              //             //   if (state == PinState.Idle) {
              //             //     return Icon(Icons.favorite_border);
              //             //   } else {
              //             //     return Icon(Icons.favorite);
              //             //   }
              //             // },
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
              selectedPlace == null
                  ? Container()
                  : FutureBuilder(
                      future:
                          locationFromAddress(selectedPlace.formattedAddress),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return circularProgress();
                        }

                        List<String> parse =
                            (snapshot.data[0].toString().split(","));
                        String latitude1 = (parse[0]
                            .replaceAll(" ", "")
                            .replaceAll("Latitude:", ""));
                        String longtitude1 = (parse[1]
                            .replaceAll(" ", "")
                            .replaceAll("Longitude:", "")
                            .replaceAll("\n", ""));

                        double latitude = double.parse(latitude1);
                        double longtitude = double.parse(longtitude1);

                        double x = Geolocator.distanceBetween(
                            latitude, longtitude, 41.698399, -86.233917);
                        int y = (x * 3.28084).round();
                        String distancetoStadium =
                            NumberFormat.compact(locale: 'eu').format(y);

                        CreateAccount.of(context).businessLocationLatitude =
                            latitude.toString();
                        CreateAccount.of(context).businessLocationLongitude =
                            longtitude.toString();

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            children: [
                              Text(
                                selectedPlace.formattedAddress ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: TextThemes.ndBlue),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "You are $distancetoStadium ft. from Notre Dame Stadium!",
                                style: TextStyle(fontSize: 8),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
                      }),
            ],
          ),
        ));
  }
}
