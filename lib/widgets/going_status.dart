import 'package:MOOV/helpers/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoingStatus extends StatelessWidget {
  const GoingStatus({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 30),
          child: Row(
            children: <Widget>[
              Text("MOOV Status:"),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: ButtonBar(
                buttonMinWidth: MediaQuery.of(context).size.width * 0.23,
                buttonPadding: EdgeInsets.all(0),
                mainAxisSize: MainAxisSize.max,
                alignment: MainAxisAlignment.spaceEvenly,
                buttonHeight:
                    40, // this will take space as minimum as posible(to center)
                children: <Widget>[
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () => {},
                    color: Colors.green,
                    padding: EdgeInsets.only(left: 5.0, right: 5),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.favorite_border),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text(
                            "I'm going!",
                            textScaleFactor: .7,
                          ),
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () => {},
                    color: Color.fromRGBO(139, 181, 60, 1.0),
                    padding: EdgeInsets.only(left: 5.0, right: 5),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Likely",
                        textScaleFactor: .85,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () => {},
                    color: Color.fromRGBO(237, 193, 59, 1.0),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text("Unlikely",
                              textScaleFactor: .85,
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black)),
                    onPressed: () => {},
                    color: Colors.redAccent,
                    padding: EdgeInsets.only(left: 5.0, right: 5),
                    child: Row(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.cancel),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Text("Not going", textScaleFactor: .7),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        GoingBoxes()
      ],
    );
  }
}

class GoingBoxes extends StatelessWidget {
  const GoingBoxes({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.23,
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/woman.jpg'),
                    maxRadius: 10,
                    minRadius: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/me.jpg'),
                    maxRadius: 10,
                    minRadius: 10,
                  ),
                ),
              )
            ]),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(139, 181, 60, 1.0),
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.23,
        ),
        Container(
          decoration: BoxDecoration(
              color: Color.fromRGBO(237, 193, 59, 1.0),
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.23,
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.redAccent,
              border: Border.all(),
              borderRadius: BorderRadius.circular(5)),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.23,
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/woman.jpg'),
                    maxRadius: 10,
                    minRadius: 10,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3, top: 5),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: TextThemes.ndBlue,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('lib/assets/me.jpg'),
                    maxRadius: 10,
                    minRadius: 10,
                  ),
                ),
              )
            ]),
          ),
        )
      ],
    );
  }
}
