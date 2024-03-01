import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:leap_flutter/Component/buttons/socal_button.dart';
import 'package:leap_flutter/pages/DashboardBottomNavigation.dart';
import 'package:lottie/lottie.dart';

import '../Utils/constants.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage(
      {Key? key, required this.toolbarTitle, required this.successDescription})
      : super(key: key);

  final String toolbarTitle;
  final String successDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          toolbarTitle,
        ),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        margin: EdgeInsets.only(right: 15, top: 20, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            LottieBuilder.asset(
              'assets/lottie/success_file.json',
              repeat: false,
            ),
            Text(
              'Thank You.',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
            ),
            SizedBox(height: 10),
            // Add some space between the texts
            Text(
              successDescription,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: titleColor.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
            ),
            SizedBox(height: 20),
            // Add some space between the text and the button
            SocalButton(
                color: primaryColor,
                icon: Icon(Icons.home, color: primaryColor, size: 16),
                press: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => DashboardBottomNavigation()),
                      (route) => false);
                },
                text: "Back to Home".toUpperCase()),
          ],
        ),
      ),
    );
  }
}
