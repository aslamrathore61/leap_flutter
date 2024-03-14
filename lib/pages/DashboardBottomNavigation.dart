import 'package:flutter/material.dart';
import '../Utils/constants.dart';
import '../db/SharedPrefObj.dart';
import '../models/ServiceCountResponse.dart';
import 'HomePage.dart';
import 'MyProfile.dart';
import 'MyRequestPage.dart';


class DashboardBottomNavigation extends StatefulWidget {
  const DashboardBottomNavigation({super.key});

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
    MyProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
