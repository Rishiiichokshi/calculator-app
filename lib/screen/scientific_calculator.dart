import 'package:calculator_app/widget/scientific_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:math' as math;

import 'package:math_expressions/math_expressions.dart';
import 'package:sizer/sizer.dart';

import '../controller/calculate_controller.dart';
import '../controller/scientific_controller.dart';
import '../controller/theme_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';

///SCientific

class ScientificCalculator extends StatefulWidget {
  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  final List<String> buttons = [
    "(",
    ")",
    "mc",
    "m+",
    "m-",
    "mr",
    "AC",
    "DEL",
    "%",
    "/",
    "2ⁿᵈ",
    "x²",
    "x³",
    "xʸ",
    "eˣ",
    "10ˣ",
    "7",
    "8",
    "9",
    "x",
    "1/x",
    "2√x",
    "∛x",
    // "3√x",
    "y√x",
    "In",
    "log₁₀",
    "4",
    "5",
    "6",
    "-",
    "X!",
    "sin",
    "cos",
    "tan",
    "e",
    "EE",
    "1",
    "2",
    "3",
    "+",
    "Rad",
    "sinh",
    "cosh",
    "tanh",
    "π",
    "Rand",
    "0",
    ".",
    "+/-",
    "=",
  ];

  String buttonText = "rad";
  // Initial text
  void changeButtonText() {
    setState(() {
      // Toggle between "rad" and "deg"
      buttonText = (buttonText == "rad") ? "deg" : "rad";
    });
  }

  @override
  Widget build(BuildContext context) {
    var scientificController = Get.find<ScientificController>();
    var themeController = Get.find<ThemeController>();
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeController.isDark
              ? DarkColors.scaffoldBgColor
              : LightColors.scaffoldBgColor,
          body: Column(
            children: [
              GetBuilder<ScientificController>(
                builder: (controller) {
                  return outPutSection(themeController, scientificController);
                },
              ),
              inPutSection(themeController, scientificController),
            ],
          ),
        );
      },
    );
  }

  /// In put Section - Enter Numbers
  Expanded inPutSection(
      ThemeController themeController, ScientificController controller) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15))),
          child: GridView.builder(
              padding:
                  EdgeInsets.only(top: 1.h, bottom: 1.h, left: 3.w, right: 3.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10,
                  mainAxisExtent: 4.3.h,
                  mainAxisSpacing: 1.5.w,
                  crossAxisSpacing: 2.9.w),
              itemBuilder: (contex, index) {
                switch (index) {
                  /// CLEAR BTN
                  case 6:
                    return ScientificButton(
                        buttonTapped: () {
                          controller.clearInputAndOutput();
                        },
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  /// DELETE BTN
                  case 7:
                    return ScientificButton(
                        buttonTapped: () {
                          controller.deleteBtnAction();
                        },
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  /// Rad/ Deg BTN
                  case 40:
                    return ScientificButton(
                        buttonTapped: changeButtonText,
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttonText);

                  /// EQUAL BTN
                  case 49:
                    return ScientificButton(
                        buttonTapped: () {
                          controller.equalPressed();
                        },
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  default:
                    return ScientificButton(
                        buttonTapped: () {
                          controller.onBtnTapped(buttons, index);
                        },
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: isOperator(buttons[index])
                            ? LightColors.operatorColor
                            : themeController.isDark
                                ? Colors.white
                                : Colors.black,
                        text: buttons[index]);
                }
              }),
        ));
  }

  /// Out put Section - Show Result
  Expanded outPutSection(
      ThemeController themeController, ScientificController controller) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ///Theme change light and dark
          Container(
            alignment: Alignment.topCenter,
            width: 26.w,
            height: 5.3.h,
            decoration: BoxDecoration(
                color: themeController.isDark
                    ? DarkColors.sheetBgColor
                    : LightColors.sheetBgColor,
                borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      themeController.lightTheme();
                    },
                    child: Icon(
                      Icons.light_mode_outlined,
                      color:
                          themeController.isDark ? Colors.grey : Colors.black,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(
                    width: 3.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      themeController.darkTheme();
                    },
                    child: Icon(
                      Icons.dark_mode_outlined,
                      color:
                          themeController.isDark ? Colors.white : Colors.grey,
                      size: 22.sp,
                    ),
                  )
                ],
              ),
            ),
          ),

          ///output
          Padding(
            padding: EdgeInsets.only(right: 6.w, top: 1.h),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    controller.userInput,
                    style: TextStyle(
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 17.sp),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: Text(

                      ///remove.00
                      controller.userOutput.endsWith(".00")
                          ? controller.userOutput
                              .substring(0, controller.userOutput.length - 3)
                          : controller.userOutput,
                      style: TextStyle(
                          color: themeController.isDark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 24.sp)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///
  bool isOperator(String y) {
    if (y == "%" || y == "/" || y == "x" || y == "-" || y == "+" || y == "=") {
      return true;
    }
    return false;
  }
}
