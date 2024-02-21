import 'package:flutter/material.dart';

import '../Screen/CreationOptionScreen.dart';
import '../Screen/DashboardBottomNavigation.dart';

class GlabblePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  GlabblePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var opacityAnimation = animation.drive(tween);

            return FadeTransition(
              opacity: opacityAnimation,
              child: child,
            );
          },
        );
}
