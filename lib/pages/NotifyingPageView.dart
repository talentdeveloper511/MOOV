import 'package:MOOV/widgets/MOTD.dart';
import 'package:flutter/material.dart';

class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;

  const NotifyingPageView({Key key, this.notifier}) : super(key: key);

  @override
  _NotifyingPageViewState createState() => _NotifyingPageViewState();
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
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
      initialPage: 0,
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
        // setState(() {});
      },
      children: _pages,
      controller: _pageController,
    );
  }
}
