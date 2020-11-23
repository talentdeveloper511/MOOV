import 'package:MOOV/helpers/demo_values.dart';
import 'package:MOOV/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentedControl extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SegmentedControlState();
  }
}

class SegmentedControlState extends State<SegmentedControl> {
  Map<int, Widget> map =
      new Map(); // Cupertino Segmented Control takes children in form of Map.
  List<Widget>
      childWidgets; //The Widgets that has to be loaded when a tab is selected.
  int selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    loadCupertinoTabs(); //Method to add Tabs to the Segmented Control.
    loadChildWidgets(); //Method to add the Children as user selected.
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CupertinoSegmentedControl(
          onValueChanged: (value) {
//Callback function executed when user changes the Tabs
            setState(() {
              selectedIndex = value;
            });
          },
          groupValue: selectedIndex, //The current selected Index or key
          selectedColor: Color.fromRGBO(
              2, 43, 91, 1.0), //Color that applies to selecte key or index
          pressedColor: Color.fromRGBO(220, 180, 57,
              1.0), //The color that applies when the user clicks or taps on a tab
          unselectedColor: Colors
              .grey, // The color that applies to the unselected tabs or inactive tabs
          children: map, //The tabs which are assigned in the form of map
          padding: EdgeInsets.all(10),
          borderColor: Color.fromRGBO(2, 43, 91, 1.0),
        ),
        Expanded(
          child: getChildWidget(),
        ),
      ],
    );
  }

  void loadCupertinoTabs() {
    map = new Map();
    map = {
      0: Container(
          width: 100,
          child: Center(
            child: Text(
              "Featured",
              style: TextStyle(color: Colors.white),
            ),
          )),
      1: Container(
          width: 100,
          child: Center(
            child: Text(
              "All",
              style: TextStyle(color: Colors.white),
            ),
          )),
      2: Container(
          width: 100,
          child: Center(
            child: Text(
              "Friends",
              style: TextStyle(color: Colors.white),
            ),
          ))
    };

//     for (int i = 0; i < 3; i++) {
// //putIfAbsent takes a key and a function callback that has return a value to that key.
// // In our example, since the Map is of type <int,Widget> we have to return widget.
//       map.putIfAbsent(
//           i,
//           () => Container(
//               width: 100,
//               child: Text(
//                 "Tab $i",
//                 style: TextStyle(color: Colors.white),
//               )));
//     }
  }

  void loadChildWidgets() {
    childWidgets = [
      ListView.builder(
          itemCount: 2, //DemoValues.posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(postData: DemoValues.posts[index]);
          }),
      ListView.builder(
          itemCount: 2, //DemoValues.posts.length,
          itemBuilder: (BuildContext context, int index) {
            return PostCard(postData: DemoValues.posts[index]);
          }),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Aw, you have no friends! Add some now.",
              ),
            ),
            FloatingActionButton.extended(
                onPressed: () {
                  // Add your onPressed code here!
                },
                label: Text('Add Friends'),
                icon: Icon(Icons.person_add),
                backgroundColor: Color.fromRGBO(220, 180, 57, 1.0)),
          ],
        ),
      )
    ];
  }

  Widget getChildWidget() => childWidgets[selectedIndex];
}
