import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';
import '../../utils/string_utils.dart';
import '../webView_screen.dart';
// https://medium.com/@app.writespace/calcon-privacy-policy-aae55453da9a

enum Availability { loading, available, unavailable }

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  // _launchPlayStore() async {
  //   const playStoreUrl =
  //       'https://play.google.com/store/apps/details?id=YOUR_APP_PACKAGE_NAME';
  //   if (await canLaunch(playStoreUrl)) {
  //     await launch(playStoreUrl);
  //   } else {
  //     throw 'Could not launch Play Store URL';
  //   }
  // }

  _launchAppStore() async {
    //calone app id--6469779310
    const iOSAppId = '6469779310'; // Replace with your app's iOS App ID
    const url = 'itms-apps://itunes.apple.com/app/id$iOSAppId?mt=8';

    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch App Store URL');
      }
    } catch (e) {
      print('Error launching App Store URL: $e');
    }
  }

  WidgetBuilder builder = buildProgressIndicator;
  static Widget buildProgressIndicator(BuildContext context) =>
      const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    // In this snippet, I'm giving a value to all parameters.
// Please note that not all are required (those that are required are marked with the @required annotation).

    // RateMyApp rateMyApp = RateMyApp(
    //   preferencesPrefix: 'rateMyApp_',
    //   minDays: 7,
    //   minLaunches: 10,
    //   remindDays: 7,
    //   remindLaunches: 10,
    //   googlePlayIdentifier: 'fr.skyost.example',
    //   appStoreIdentifier: '6469779310',
    // );
    //
    // rateMyApp.init().then((_) {
    //   if (rateMyApp.shouldOpenDialog) {
    //     rateMyApp.showRateDialog(
    //       context,
    //       title: 'Rate this app', // The dialog title.
    //       message:
    //           'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
    //       rateButton: 'RATE', // The dialog "rate" button text.
    //       noButton: 'NO THANKS', // The dialog "no" button text.
    //       laterButton: 'MAYBE LATER', // The dialog "later" button text.
    //       listener: (button) {
    //         // The button click listener (useful if you want to cancel the click event).
    //         switch (button) {
    //           case RateMyAppDialogButton.rate:
    //             print('Clicked on "Rate".');
    //             break;
    //           case RateMyAppDialogButton.later:
    //             print('Clicked on "Later".');
    //             break;
    //           case RateMyAppDialogButton.no:
    //             print('Clicked on "No".');
    //             break;
    //         }
    //
    //         return true; // Return false if you want to cancel the click event.
    //       },
    //       ignoreNativeDialog: Platform
    //           .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
    //       dialogStyle: const DialogStyle(), // Custom dialog styles.
    //       onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
    //           .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    //       // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
    //       // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
    //     );
    //
    //     // Or if you prefer to show a star rating bar (powered by `flutter_rating_bar`) :
    //
    //     rateMyApp.showStarRateDialog(
    //       context,
    //       title: 'Rate this app', // The dialog title.
    //       message:
    //           'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
    //       // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
    //       actionsBuilder: (context, stars) {
    //         // Triggered when the user updates the star rating.
    //         return [
    //           // Return a list of actions (that will be shown at the bottom of the dialog).
    //           TextButton(
    //             child: Text('OK'),
    //             onPressed: () async {
    //               print('Thanks for the ' +
    //                   (stars == null ? '0' : stars.round().toString()) +
    //                   ' star(s) !');
    //               // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
    //               // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
    //               await rateMyApp
    //                   .callEvent(RateMyAppEventType.rateButtonPressed);
    //               Navigator.pop<RateMyAppDialogButton>(
    //                   context, RateMyAppDialogButton.rate);
    //             },
    //           ),
    //         ];
    //       },
    //       ignoreNativeDialog: Platform
    //           .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
    //       dialogStyle: const DialogStyle(
    //         // Custom dialog styles.
    //         titleAlign: TextAlign.center,
    //         messageAlign: TextAlign.center,
    //         messagePadding: EdgeInsets.only(bottom: 20),
    //       ),
    //       starRatingOptions:
    //           const StarRatingOptions(), // Custom star bar rating options.
    //       onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
    //           .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    //     );
    //   }
    // });
    var themeController = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: themeController.isDark
          ? DarkColors.currencyScaffoldBgColor
          : LightColors.scaffoldBgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              size: 5.w,
              Icons.arrow_back,
              color: themeController.isDark ? Colors.white : Colors.black,
            )),
        centerTitle: true,
        backgroundColor: themeController.isDark
            ? DarkColors.currencyScaffoldBgColor
            : LightColors.scaffoldBgColor,
        title: Text(
          StringUtils.settings,
          style: TextStyle(
              fontSize: 5.w,
              color: themeController.isDark
                  ? CommonColors.white
                  : CommonColors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Get.to(() => const MyWebView());
              },
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 18.sp,
                    color: themeController.isDark ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    StringUtils.privacyPolicy,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            Divider(color: Colors.grey, thickness: 0.2.sp),
            SizedBox(height: 1.5.h),
            InkWell(
              onTap: () {
                // rateMyApp;
                _launchAppStore();
              },
              child: Row(
                children: [
                  Icon(
                    Icons.star_rate_rounded,
                    size: 18.sp,
                    color: themeController.isDark ? Colors.white : Colors.black,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    StringUtils.ratingAndReviews,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.5.h),
            Divider(color: Colors.grey, thickness: 0.2.sp),
            SizedBox(height: 1.5.h),
          ],
        ),
      ),
    );
  }
}
