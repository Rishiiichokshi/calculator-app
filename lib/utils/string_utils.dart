import 'dart:developer';
import 'package:flutter/foundation.dart';

class StringUtils {
  static String no = "No";
  static String yes = "Yes";
  static String calcon = "CalCon";
  static String titleOneOnboarding = "More than Meets the Eye.";
  static String titleTwoOnboarding = "Currency Conversion Made Easy.";
  static String titleThreeOnboarding = "Ready to Calculate?";
  static String descriptionTwoOnboarding =
      "Stay updated with real-time rates. Swipe left to manage your currency list.";
  static String descriptionThreeOnboarding =
      "Dive in and make the most of our advanced features tailored just for you.";
  static String descriptionOneOnboarding =
      "Your go-to calculator with a twist! Rotate to landscape for scientific features.";
  static String skip = "Skip";
  static String done = "Done";

  ///Settings screen
  static String settings = "Settings";
  static String privacyPolicy = "Privacy Policy";
  static String ratingAndReviews = "Rating & Reviews";

  ///snackBar
  static String warning = "Warning";
  static String youCantRemoveDefaultCurrency =
      "You Can\'t remove default currency!!";
  static String deleteCurrencyConverter = "Delete Currency Converter";
  static String youCantDeleteDefaultUsdConverter =
      "'You can\'t delete the default USD converter!'";
  static String areYouSureYouWantToDeleteCurrencyConverter =
      "Are you sure you want to delete this currency converter?";

  ///currency Converter Screen
  static String currencyConvertor = "Currency Convertor";
  static String usd = "USD";
  static String searchCurrency = "Search Currency";
  static String delete = "Delete";
  static String selectCurrency = "Select Currency";
  static String egHundred = "eg. 100";
  static String addCurrency = "Add Currency";
  static String invalidInput = "Invalid input";
}

logs(String msg) {
  if (kDebugMode) {
    log(msg);
  }
}
