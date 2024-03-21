import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

// clolors that we use in our app
const titleColor = Color(0xFF010F07);
const borderColor = Color(0xFF2B2B2B);
const primaryColor = Color(0xFF28A3B3);
const accentColor = Color(0xFFEF9920);
const bodyTextColor = Color(0xFF868686);
const inputColor = Color(0xFFFBFBFB);

// key name we use in as sharePref
const String bearerToken = 'bearerToken';
const String loginStatus = "loginStatus";
const String profileDetails = "profileDetails";
const String serviceCount = "serviceCount";

const double defaultPadding = 16;
const Duration kDefaultDuration = Duration(milliseconds: 250);

const TextStyle kButtonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);

const EdgeInsets kTextFieldPadding = EdgeInsets.symmetric(
  horizontal: defaultPadding,
  vertical: defaultPadding,
);

// Text Field Decoration
const OutlineInputBorder kDefaultOutlineInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(10)),
  borderSide: BorderSide(
    color: Color(0xFF3A7E86),
  ),
);

const InputDecoration otpInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.zero,
  counterText: "",
  errorStyle: TextStyle(height: 0),
);

const kErrorBorderSide = BorderSide(color: Colors.red, width: 1);

// Validator
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'This password field is required'),
  MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-/])',
      errorText: 'Passwords must have at least one special character')
]);

final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: 'Enter a valid email address')
]);

RequiredValidator requiredValidator(String fieldName) {
  return RequiredValidator(
    errorText: 'Please Enter $fieldName',
  );
}

final matchValidator = MatchValidator(errorText: 'passwords do not match');

MinLengthValidator minLengthValidator(String fieldName) {
  return MinLengthValidator(
    10,
    errorText: '$fieldName  Must be 10 Digits Long',
  );
}

final phoneNumberValidator = MinLengthValidator(10,
    errorText: 'Phone Number must be at least 10 digits long');

// Common Text
final Center kOrText = Center(
    child: Text("Or", style: TextStyle(color: titleColor.withOpacity(0.7))));

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showToast(String message, Color color, Icon icon) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: color,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showErrorDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(msg),
        //  content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Close the dialog
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

String capitalizeFirstLetterOfEachWord(String? input) {
  List<String> words = input!.split(' ');
  List<String> capitalizedWords = words.map((word) {
    if (word.isEmpty) {
      return '';
    }
    return word[0].toUpperCase() + word.substring(1);
  }).toList();
  return capitalizedWords.join(' ');
}

Color getColorFromHex(String hexColor) {
  hexColor = hexColor.replaceAll('#', '');
  return Color(int.parse('0xFF$hexColor'));
}

Color getRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    // Generates a random value between 0 and 255 for the red channel
    random.nextInt(256),
    // Generates a random value between 0 and 255 for the green channel
    random.nextInt(
        256), // Generates a random value between 0 and 255 for the blue channel
  );
}

Widget noDataFoundWidget() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/lottie/no_data_found.json',
          width: 260,
          height: 260,
          fit: BoxFit.cover,
        ),
      ],
    ),
  );
}

Future<String?> cropImage(File imgFile) async {
  final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Image Cropper",
            toolbarColor: primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: "Image Cropper",
        )
      ]);

  if (croppedFile != null) {
    return croppedFile.path;
  }

  return null;
}

Future<bool?> showConfirmationDialog(
    BuildContext context, String title, String content) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceled
            },
          ),
          TextButton(
            child: Text("Yes"),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirmed
            },
          ),
        ],
      );
    },
  );
}

void showPermissionSettingsDialog(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Permission Required'),
      content: Text('$msg'),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await openAppSettings();
          },
          child: Text('Open Settings'),
        ),
      ],
    ),
  );
}
