import 'package:flutter/material.dart';

class SecondCarousel extends StatelessWidget {
  const SecondCarousel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      width: MediaQuery.of(context).size.width * .89,
      child: Row(
        children: [
          Text("Find Friends", style: TextStyle(fontSize: 40),),
          Text("Find Everyone", style: TextStyle(fontSize: 40),),
        ],
      ),
    );
  }
}
