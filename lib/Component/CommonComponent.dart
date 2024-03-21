import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Utils/constants.dart';

Widget noInternetConnetionView() {
  return Column(
    children: [
      Expanded(
        flex: 15,
        child: LottieBuilder.asset(
          'assets/lottie/no_internet.json',
          repeat: false,
        ),
      ),
      Expanded(
        flex: 1,
        child: Container(
            color: Colors.red.withOpacity(0.2),
            child: Center(
                child: Text(
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    'No Internet Connection!'))),
      )
    ],
  );
}



Widget buildFixedRowController({
  required TextEditingController controller,
  required String label,
  required String hint,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          // Set your desired background color here
          borderRadius: BorderRadius.circular(
              10), // Optional: Add border radius for rounded corners
        ),
        child: TextFormField(
          controller: controller,
          enabled: false,
          style: TextStyle(
            color: titleColor,
            fontSize: 14,
          ),
          cursorColor: primaryColor,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder
                .none, // Optional: Remove the border of the TextFormField
          ),
        ),
      ),
      SizedBox(height: 10.0),
    ],
  );
}