import 'package:calculator_app/screen/calculator/widget/scientific_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';

import '../../controller/scientific_controller.dart';
import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';

///SCientific

class ScientificCalculator extends StatefulWidget {
  const ScientificCalculator({super.key});

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
    // "2nd",
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

  bool showRadText = true;

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
        padding: EdgeInsets.all(1.w),
        decoration: BoxDecoration(
            color: themeController.isDark
                ? DarkColors.sheetBgColor
                : LightColors.sheetBgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w), topRight: Radius.circular(4.w))),
        child: GridView.builder(
            padding:
                EdgeInsets.only(top: 1.h, bottom: 1.h, left: 3.w, right: 3.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 10,
                mainAxisExtent: 9.5.w,
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

                /// 2nd BTN
                case 10:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.toggleButton();
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor: controller.isToggleOn.value
                          ? (themeController.isDark
                              ? DarkColors.leftOperatorColor
                              : LightColors.leftOperatorColor)
                          : (themeController.isDark
                              ? Colors.white
                              : Colors.black),
                      text: buttons[index]));

                /// eˣ to yˣ  BTN
                case 14:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text:
                          controller.isToggleOn.value ? 'yˣ' : buttons[index]));

                ///  10ˣ to 2ˣ BTN
                case 15:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text:
                          controller.isToggleOn.value ? '2ˣ' : buttons[index]));

                ///  In to  logᵧ BTN
                case 24:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? ' logᵧ'
                          : buttons[index]));

                ///  log₁₀ to  log₂ BTN
                case 25:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? ' log₂'
                          : buttons[index]));

                ///  sin to  sin⁻¹ BTN
                case 31:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'sin⁻¹'
                          : buttons[index]));

                ///  cos to  cos⁻¹ BTN
                case 32:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'cos⁻¹'
                          : buttons[index]));

                ///  tan to  tan⁻¹ BTN
                case 33:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'tan⁻¹'
                          : buttons[index]));

                ///  sinh to  sinh⁻¹ BTN
                case 41:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'sinh⁻¹'
                          : buttons[index]));

                ///  cosh to  cosh⁻¹ BTN
                case 42:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'cosh⁻¹'
                          : buttons[index]));

                ///  tanh to  tanh⁻¹ BTN
                case 43:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.onBtnTapped(buttons, index);
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor:
                          themeController.isDark ? Colors.white : Colors.black,
                      text: controller.isToggleOn.value
                          ? 'tanh⁻¹'
                          : buttons[index]));

                /// Rad/ Deg BTN
                case 40:
                  return Obx(() => ScientificButton(
                      buttonTapped: () {
                        controller.changeButtonText();
                      },
                      color: themeController.isDark
                          ? DarkColors.btnBgColor
                          : LightColors.btnBgColor,
                      textColor: themeController.isDark
                          ? DarkColors.leftOperatorColor
                          : LightColors.leftOperatorColor,
                      text: controller.buttonText.value));

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
      ),
    );
  }

  /// Out put Section - Show Result
  Expanded outPutSection(
      ThemeController themeController, ScientificController controller) {
    showRadText = controller.buttonText.value == "Deg" ||
        controller.buttonText.value == "rad";
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 1.h),

          ///Theme change light and dark
          Container(
            alignment: Alignment.topCenter,
            width: 26.w,
            height: 5.2.h,
            decoration: BoxDecoration(
                color: themeController.isDark
                    ? DarkColors.sheetBgColor
                    : LightColors.sheetBgColor,
                borderRadius: BorderRadius.circular(13.w)),
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
            padding: EdgeInsets.only(
              right: 6.w,
            ),
            child: Column(
              children: [
                ///userInput
                Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      controller.userInput,
                      style: TextStyle(
                          color: themeController.isDark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 15.sp),
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                ///userOutput
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6.w,
                      ),
                      child: Obx(
                        () => Text(
                          controller.buttonText.value == "Deg" ? "Rad" : "",
                          style: TextStyle(
                            color: themeController.isDark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(

                            ///remove.00
                            controller.userOutput.endsWith(".00")
                                ? controller.userOutput.substring(
                                    0, controller.userOutput.length - 3)
                                : controller.userOutput,
                            style: TextStyle(
                                color: themeController.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 22.sp)),
                      ),
                    ),
                  ],
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
