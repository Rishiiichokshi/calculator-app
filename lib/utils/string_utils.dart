import 'dart:developer';

import 'package:flutter/foundation.dart';

class StringUtils {
  static String no = "No";
  static String yes = "Yes";
  static String flutterCalculator = "Flutter Calculator";
  static String titleOneOnboarding = "More than Meets the Eye.";
  static String titleTwoOnboarding = "Currency Conversion Made Easy.";
  static String titleThreeOnboarding = "Ready to Calculate?";
  static String descriptionTwoOnboarding =
      "Stay updated with real-time rates. Swipe left to manage your currency list.";
  static String descriptionThreeOnboarding =
      "Dive in and make the most of our advanced features tailored just for you.";
  static String descriptionOneOnboarding =
      "Your go-to calculator with a twist! Rotate to landscape for scientific features.";
}

logs(String msg) {
  if (kDebugMode) {
    log(msg);
  }
}
