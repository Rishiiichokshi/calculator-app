import 'package:calculator_app/screen/calculator/main_screen.dart';
import 'package:calculator_app/screen/calculator/scientific_calculator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../bindings/my_bindings.dart';

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
            // theme: ThemeData(
            //   fontFamily: 'Poppins',
            // ),
            initialBinding: MyBindings(),
            title: "Flutter Calculator",
            home: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return MainScreen();
                } else {
                  return const ScientificCalculator();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
