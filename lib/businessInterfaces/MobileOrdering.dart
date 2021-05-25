import 'package:MOOV/businessInterfaces/CrowdManagement.dart';
import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/pages/home.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:worm_indicator/indicator.dart';
import 'package:worm_indicator/shape.dart';

class MobileOrdering extends StatelessWidget {
  MobileOrdering({Key key}) : super(key: key);

  final PageController controller =
      PageController(initialPage: 0, viewportFraction: .8);

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
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => controller.animateToPage(0,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      Icons.brunch_dining,
                      size: 30,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 5),
                    Text("Item\nOne", textAlign: TextAlign.center),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.animateToPage(1,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn),
                child: Column(
                  children: [
                    Image.asset('lib/assets/marg.png', height: 40),
                    SizedBox(height: 5),
                    Text("Item\nTwo", textAlign: TextAlign.center),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.animateToPage(2,
                    duration: Duration(seconds: 1),
                    curve: Curves.fastOutSlowIn),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      Icons.local_pizza,
                      size: 30,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 5),
                    Text("Item\nThree", textAlign: TextAlign.center),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: MobileOrderPageView(controller),
          )
        ],
      ),
    );
  }
}

class MobileOrderPageView extends StatefulWidget {
  final PageController controller;
  MobileOrderPageView(this.controller);

  @override
  _MobileOrderPageViewState createState() => _MobileOrderPageViewState();
}

class _MobileOrderPageViewState extends State<MobileOrderPageView> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 15),
        WormIndicator(
          length: 3,
          controller: widget.controller,
          shape: Shape(
              width: 135, height: 20, spacing: 0, shape: DotShape.Rectangle),
        ),
        Expanded(
          child: StreamBuilder(
              stream: usersRef.doc(currentUser.id).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return circularProgress();
                }
                Map mobileOrderMenu = snapshot.data['mobileOrderMenu'];
                return PageView(
                  controller: widget.controller,
                  children: [
                    MobileItemOne(mobileOrderMenu),
                    MobileItemTwo(mobileOrderMenu),
                    MobileItemThree(mobileOrderMenu),
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class MobileItemOne extends StatelessWidget {
  final Map mobileOrderMenu;
  MobileItemOne(this.mobileOrderMenu);

  @override
  Widget build(BuildContext context) {
    bool empty = true;

    if (mobileOrderMenu.isNotEmpty) {
      empty = false;
    }
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Card(
                  elevation: 20,
                  color: Colors.blue[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Text('Add an item',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: TextThemes.ndBlue)),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                              'Describe your item. Customers can then pay for it in advance.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: TextThemes.ndBlue)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: TextThemes.ndBlue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                  'Set your price, and any customizations.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: TextThemes.ndBlue)),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              elevation: 5.0,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.topToBottom,
                                      child: MoovMaker(fromMoovOver: true)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Set it',
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 20,
              child: CircleAvatar(
                  radius: 43,
                  backgroundColor: Colors.blue[50],
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 41,
                      child: Icon(Icons.brunch_dining,
                          size: 50, color: Colors.grey))))
        ],
      ),
    );
  }
}

class MobileItemTwo extends StatelessWidget {
  final Map mobileOrderMenu;
  MobileItemTwo(this.mobileOrderMenu);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Card(
                  elevation: 20,
                  color: Colors.pink[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Text('Margarita',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.pink[900])),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                              'Our famous margs come frozen or regular. 21+ only.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.pink[900])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.pink[900],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text("\$7 regular,\n\$10 frozen",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.pink[900])),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pink,
                              elevation: 5.0,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.topToBottom,
                                      child: MoovMaker(fromMaxOc: true)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Set it',
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 20,
              child: CircleAvatar(
                  radius: 43,
                  backgroundColor: Colors.red[50],
                  child: CircleAvatar(
                      child: Image.asset('lib/assets/marg.png', height: 70),
                      radius: 41,
                      backgroundColor: Colors.white)))
        ],
      ),
    );
  }
}

class MobileItemThree extends StatelessWidget {
  final Map mobileOrderMenu;
  MobileItemThree(this.mobileOrderMenu);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              SizedBox(height: 50),
              Card(
                  elevation: 20,
                  color: Colors.orange[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: SizedBox(
                    width: 300,
                    height: 400,
                    child: Column(
                      children: [
                        SizedBox(height: 60),
                        Text('Item three',
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: Colors.orange[900])),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Another description.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.yellow[900])),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.yellow[900],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                  "Hint: Easy-to-make items are best, customers can then easily show their receipt and grab it!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.yellow[900])),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              elevation: 5.0,
                            ),
                            onPressed: () {
                              HapticFeedback.lightImpact();

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.topToBottom,
                                      child: MoovMaker(fromMaxOc: true)));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Set it',
                                  style: TextStyle(color: Colors.white)),
                            ))
                      ],
                    ),
                  )),
            ],
          ),
          Positioned(
              top: 20,
              child: CircleAvatar(radius: 43,
                  backgroundColor: Colors.orange[50],
                  child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 41,
                      child: Icon(Icons.local_pizza,
                          size: 50, color: Colors.grey))))
        ],
      ),
    );
  }
}
