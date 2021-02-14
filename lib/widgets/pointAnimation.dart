import 'package:flutter/material.dart';

class PointAnimation extends StatefulWidget {
  @required
  int amount;
  bool isPositive;
  PointAnimation(this.amount, this.isPositive);

  @override
  _PointAnimationState createState() =>
      _PointAnimationState(this.amount, this.isPositive);
}

class _PointAnimationState extends State<PointAnimation> {
  _PointAnimationState(this.amount, this.isPositive);
  int amount;
  bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 50,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPositive
                ? [Colors.green[400], Colors.green[300]]
                : [Colors.red[400], Colors.red[300]],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child:
      isPositive ?
       Text(
        "+$amount",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ):Text(
        "-$amount",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
