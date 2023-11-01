import 'package:calcon/screen/calculator/scientific_calculator.dart';
import 'package:calcon/screen/calculator/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

///
import '../../controller/theme_controller.dart';
import '../../controller/calculate_controller.dart';
import '../../utils/colors.dart';
import '../currency_converter/currency_converter_screen.dart';
import '../generalScreen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> buttons = [
    "C",
    "DEL",
    "%",
    "/",
    "7",
    "8",
    "9",
    "x",
    "4",
    "5",
    "6",
    "-",
    "1",
    "2",
    "3",
    "+",
    "00",
    "0",
    ".",
    "=",
  ];

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // Navigate to the ScientificCalculator screen in landscape mode
      return const ScientificCalculator();
    } else {
      return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: GetBuilder<ThemeController>(builder: (context) {
          return Scaffold(
            backgroundColor: themeController.isDark
                ? DarkColors.scaffoldBgColor
                : LightColors.scaffoldBgColor,
            body: Column(
              children: [
                GetBuilder<CalculateController>(builder: (context) {
                  return outPutSection(themeController, controller);
                }),
                inPutSection(themeController, controller),
              ],
            ),
          );
        }),
      );
    }
  }

  /// In put Section - Enter Numbers
  Expanded inPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.w),
                  topRight: Radius.circular(8.w))),
          child: GridView.builder(
              padding:
                  EdgeInsets.only(top: 1.h, bottom: 1.h, left: 3.w, right: 3.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisExtent: 11.5.h,
                // mainAxisSpacing: 0,
              ),
              itemBuilder: (contex, index) {
                switch (index) {
                  /// CLEAR BTN
                  case 0:
                    return CustomButton(
                        buttonTapped: () {
                          controller.clearInputAndOutput();
                        },
                        fontSize: 20.sp,
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  /// DELETE BTN
                  case 1:
                    return CustomButton(
                        buttonTapped: () {
                          controller.deleteBtnAction();
                        },
                        fontSize: 20.sp,
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  /// EQUAL BTN
                  case 19:
                    return CustomButton(
                        buttonTapped: () {
                          controller.equalPressed();
                        },
                        fontSize: 29.sp,
                        color: themeController.isDark
                            ? DarkColors.btnBgColor
                            : LightColors.btnBgColor,
                        textColor: themeController.isDark
                            ? DarkColors.leftOperatorColor
                            : LightColors.leftOperatorColor,
                        text: buttons[index]);

                  default:
                    return CustomButton(
                        buttonTapped: () {
                          controller.onBtnTapped(buttons, index);
                        },
                        fontWeight: FontWeight.w500,
                        fontSize: isOperator(buttons[index]) ? 29.sp : 27.sp,
                        // fontSize: isOperator(buttons[index]) ? 19.sp : 16.sp,
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
      ThemeController themeController, CalculateController controller) {
    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 1.h),

          ///Theme change light and dark
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const CurrencyConverterScreen());
                    },
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
                              width: Get.width,
                              height: 8.h,
                              decoration: BoxDecoration(
                                color: themeController.isDark
                                    ? DarkColors.sheetBgColor
                                    : LightColors.sheetBgColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          Container(
                            width: Get.width,
                            height: 8.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Currency Converter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeController.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    fontSize: 12.sp,
                                  ),
                                ),
                                IconButton(
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                // SizedBox(width: 1.5.w),
                Padding(
                  padding: EdgeInsets.only(left: 1.w, right: 2.w),
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
                SizedBox(width: 1.5.w),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 6.w, top: 8.h),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      ///remove.00
                      (controller.userInput.endsWith(".00")
                          ? controller.userInput
                              .substring(0, controller.userInput.length - 3)
                          : controller.userInput),
                      style: TextStyle(
                          color: themeController.isDark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18.sp),
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    ///remove.00
                    // NumberFormat.compact().format(
                    //   double.parse(controller.userInput.isEmpty
                    //       ? '0'
                    //       : controller.userInput),
                    // ),
                    controller.userOutput.isEmpty
                        ? "0.00"
                        : (controller.userOutput.endsWith(".00")
                            ? controller.userOutput
                                .substring(0, controller.userOutput.length - 3)
                            : controller.userOutput),
                    style: TextStyle(
                        color: themeController.isDark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 30.sp),
                    maxLines: 1,
                    // overflow: TextOverflow.clip,
                  ),
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
