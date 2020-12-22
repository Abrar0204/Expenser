// import 'package:Expenser/monthlyview.dart';
import 'package:Expenser/settings.dart';

import 'package:flutter/material.dart';

import 'dailyview.dart';

import 'monthview.dart';

class ExpenserTabScaffold extends StatefulWidget {
  final String name;
  final double salary;
  final Function logout;
  const ExpenserTabScaffold({
    Key key,
    this.name,
    this.salary,
    this.logout,
  }) : super(key: key);

  @override
  _ExpenserTabScaffoldState createState() => _ExpenserTabScaffoldState();
}

class _ExpenserTabScaffoldState extends State<ExpenserTabScaffold> {
  var currentIndex = 0;
  List<BottomNavigationBarItem> tabItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home,
      ),
      // title: SizedBox.shrink(),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.pie_chart,
      ),
      // title: SizedBox.shrink(),
      label: 'Charts',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.settings,
      ),
      // title: SizedBox.shrink(),
      label: 'Settings',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: BottomNavigationBar(
        items: tabItems,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      body: SafeArea(
        child: currentIndex == 0
            ? DailyView()
            : currentIndex == 1
                ? MonthView()
                : Settings(),
      ),
    );
  }
}
