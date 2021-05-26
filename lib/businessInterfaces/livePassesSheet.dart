import 'package:MOOV/pages/home.dart';
import 'package:MOOV/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LivePassesSheet extends StatefulWidget {
  final List livePasses;
  LivePassesSheet(this.livePasses);

  @override
  _LivePassesSheetState createState() => _LivePassesSheetState();
}

class _LivePassesSheetState extends State<LivePassesSheet> {
  bool isLoading = false;
  bool success = false;

  @override
  Widget build(BuildContext context) {
    print(widget.livePasses);
    return (isLoading)
        ? linearProgress()
        : (success)
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Redeemed!"),
                SizedBox(height: 40),
                Icon(
                  Icons.check,
                  size: 100,
                  color: Colors.white,
                )
              ])
            : Container(
                color: Colors.green,
                margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                height: 600,
                width: MediaQuery.of(context).size.width * .95,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Colors.blue[50],
                          child: CircleAvatar(
                            radius: 85,
                            backgroundImage:
                                NetworkImage(widget.livePasses[0]['photo']),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: Text(
                          widget.livePasses[0]['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                      SizedBox(height: 30),
                      PulsatingCircleIconButton(widget.livePasses),
                    ]),
              );
  }
}

class PulsatingCircleIconButton extends StatefulWidget {
  final List livePasses;
  const PulsatingCircleIconButton(this.livePasses);
  @override
  _PulsatingCircleIconButtonState createState() =>
      _PulsatingCircleIconButtonState();
}

class _PulsatingCircleIconButtonState extends State<PulsatingCircleIconButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  bool _confirming = false;
  Color _color = Color.fromARGB(255, 27, 28, 30);

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 15.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onDoubleTap: _confirming
            ? () {
                usersRef.doc(currentUser.id).set(
                    {"livePasses": FieldValue.arrayRemove(widget.livePasses)},
                    SetOptions(merge: true));

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (Route<dynamic> route) => false,
                );
              }
            : () {
                setState(() {
                  _color = Colors.red;
                  _confirming = !_confirming;
                });
              },
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          width: 300,
          height: 300,
          child: Center(
              child: Stack(
            children: [
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: !_confirming ? 1 : 0,
                child: Center(
                  child: Text("RESTAURANT STAFF\n\nDOUBLE TAP",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                opacity: !_confirming ? 0 : 1,
                child: Center(
                  child: Text("DOUBLE TAP\n\nTO CONFIRM",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              shape: BoxShape.rectangle,
              color: _color,
              boxShadow: [
                BoxShadow(
                    color: Colors.green[50],
                    blurRadius: _animation.value,
                    spreadRadius: _animation.value)
              ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
