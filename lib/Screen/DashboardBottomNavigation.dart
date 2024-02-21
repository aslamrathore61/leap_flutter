import 'package:flutter/material.dart';
import 'package:leap_flutter/Utils/MyCustomColors.dart';
import 'HomeScreen.dart';
import 'MyProfile.dart';
import 'MyRequest.dart';


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
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MyRequest(),
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
        selectedItemColor:MyCustomColors.primaryColor,
        onTap: _onItemTapped,
        // Apply the desired font family to the BottomNavigationBarItem label text
        selectedLabelStyle: TextStyle(fontFamily: 'Roboto',fontSize: 14),
      ),
    );
  }
}
