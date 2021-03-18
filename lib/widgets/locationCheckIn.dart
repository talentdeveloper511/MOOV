import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// locationCheckIn(message, Function callback) {
//   return Center(
//       child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       Text(
//         message,
//         style: TextStyle(color: Colors.white, fontSize: 16),
//       ),
//       GestureDetector(
//           onTap: () {
//             callback(); // ------ this will change/rebuild the state of its parent class
//           },
//           child: Icon(
//             Icons.refresh,
//             size: 30,
//             color: Colors.white,
//           )),
//     ],
//   ));
// }

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

typedef void Callback(String val);

void locationCheckIn(BuildContext context, Function callback) {
  postsRef.where("going", arrayContains: currentUser.id).get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      if (value.docs[i]['businessPost'] == false) {
        return null;
      }
      String title = value.docs[i]['title'];
      String postId = value.docs[i]['postId'];
      Map checkInMap = value.docs[i]['checkInMap'];
      final anHourAgo = (new DateTime.now())
          .subtract(new Duration(minutes: Duration.minutesPerHour));
      final anHourPast = (new DateTime.now())
          .add(new Duration(minutes: Duration.minutesPerHour));
      DateTime startDate =
          DateTime.fromMillisecondsSinceEpoch(value.docs[i]['unix']);
      bool openWindow =
          (startDate.isBefore(anHourPast) && startDate.isAfter(anHourAgo));

      if (openWindow &&
          value.docs[i]['businessPost'] &&
          !checkInMap.keys.contains(currentUser.id) &&
          value.docs[i]['userId'] != currentUser.id) {
        //ask for location
        determinePosition();

        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
            .then((pos) {
          var distance = Geolocator.distanceBetween(
              pos.latitude,
              pos.longitude,
              value.docs[i]['businessLocation'].latitude,
              value.docs[i]['businessLocation'].longitude);
          if (distance < 600) {
            showDialog(
              context: context,
              child: CupertinoAlertDialog(
                title: Text("Check In",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                content: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(style: TextThemes.mediumbody, children: [
                      TextSpan(
                          text: "\nCheck into your MOOV, ",
                          style: TextStyle(fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: title,
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: " to redeem any offers and/or get credit!",
                          style: TextStyle(fontWeight: FontWeight.w400)),
                    ])),
                actions: [
                  CupertinoDialogAction(
                      isDefaultAction: true,
                      isDestructiveAction: true,
                      child: Text("Check in",
                          style: TextStyle(color: Colors.green)),
                      onPressed: () {
                        postsRef.doc(postId).get().then((value) {
                          postsRef.doc(postId).set({
                            "checkInMap": {currentUser.id: 1}
                          }, SetOptions(merge: true));
                        });
                        postsRef.doc(postId).set({
                          "statuses": {currentUser.id: 4}
                        }, SetOptions(merge: true));
                        FirebaseFirestore.instance
                            .collection("notreDame")
                            .doc('data')
                            .collection("checkIns")
                            .doc(postId)
                            .set({
                          "checkInList": FieldValue.arrayUnion([currentUser.id])
                        }, SetOptions(merge: true));

                        Navigator.of(context).pop(true);
                      }),
                  CupertinoDialogAction(
                      child: Text("Later"),
                      onPressed: () {
                        postsRef.doc(postId).get().then((value) {
                          postsRef.doc(postId).set({
                            "checkInMap": {currentUser.id: 0}
                          }, SetOptions(merge: true));
                        });
                        Navigator.of(context).pop(true);
                      })
                ],
              ),
            );
          }
        });
      }

      // if (value.docs.data['postLimit'] >= 1) {
      //   print(value['postLimit']);
      //   usersRef
      //       .doc(currentUser.id)
      //       .update({"postLimit": FieldValue.increment(-1)});
      //   usersRef
      //       .doc(currentUser.id)
      //       .update({"score": FieldValue.increment(100)});
      // }
    }
  });
}
