// import 'package:MOOV3/pages/FoodFeed.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class MyAppBar extends AppBar {
//   MyAppBar({Key key, Widget title})
//       : super(
//             key: key,
//             title: title,
//             backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
//             actions: <Widget>[
//               IconButton(
//                 padding: EdgeInsets.all(5.0),
//                 icon: Icon(Icons.search),
//                 color: Colors.white,
//                 splashColor: Color.fromRGBO(220, 180, 57, 1.0),
//                 onPressed: () {
//                   // Implement navigation to shopping cart page here...
//                   print('Click Search');
//                 },
//               ),
//               IconButton(
//                 padding: EdgeInsets.all(5.0),
//                 icon: Icon(Icons.message),
//                 color: Colors.white,
//                 splashColor: Color.fromRGBO(220, 180, 57, 1.0),
//                 onPressed: () {
//                   // Implement navigation to shopping cart page here...
//                   print('Click Message');
//                 },
//               )
//             ]);
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: MyAppBar(
//             title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget>[
//             Image.asset(
//               'lib/assets/moovheader.png',
//               fit: BoxFit.cover,
//               height: 35.0,
//             ),
//           ],
//         )),
//         body: Container(
//           decoration:
//               BoxDecoration(color: CupertinoColors.extraLightBackgroundGray),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Stack(children: <Widget>[
//                     Container(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: Image.asset(
//                           'lib/assets/bouts.jpg',
//                           fit: BoxFit.cover,
//                         ),
//                       ),

//                       margin: EdgeInsets.only(
//                           left: 30, top: 10, right: 30, bottom: 7.5),
//                       height: 75,
//                       width: 300,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.all(
//                           Radius.circular(10),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       // constraints: BoxConstraints(
//                       //     minHeight: 40,
//                       //     maxHeight: 40,
//                       //     minWidth: 300,
//                       //     maxWidth: 300),
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Container(
//                         padding: EdgeInsets.all(33.0),
//                         alignment: Alignment(0.0, 0.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.topCenter,
//                               end: Alignment.bottomCenter,
//                               colors: <Color>[
//                                 Colors.black.withAlpha(0),
//                                 Colors.black,
//                                 Colors.black12,
//                               ],
//                             ),
//                           ),
//                           child: Text(
//                             "Baraka Bouts",
//                             style: TextStyle(
//                                 fontFamily: 'Solway',
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 fontSize: 20.0),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ]),
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Align(
//                         alignment: Alignment.center,
//                         child: Text(
//                           "MOOV of the Day",
//                           style: TextStyle(
//                               fontFamily: 'Open Sans',
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black,
//                               fontSize: 14.0),
//                         )),
//                   ),
//                 ],
//               ),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             GestureDetector(
//                               onTap: () {
//                                 navigateToFoodFeed(context);
//                               },
//                               child: Container(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.asset(
//                                     'lib/assets/foodbutton1.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 margin: EdgeInsets.only(
//                                     left: 0, top: 10, right: 0, bottom: 7.5),
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 5,
//                                       blurRadius: 7,
//                                       offset: Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 7.5),
//                               child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "Food",
//                                     style: TextStyle(
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize: 16.0),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.asset(
//                                     'lib/assets/sportbutton1.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 margin: EdgeInsets.only(
//                                     left: 0, top: 10, right: 0, bottom: 7.5),
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 5,
//                                       blurRadius: 7,
//                                       offset: Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 7.5),
//                                 child: Align(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       "Sports",
//                                       style: TextStyle(
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                           fontSize: 16.0),
//                                     )),
//                               ),
//                             ],
//                           )
//                         ]),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Container(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.asset(
//                                   'lib/assets/filmbutton1.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               margin: EdgeInsets.only(
//                                   left: 0, top: 10, right: 0, bottom: 7.5),
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 5,
//                                     blurRadius: 7,
//                                     offset: Offset(
//                                         0, 3), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 7.5),
//                               child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "Shows",
//                                     style: TextStyle(
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize: 16.0),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ]),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Column(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(10),
//                                 child: Image.asset(
//                                   'lib/assets/partybutton1.png',
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               margin: EdgeInsets.only(
//                                   left: 0, top: 10, right: 0, bottom: 7.5),
//                               height: 100,
//                               width: 150,
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(10),
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 5,
//                                     blurRadius: 7,
//                                     offset: Offset(
//                                         0, 3), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 0),
//                               child: Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     "Parties",
//                                     style: TextStyle(
//                                         fontFamily: 'Open Sans',
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                         fontSize: 16.0),
//                                   )),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                     Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: <Widget>[
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Container(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.asset(
//                                     'lib/assets/otherbutton1.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                                 margin: EdgeInsets.only(
//                                     left: 0, top: 10, right: 0, bottom: 7.5),
//                                 height: 100,
//                                 width: 150,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       spreadRadius: 5,
//                                       blurRadius: 7,
//                                       offset: Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.only(bottom: 7.5),
//                                 child: Align(
//                                     alignment: Alignment.center,
//                                     child: Text(
//                                       "More",
//                                       style: TextStyle(
//                                           fontFamily: 'Open Sans',
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.black,
//                                           fontSize: 16.0),
//                                     )),
//                               ),
//                             ],
//                           )
//                         ]),
//                   ]),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.only(right: 10),
//                     child: SizedBox(
//                       width: 170.0,
//                       height: 35.0,
//                       child: FloatingActionButton.extended(
//                         onPressed: () {},
//                         icon: Icon(Icons.arrow_forward_ios),
//                         backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
//                         label: Text("Have a MOOV?"),
//                         elevation: 15,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future navigateToFoodFeed(context) async {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => FoodFeed()));
//   }
// }
