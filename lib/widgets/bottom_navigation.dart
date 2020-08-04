import 'package:MOOV3/helpers/themes.dart';
import 'package:flutter/material.dart';
import 'package:MOOV3/pages/pages.dart';

class MyBottomNavigation extends StatelessWidget {
  const MyBottomNavigation({Key key, this.pages, this.onSelectPage})
      : super(key: key);
  final Pages pages;
  final ValueChanged<Pages> onSelectPage;

  Color _color(Pages pages) => this.pages == pages ? TextThemes.ndGold : Colors.grey;

  static const Map<Pages, IconData> icons = {
    Pages.home: Icons.home,
    Pages.moovs: Icons.directions_run,
    Pages.profile: Icons.person,
//    Page.nested: Icons.table_chart,
  };
  static const Map<Pages, String> names = {
    Pages.home: 'Home',
    Pages.moovs: 'My MOOVs',
    Pages.profile: 'Profile',
//    Page.nested: 'nested',
  };

  BottomNavigationBarItem _buildItem(Pages pages) {
    return BottomNavigationBarItem(
      icon: Icon(
        icons[pages],
        color: _color(pages),
      ),
      title: Text(
        names[pages],
        style: TextStyle(
          color: _color(pages),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: Pages.values.map(_buildItem).toList(),
      onTap: (index) => onSelectPage(Pages.values[index]),
    );
  }
}