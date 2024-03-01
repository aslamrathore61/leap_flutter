import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Resource/ApiProvider.dart';
import 'package:leap_flutter/pages/CalenderEventPage.dart';
import 'package:leap_flutter/pages/DashboardBottomNavigation.dart';
import 'package:leap_flutter/pages/LoginScreen.dart';
import 'Utils/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiProvider(),
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(color: bodyTextColor),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.all(defaultPadding),
            hintStyle: TextStyle(color: bodyTextColor),
          ),
        ),
        home: DashboardBottomNavigation(),

      ),
    );
  }
}
