import 'package:MOOV/helpers/themes.dart';
import 'package:MOOV/models/post_model.dart';
import 'package:MOOV/pages/FoodFeed.dart';
import 'package:MOOV/pages/SportFeed.dart';
import 'package:MOOV/pages/ShowFeed.dart';
import 'package:MOOV/pages/PartyFeed.dart';
import 'package:MOOV/pages/ManagerPage.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/search.dart';
import 'package:MOOV/pages/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class MyAppBar extends AppBar {
  MyAppBar({Key key, Widget title})
      : super(
            key: key,
            title: title,
            backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.search),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Search');
                },
              ),
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.message),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Message');
                },
              )
            ]);
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _hideFabAnimController;
  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 1,
    );

    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
  }

  Widget build(BuildContext context) {
    Future navigateToFoodFeed(context) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FoodFeed()));
    }

    Future navigateToSportFeed(context) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SportFeed()));
    }

    Future navigateToShowFeed(context) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowFeed()));
    }

    Future navigateToPartyFeed(context) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PartyFeed()));
    }

    return Scaffold(
      floatingActionButton: FadeTransition(
        opacity: _hideFabAnimController,
        child: ScaleTransition(
          scale: _hideFabAnimController,
          child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MoovMaker(postModel: PostModel())),
                );
              },
              label: const Text("What's the Moov?",
                  style: TextStyle(fontSize: 16, color: Colors.white))),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: TextThemes.ndBlue,
            //pinned: true,
            floating: true,
            actions: <Widget>[
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.search),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
                  // Implement navigation to shopping cart page here...
                  print('Click Search');
                },
              ),
              IconButton(
                padding: EdgeInsets.all(5.0),
                icon: Icon(Icons.message),
                color: Colors.white,
                splashColor: Color.fromRGBO(220, 180, 57, 1.0),
                onPressed: () {
                  // Implement navigation to shopping cart page here...
                  print('Click Message');
                },
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.all(5),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'lib/assets/moovheader.png',
                    fit: BoxFit.cover,
                    height: 45.0,
                  ),
                  Image.asset(
                    'lib/assets/ndlogo.png',
                    fit: BoxFit.cover,
                    height: 25,
                  )
                ],
              ),
            ),
          ),
          // SliverFixedExtentList(
          //   itemExtent: 50,
          //   delegate: SliverChildListDelegate([
          //     Container(color: Colors.red),
          //     Container(color: Colors.green),
          //     Container(color: Colors.blue),
          //   ]),
          // ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (context, index) {
          //       return Container(
          //         height: 50,
          //         alignment: Alignment.center,
          //         color: Colors.orange[100 * (index % 9)],
          //         child: Text('orange $index'),
          //       );
          //     },
          //     childCount: 9,
          //   ),
          // ),
          // SliverPadding(
          //   padding: EdgeInsets.only(left: 10, right: 10),
          //   sliver: SliverGrid(
          //     delegate: SliverChildBuilderDelegate(
          //       (context, index) {
          //         return Container(
          //           alignment: Alignment.center,
          //           color: Colors.teal[100 * (index % 9)],
          //           child: Text('grid item $index'),
          //         );
          //       },
          //       childCount: 30,
          //     ),
          //     // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          //     //   maxCrossAxisExtent: 200.0,
          //     //   mainAxisSpacing: 10.0,
          //     //   crossAxisSpacing: 10.0,
          //     //   childAspectRatio: 4.0,
          //     // ),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 3,
          //       mainAxisSpacing: 15,
          //       crossAxisSpacing: 15,
          //       childAspectRatio: .75,
          //     ),
          //   ),
          // ),
          SliverPadding(
            padding: EdgeInsets.only(left: 0, right: 0),
            sliver: SliverGrid.count(
              crossAxisCount: 1,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 2.25,
              children: <Widget>[
                Container(
                  child: Motd(),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .75,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            navigateToFoodFeed(context);
                          },
                          child: CategoryButton(
                              asset: 'lib/assets/foodbutton1.png')),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Food",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToSportFeed(context);
                        },
                        child: CategoryButton(
                            asset: 'lib/assets/sportbutton1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Sports",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToShowFeed(context);
                        },
                        child: CategoryButton(
                            asset: 'lib/assets/filmbutton1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Shows",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.1,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          navigateToPartyFeed(context);
                        },
                        child: CategoryButton(
                            asset: 'lib/assets/partybutton1.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Parties",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/otherbutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Surprise",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("Join us."),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  "Our app is run by current students. Would you like to join the team? Email kcamson@nd.edu."),
                            ),
                          ),
                      barrierDismissible: true);
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  color: Color.fromRGBO(249, 249, 249, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, bottom: 2, top: 10),
                        child: RichText(
                          textScaleFactor: 1.75,
                          text:
                              TextSpan(style: TextThemes.mediumbody, children: [
                            TextSpan(text: "Made ", style: TextStyle()),
                            TextSpan(text: "by", style: TextThemes.italic),
                            TextSpan(text: " students"),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Center(
                          child: RichText(
                            textScaleFactor: 1.75,
                            text: TextSpan(
                                style: TextThemes.mediumbody,
                                children: [
                                  TextSpan(
                                      text: "with", style: TextThemes.italic),
                                  TextSpan(text: " students"),
                                ]),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 2, right: 35.0, bottom: 10),
                          child: RichText(
                            textScaleFactor: 1.75,
                            text: TextSpan(
                                style: TextThemes.mediumbody,
                                children: [
                                  TextSpan(
                                      text: "for", style: TextThemes.italic),
                                  TextSpan(text: " students"),
                                ]),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 20),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .75,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CategoryButton(asset: 'lib/assets/studybutton1.png'),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Study",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/govbutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Gov",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/massbutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Mass",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            sliver: SliverGrid.extent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 15.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 1.1,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/volunteerbutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Volunteer",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/charitybutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Charity",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            sliver: SliverGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: .75,
              children: <Widget>[
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CategoryButton(asset: 'lib/assets/tailgatebutton1.png'),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Tailgates",
                            style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16.0),
                          ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/gamesbutton1.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Games",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CategoryButton(asset: 'lib/assets/otherbutton2.png'),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Other",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        ))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // return MaterialApp(
    //   home: Scaffold(
    //     backgroundColor: CupertinoColors.lightBackgroundGray,
    //     appBar: MyAppBar(
    //         title: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: <Widget>[
    //         Image.asset(
    //           'lib/assets/moovheader.png',
    //           fit: BoxFit.cover,
    //           height: 45.0,
    //         ),
    //         Image.asset(
    //           'lib/assets/ndlogo.png',
    //           fit: BoxFit.cover,
    //           height: 25,
    //         )
    //       ],
    //     )),
    //     body: Container(
    //       decoration:
    //           BoxDecoration(color: CupertinoColors.extraLightBackgroundGray),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.max,
    //         children: <Widget>[
    //           Expanded(flex: 5, child: Motd()),
    //           Expanded(flex: 5, child: _FirstRow()),
    //           Expanded(flex: 5, child: _SecondRow()),
    //           Expanded(flex: 1, child: _HaveMOOVButton()),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

class Motd extends StatelessWidget {
  //MOOV Of The Day
  const Motd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.15,
          child: Stack(children: <Widget>[
            FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'lib/assets/bouts.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                margin:
                    EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 7.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment(0.0, 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black.withAlpha(0),
                        Colors.black,
                        Colors.black12,
                      ],
                    ),
                  ),
                  child: Text(
                    "Baraka Bouts",
                    style: TextStyle(
                        fontFamily: 'Solway',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => CupertinoAlertDialog(
                            title: Text("Your MOOV."),
                            content: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                  "Do you have the MOOV of the Day? Email kcamson@nd.edu."),
                            ),
                          ),
                      barrierDismissible: true);
                },
                child: Card(
                  borderOnForeground: true,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "MOOV of the Day",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }
}

class CategoryButton extends StatelessWidget {
  CategoryButton({@required this.asset});
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height:
      height: MediaQuery.of(context).size.height * 0.15,

      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          (asset),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 7.5),
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
