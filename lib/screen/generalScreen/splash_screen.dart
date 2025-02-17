import 'package:calcon/screen/generalScreen/onboading_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../calculator/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isFirstLaunch = false;

  void checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (_isFirstLaunch) {
      prefs.setBool('first_launch', false);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkFirstLaunch();
    // Simulate a delay (e.g., 2 seconds) before transitioning to the main screen.
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the main screen or perform any other logic.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return _isFirstLaunch
                ? const OnboardingScreen()
                : const MainScreen();
            // return const OnboardingScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              orientation == Orientation.portrait
                  ? 'assets/images/splash.png'
                  : 'assets/images/splashLandscape.png',
              width: double.infinity,
              height: double.infinity,
              // : 'assets/images/splash.png',
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
