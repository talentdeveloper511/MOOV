import 'dart:math';

import 'package:MOOV/pages/MoovMaker.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

class BusinessDirectory extends StatefulWidget {
  @override
  _BusinessDirectoryState createState() => _BusinessDirectoryState();
}

class _BusinessDirectoryState extends State<BusinessDirectory>
    with TickerProviderStateMixin {
  bool animateDealText = false;
  bool animateCrowdText = false;

  double _scaleDeal;
  double _scaleCrowd;
  AnimationController _dealController;
  AnimationController _crowdController;
  Color _color = Colors.blue[800];
  Color _color2 = Colors.purple[800];

  @override
  void initState() {
    _dealController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        HapticFeedback.lightImpact();
        setState(() {
          final random = Random();

          animateDealText = true;
          _color = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );
        });
      });
    _crowdController = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
        HapticFeedback.lightImpact();
        setState(() {
          final random = Random();

          animateCrowdText = true;
          _color2 = Color.fromRGBO(
            random.nextInt(256),
            random.nextInt(256),
            random.nextInt(256),
            1,
          );
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _dealController.dispose();
    _crowdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scaleDeal = 1 - _dealController.value;
    _scaleCrowd = 1 - _crowdController.value;

    return Scaffold(
      backgroundColor: TextThemes.ndBlue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 70),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(
                'I want to..',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
          Center(
            child: GestureDetector(
              onTapDown: _tapDown,
              onTapUp: _tapUp,
              child: Transform.scale(
                scale: _scaleDeal,
                child: _postDealButton(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 100),
            child: SizedBox(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Bobbers',
                ),
                child: animateDealText
                    ? AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                            TyperAnimatedText('Reel students in..',
                                textStyle: TextStyle(fontSize: 12),
                                speed: Duration(milliseconds: 50)),
                          ])
                    : Container(height: 15),
              ),
            ),
          ),
          SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTapDown: _tapDown2,
              onTapUp: _tapUp2,
              child: Transform.scale(
                scale: _scaleCrowd,
                child: _crowdButton(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 100),
            child: SizedBox(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Bobbers',
                ),
                child: animateCrowdText
                    ? AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                            TyperAnimatedText("Never let em down..",
                                textStyle: TextStyle(fontSize: 12),
                                speed: Duration(milliseconds: 50)),
                          ])
                    : Container(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _postDealButton() {
    return AnimatedContainer(
      onEnd: () {
        HapticFeedback.lightImpact();
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: MoovMaker(fromPostDeal: true)));
        });
      },
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      height: 70,
      width: 300,
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: _color,
            blurRadius: 12.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Center(
        child: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Post a",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: Colors.white),
                ),
                TextSpan(
                  text: ' DEAL',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: TextThemes.ndGold),
                ),
              ]),
        ),
      ),
    );
  }
    Widget _crowdButton() {
    return AnimatedContainer(
      onEnd: () {
        HapticFeedback.lightImpact();
        Future.delayed(Duration(milliseconds: 500), () {
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.topToBottom,
                  child: MoovMaker(fromPostDeal: true)));
        });
      },
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
      height: 70,
      width: 300,
      decoration: BoxDecoration(
        color: _color2,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: [
          BoxShadow(
            color: _color2,
            blurRadius: 12.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Center(
        child: RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
              style: TextStyle(
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: "Manage",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 20,
                      color: Colors.white),
                ),
                TextSpan(
                  text: ' CROWDS',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: TextThemes.ndGold),
                ),
              ]),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _dealController.forward();
  }

  void _tapUp(TapUpDetails details) {
    _dealController.reverse();
  }
   void _tapDown2(TapDownDetails details) {
    _crowdController.forward();
  }

  void _tapUp2(TapUpDetails details) {
    _crowdController.reverse();
  }
}
