import 'package:calculator_app/bindings/my_bindings.dart';
import 'package:calculator_app/screen/calculator/main_screen.dart';
import 'package:calculator_app/utils/colors.dart';
import 'package:calculator_app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'generalScreen/onboading_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstLaunch = false;

  @override
  void initState() {
    checkFirstLaunch();
    super.initState();
  }

  void checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (_isFirstLaunch) {
      prefs.setBool('first_launch', false);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: LightColors.leftOperatorColor,
              textSelectionTheme: const TextSelectionThemeData(
                  cursorColor: LightColors.leftOperatorColor),
            ),
            initialBinding: MyBindings(),
            title: StringUtils.flutterCalculator,
            home:
                _isFirstLaunch ? const OnboardingScreen() : const MainScreen(),
          ),
        );
      },
    );
  }
}
