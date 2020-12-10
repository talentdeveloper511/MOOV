import 'HomePage.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/models/post_model.dart';
import 'FoodFeed.dart';
import 'SportFeed.dart';
import 'ShowFeed.dart';
import 'package:MOOV/pages/PartyFeed.dart';
import 'MoovMaker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>
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
          titlePadding: EdgeInsets.all(5),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'lib/assets/moovblue.png',
                fit: BoxFit.cover,
                height: 55.0,
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
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
                                  "Our app is run by current students. Would you like to join the team?"),
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
                        onTap: () {},
                        child: CategoryButton(asset: 'lib/assets/club2.png')),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Clubs",
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
                          "Service",
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
                    padding: const EdgeInsets.only(bottom: 4.0),
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
