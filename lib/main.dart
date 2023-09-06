import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calculator/screen/scientific_calculator.dart';
import 'package:get/get.dart';
import '../bindings/my_bindings.dart';
import '../screen/main_screen.dart';

void main() {
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBindings(),
      title: "Flutter Calculator",
      builder: DevicePreview.appBuilder,
      home: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return MainScreen();
          } else {
            return ScientificCalculator();
          }
        },
      ),
    );
  }
}
