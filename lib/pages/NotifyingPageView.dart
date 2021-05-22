import 'package:MOOV/main.dart';
import 'package:MOOV/widgets/MOTD.dart';
import 'package:flutter/material.dart';

class MOTDPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final int currentIndex;

  MOTDPageView({Key key, this.notifier, this.currentIndex}) : super(key: key);

  @override
  _MOTDPageViewState createState() => _MOTDPageViewState();
}

class _MOTDPageViewState extends State<MOTDPageView> {
  int _previousPage;
  PageController _pageController;

  void _onScroll() {
    // Consider the page changed when the end of the scroll is reached
    // Using onPageChanged callback from PageView causes the page to change when
    // the half of the next card hits the center of the viewport, which is not
    // what I want

    widget.notifier?.value = _pageController.page - _previousPage;
  }

  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.currentIndex,
      viewportFraction: 0.9,
    )..addListener(_onScroll);

    _previousPage = _pageController.initialPage;
    super.initState();
  }

  List<Widget> _pages = List.generate(
    2,
    (index) {
      return MOTD(index);
    },
  );

  @override
  Widget build(BuildContext context) {
    return PageView(
      onPageChanged: (value) {
        setState(() {});
      },
      children: _pages,
      controller: _pageController,
    );
  }
}
