import 'package:calcon/screen/calculator/widget/scientific_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:sizer/sizer.dart';

import '../../controller/scientific_controller.dart';
import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';
import '../currency_converter/currency_converter_screen.dart';
import '../generalScreen/settings_screen.dart';

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
  void initState() {
    print('ScientificCalculator===============');
    super.initState();
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
                  print('controller.userInput=>${controller.userInput}');
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
                EdgeInsets.only(top: 2.5.w, bottom: 2.w, left: 3.w, right: 3.w),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: buttons.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 10,
              mainAxisExtent: 9.5.w,
              mainAxisSpacing: 1.2.w,
              crossAxisSpacing: 2.9.w,
            ),
            itemBuilder: (context, index) {
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 1000;
    showRadText = controller.buttonText.value == "Deg" ||
        controller.buttonText.value == "rad";
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 1.w),

          ///Theme change light and dark
          Padding(
            padding: EdgeInsets.all(0.w),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 2.w,
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.to(const SettingScreen());
                    },
                    icon: Icon(
                      Icons.settings,
                      size: 18.sp,
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: IconButton(
                    onPressed: () {
                      themeController
                          .toggleTheme(); // Call the toggleTheme method
                    },
                    icon: Icon(
                      size: 18.sp,
                      themeController.isDark
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const CurrencyConverterScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: isTablet ? 2.w : 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          child: Stack(
                            children: [
                              Shimmer.fromColors(
                                baseColor: themeController.isDark
                                    ? DarkColors.sheetBgColor
                                    : CommonColors.greyLight,
                                // baseColor: Colors.grey[300]!,
                                highlightColor: themeController.isDark
                                    ? Colors.black12
                                    : Colors.white60,
                                child: Container(
                                  width: isTablet ? 10.w : 10.w,
                                  height: isTablet ? 8.w : 10.w,
                                  // width: 10.w,
                                  // height: 10.w,
                                  decoration: BoxDecoration(
                                    color: themeController.isDark
                                        ? DarkColors.sheetBgColor
                                        : LightColors.sheetBgColor,
                                    shape: BoxShape.circle,
                                    // borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    // print('---tap');
                                    Get.to(const CurrencyConverterScreen());
                                  },
                                  icon: Icon(
                                    Icons.currency_exchange_outlined,
                                    size: 18.sp,
                                    color: themeController.isDark
                                        ? DarkColors.leftOperatorColor
                                        : LightColors.leftOperatorColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Container(
          //   alignment: Alignment.topCenter,
          //   width: 26.w,
          //   height: 5.2.h,
          //   decoration: BoxDecoration(
          //       color: themeController.isDark
          //           ? DarkColors.sheetBgColor
          //           : LightColors.sheetBgColor,
          //       borderRadius: BorderRadius.circular(13.w)),
          //   child: Center(
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             themeController.lightTheme();
          //           },
          //           child: Icon(
          //             Icons.light_mode_outlined,
          //             color:
          //                 themeController.isDark ? Colors.grey : Colors.black,
          //             size: 22.sp,
          //           ),
          //         ),
          //         SizedBox(
          //           width: 3.w,
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             themeController.darkTheme();
          //           },
          //           child: Icon(
          //             Icons.dark_mode_outlined,
          //             color:
          //                 themeController.isDark ? Colors.white : Colors.grey,
          //             size: 22.sp,
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // ),

          ///output
          Padding(
            padding: EdgeInsets.only(right: 6.w),
            child: Column(
              children: [
                ///userInput
                Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    controller: controller.inputScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    child: Text(
                      controller.userInput,
                      /*controller.userInput.isEmpty
                          ? ""
                          : NumberFormat("#,##0", "en_US").format(
                              num.parse(controller.userInput),
                            ),*/
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
