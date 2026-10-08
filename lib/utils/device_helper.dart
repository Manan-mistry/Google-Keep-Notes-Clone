import 'dart:io';
import 'dart:math';
import 'package:keeps_note_clone/utils/log_print.dart';
import 'package:flutter/material.dart';

class DeviceHelper {
  static double get _ppi => (Platform.isAndroid || Platform.isIOS) ? 150 : 96;

  static bool isLandscape(BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  // PIXELS
  static Size size(BuildContext context) => MediaQuery.of(context).size;
  static double width(BuildContext context) => size(context).width;
  static double height(BuildContext context) => size(context).height;

  static double diagonal(BuildContext context) {
    Size s = size(context);
    return sqrt((s.width * s.width) + (s.height * s.height));
  }

  // INCHES
  static Size inches(BuildContext context) {
    Size pxSize = size(context);
    return Size(pxSize.width / _ppi, pxSize.height / _ppi);
  }

  static double widthInches(BuildContext context) => inches(context).width;
  static double heightInches(BuildContext context) => inches(context).height;
  static double diagonalInches(BuildContext context) => diagonal(context) / _ppi;

  // Helper method to determine if the device is a tablet
  static bool isTablet(BuildContext context) {
    return diagonalInches(context) >= 7.0; // Considering tablets have screens 7 inches or larger
  }

  // Helper method to determine if the device is a large phone
  static bool isLargePhone(BuildContext context) {
    return diagonal(context) > 720.0; // Considering large phones have diagonal pixel size > 720
  }

  // Helper method to determine if the device has a narrow screen
  static bool isNarrow(BuildContext context) {
    return widthInches(context) < 3.5; // Considering narrow screens are less than 3.5 inches wide
  }

}