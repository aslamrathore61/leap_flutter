import 'package:flutter/material.dart';

class MyCustomColors {
  static const int _primaryColor = 0xFF28A3B3; // Your color's RGB value here
  //static const int _secondaryColor = 0xFF00FF00; // Your color's RGB value here

  static const MaterialColor primaryColor = MaterialColor(
    _primaryColor,
    <int, Color>{
      50: Color(0xFF9BCFD7), // Shades of your custom color
      700: Color(0xFF3A7E86),
      // Add more shades if needed
    },
  );
}
