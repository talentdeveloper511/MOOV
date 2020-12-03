import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedAppBar extends StatefulWidget {
  //
  double height;
  Widget title;
  Widget leading;
  List<Widget> actions;
  Color color;
  double blurStrengthX;
  double blurStrengthY;
  //constructor
  FrostedAppBar({
    this.height,
    this.actions,
    this.blurStrengthX,
    this.blurStrengthY,
    this.color,
    this.leading,
    this.title,
  });
  //
  @override
  _FrostedAppBarState createState() => _FrostedAppBarState();
}

class _FrostedAppBarState extends State<FrostedAppBar> {
  @override
  Widget build(BuildContext context) {
    var scrSize = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            // will be 10 by default if not provided
            sigmaX: widget.blurStrengthX ?? 10,
            sigmaY: widget.blurStrengthY ?? 10,
          ),
          child: Container(
            color: widget.color, //test
            alignment: Alignment.center,
            width: scrSize.width,
            height: 80 ?? 80,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25, right: 15),
                  width: 56,
                  color: Colors.transparent,
                  child: widget.leading,
                ),
                Expanded(
                  child: Container(
                      margin: EdgeInsets.only(top: 30), child: widget.title),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Row(
                    children: widget.actions ??
                        [
                          Container(
                            width: 50,
                          )
                        ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // to clip the container
    );
  }
}
