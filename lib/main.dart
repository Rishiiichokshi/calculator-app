import 'package:calculator_app/screen/scientific_calculator.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../bindings/my_bindings.dart';
import '../screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return SafeArea(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialBinding: MyBindings(),
            title: "Flutter Calculator",
            home: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return MainScreen();
                } else {
                  return ScientificCalculator();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
