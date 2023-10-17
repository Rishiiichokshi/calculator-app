import 'package:calcon/screen/generalScreen/onboading_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulate a delay (e.g., 2 seconds) before transitioning to the main screen.
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the main screen or perform any other logic.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const OnboardingScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
