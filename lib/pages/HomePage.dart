import 'package:MOOV3/pages/FoodFeed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        appBar: MyAppBar(
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
        )),
        body: Container(
          decoration:
              BoxDecoration(color: CupertinoColors.extraLightBackgroundGray),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _Motd(),
              Expanded(flex: 10, child: _FirstRow()),
              Expanded(flex: 10, child: _SecondRow()),
              Expanded(flex: 3, child: _HaveMOOVButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Motd extends StatelessWidget {
  //MOOV Of The Day
  const _Motd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(children: <Widget>[
          FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'lib/assets/bouts.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
              margin:
                  EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 7.5),
              height: 75,
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
              padding: EdgeInsets.all(33.0),
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
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
              alignment: Alignment.center,
              child: Text(
                "MOOV of the Day",
                style: TextStyle(
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 14.0),
              )),
        ),
      ],
    );
  }
}

class _FirstRow extends StatelessWidget {
  const _FirstRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future navigateToFoodFeed(context) async {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FoodFeed()));
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      navigateToFoodFeed(context);
                    },
                    child: CategoryButton(asset: 'lib/assets/foodbutton1.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 7.5),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Food",
                          style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16.0),
                        )),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 7.5, right: 7.5),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CategoryButton(
                          asset: 'lib/assets/sportbutton1.png',
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 7.5),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Sports",
                                style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16.0),
                              )),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CategoryButton(asset: 'lib/assets/filmbutton1.png'),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 7.5),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Shows",
                              style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16.0),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]);
  }
}

class _SecondRow extends StatelessWidget {
  const _SecondRow({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 3.75),
          child: Column(
            children: <Widget>[
              CategoryButton(asset: 'lib/assets/partybutton1.png'),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.5),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Parties",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    )),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.only(left: 3.75, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CategoryButton(asset: 'lib/assets/otherbutton1.png'),
              Padding(
                padding: const EdgeInsets.only(bottom: 7.5),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "More",
                      style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _HaveMOOVButton extends StatelessWidget {
  const _HaveMOOVButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 7.5, bottom: 7.5),
          child: SizedBox(
            height: 35.0,
            child: FloatingActionButton.extended(
              onPressed: () {},
              icon: Icon(Icons.arrow_forward_ios),
              backgroundColor: Color.fromRGBO(2, 43, 91, 1.0),
              label: Text("Have a MOOV?"),
              elevation: 15,
            ),
          ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          (asset),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.only(left: 0, top: 10, right: 0, bottom: 7.5),
      height: 100,
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
