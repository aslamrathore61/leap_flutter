import 'package:flutter/material.dart';
import '../Utils/constants.dart';
import '../db/SharedPrefObj.dart';
import '../models/ServiceCountResponse.dart';
import 'HomePage.dart';
import 'MyProfilePage.dart';
import 'MyRequestPage.dart';


import 'package:flutter/material.dart';

class DashboardBottomNavigation extends StatefulWidget {
  const DashboardBottomNavigation({Key? key}) : super(key: key);

  @override
  State<DashboardBottomNavigation> createState() =>
      _DashboardBottomNavigationState();
}

class _DashboardBottomNavigationState
    extends State<DashboardBottomNavigation> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyRequestPage(dashboardFilterType: 101),
    MyProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.model_training),
              label: 'My Request',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: primaryColor,
          onTap: _onItemTapped,
          // Apply the desired font family to the BottomNavigationBarItem label text
          selectedLabelStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  DateTime? currentBackPressTime;

  Future<bool> _onBackPressed() {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        showToast('Tap again to close', Colors.green,
            const Icon(Icons.check, color: Colors.white,));
        return Future.value(false);
      }else {
        return Future.value(true);
      }

    }
  }
}
