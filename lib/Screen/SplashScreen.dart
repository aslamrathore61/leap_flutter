// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'LoginScreen.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _splashscreenState();
// }
//
// class _splashscreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Start a timer to navigate after a certain duration
//     Timer(Duration(seconds: 2), () {
//       // Navigate to the main screen
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginScreen(),
//           ));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.white,
//         child: Center(
//           child: SizedBox(
//             width: 150,
//             height: 150,
//             child: Image(
//               image: AssetImage('assets/images/logo.png'),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
