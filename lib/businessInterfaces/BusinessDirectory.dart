import 'dart:math';

import 'package:MOOV/utils/themes_styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class BusinessDirectory extends StatefulWidget {
  @override
  _BusinessDirectoryState createState() => _BusinessDirectoryState();
}

class _BusinessDirectoryState extends State<BusinessDirectory>
    with SingleTickerProviderStateMixin {
  bool animateDealText = false;
  double _scale;
  AnimationController _controller;
  Color _color = Colors.blue[800];

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 500,
      ),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
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

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
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
                scale: _scale,
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

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
