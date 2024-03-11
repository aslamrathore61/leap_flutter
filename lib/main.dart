import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leap_flutter/Resource/ApiProvider.dart';
import 'package:leap_flutter/pages/DashboardBottomNavigation.dart';
import 'package:leap_flutter/pages/LoginScreen.dart';
import 'Utils/constants.dart';
import 'db/SharedPrefObj.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<bool> isLoggedIn() async {
    String? token = await SharedPrefObj.getSharedPrefValue(bearerToken);
    if (token != null && token.isNotEmpty) {
      return true; // For example, return true if the user is logged in
    } else {
      return false;
    }
  }

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
        //  home: LoginScreenPage(),
        home: FutureBuilder<bool>(
          future: isLoggedIn(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show a loading indicator while checking the login status
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data == true) {
                return DashboardBottomNavigation(); // User is logged in, show the dashboard
              } else {
                return LoginScreenPage(); // User is not logged in, show the login screen
              }
            }
          },
        ),
      ),
    );
  }
}
