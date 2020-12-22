
import 'package:MOOV/helpers/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: TextThemes.ndBlue,
          //pinned: true,
          floating: false,
          expandedHeight: 30.0,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('FRIEND FINDER',
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 100,
          delegate: SliverChildListDelegate([
            Container(
                color: Colors.grey[300],
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: TextThemes.ndBlue,
                        child: CircleAvatar(
                          backgroundImage: AssetImage('lib/assets/me.jpg'),
                          maxRadius: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text('Kevin Camson is',
                          style: TextStyle(
                              fontSize: 14,
                              color: TextThemes.ndBlue,
                              decoration: TextDecoration.none)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 3.0, right: 5),
                      child: Text('Going',
                          style: TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.activeGreen,
                              decoration: TextDecoration.none)),
                    ),
                    Text('to',
                        style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.black,
                            decoration: TextDecoration.none)),
                    Padding(
                      padding: const EdgeInsets.only(top: 32, left: 0.0),
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/assets/chens.jpg',
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('J.W. Chens',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: CupertinoColors.black,
                                    decoration: TextDecoration.none)),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ]),
        ),
      ],
    );
  }
}
