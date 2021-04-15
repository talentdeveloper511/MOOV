import 'package:MOOV/pages/post_detail.dart';
import 'package:MOOV/utils/themes_styles.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class StudentClubDashboard extends StatelessWidget {
  const StudentClubDashboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          children: [
            SizedBox(
              width: 160,
              child: ExpandableFab(
                distance: 80.0,
                children: [
                  ActionButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble, color: Colors.white),
                  ),
                  ActionButton(
                    onPressed: () {},
                    icon: const Icon(Icons.campaign, size: 30, color: Colors.white,),
                  ),
                  ActionButton(
                    onPressed: () {},
                    icon: const Icon(Icons.trending_up, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  "lib/assets/clubDash.jpeg",
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  fit: BoxFit.cover,
                ),
                Text(
                  "Club Dashboard",
                  style: TextThemes.headlineWhite,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 65.0, left: 20, right: 20),
                  child: Text("Here's your club's new best friend",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 13)),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Text("Edit", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width * .8,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            child: Center(
                                child: Text(
                              "Add your members now!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: TextThemes.ndBlue),
                            ))),
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * .2,
                    child: Column(
                      children: [Icon(Icons.person_search), Text("Recruit")],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text("Next Meeting",
                style: TextStyle(color: TextThemes.ndBlue, fontSize: 18)),
            SizedBox(height: 10),
            StudentClubMOOV(),
          ],
        ));
  }
}

class StudentClubMOOV extends StatelessWidget {
  const StudentClubMOOV({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            height: 150,
            width: 300,
            child: Stack(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: OpenContainer(
                  transitionType: ContainerTransitionType.fade,
                  transitionDuration: Duration(milliseconds: 500),
                  openBuilder: (context, _) => PostDetail("id"),
                  closedElevation: 0,
                  closedBuilder: (context, _) => FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                            "https://firebasestorage.googleapis.com/v0/b/moov4-4d3c4.appspot.com/o/images?alt=media&token=2cc05217-1041-4b9b-b427-2251b3ca429d",
                            fit: BoxFit.cover),
                      ),
                      // margin: EdgeInsets.only(left: 0, top: 5, right: 0, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    alignment: Alignment(0.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.black.withAlpha(0),
                            Colors.black,
                            Colors.black12,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "title",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Solway',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          )
        ]),
        SizedBox(height: 5),
        Container(
            height: 80,
            width: MediaQuery.of(context).size.width * .6,
            color: Colors.transparent,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Member Statuses",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Column(
                          children: [
                            Text(
                              "5",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text("Going ", style: TextStyle(fontSize: 10))
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                  color: Colors.yellow[800],
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text("Undecided", style: TextStyle(fontSize: 10))
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * .2,
                        child: Column(
                          children: [
                            Text(
                              "2",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                            Text("Not Going", style: TextStyle(fontSize: 10))
                          ],
                        ),
                      ),
                    ],
                  )
                ]))),
      ],
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key key,
    this.initialOpen,
    @required this.distance,
    @required this.children,
  }) : super(key: key);

  final bool initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 500.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton.extended(
            onPressed: _toggle,
            icon: const Icon(Icons.home_repair_service, color: Colors.white),
            label: Text("Toolkit", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key key,
    @required this.directionInDegrees,
    @required this.maxDistance,
    @required this.progress,
    @required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (3.14 / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          left: 30.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * 3.14 / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    this.onPressed,
    @required this.icon,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.accentColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    Key key,
    @required this.isBig,
  }) : super(key: key);

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0),
      height: isBig ? 200.0 : 36.0,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
