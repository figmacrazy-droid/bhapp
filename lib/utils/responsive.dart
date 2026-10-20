import 'package:flutter/material.dart';

class Responsive {
  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double w(BuildContext context, double size) =>
      (screenWidth(context) / 375) * size;

  static double h(BuildContext context, double size) =>
      (screenHeight(context) / 812) * size;

  static double sp(BuildContext context, double size) {
    final scale = screenWidth(context) / 375;
    return size * (scale.clamp(0.85, 1.3));
  }
}