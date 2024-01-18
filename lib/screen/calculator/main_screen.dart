import 'package:calcon/controller/scientific_controller.dart';
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
  void initState() {
    print('MainScreen========');
    super.initState();
  }

  var controller = Get.find<CalculateController>();
  var scientificController = Get.find<ScientificController>();
  var themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    print('isLandscape=.......$isLandscape');
    if (isLandscape) {
      scientificController.initialiseInputAndOutput(
          controller.userInput, controller.userOutput);
      // Navigate to the ScientificCalculator screen in landscape mode
      return const ScientificCalculator();
    } else {
      controller.initialiseInputAndOutput(
          scientificController.userInput, scientificController.userOutput);
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet =
        screenWidth > 600; // Define a threshold for tablet screens
    final double buttonSize = isTablet ? screenWidth / 6 : screenWidth / 4;

    return Expanded(
        flex: 2,
        child: Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32), topRight: Radius.circular(32))),
          child: GridView.builder(
              padding:
                  EdgeInsets.only(top: 2.w, bottom: 2.w, left: 3.w, right: 3.w),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                // mainAxisExtent: 95,
                childAspectRatio: buttonSize / (34.0 * 3),
                // 24.w,
                // 11.5.h,
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet =
        screenWidth > 600; // Define a threshold for tablet screens

    // Define padding values relative to screen size
    final double topPadding = isTablet ? 5.h : 25.w;
    final double rightPadding = isTablet ? 6.w : 6.w;
    return Expanded(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // SizedBox(height: 2.w),

          ///Theme change light and dark
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(const CurrencyConverterScreen());
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: isTablet ? 2.w : 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
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
                                child: CircleAvatar(
                                  radius: isTablet ? 4.w : 5.w,
                                  backgroundColor: themeController.isDark
                                      ? DarkColors.sheetBgColor
                                      : LightColors.sheetBgColor,
                                ),
                                // Container(
                                //   width: 12.w,
                                //   height: 12.w,
                                //   decoration: BoxDecoration(
                                //     color: themeController.isDark
                                //         ? DarkColors.sheetBgColor
                                //         : LightColors.sheetBgColor,
                                //     shape: BoxShape.circle,
                                //     // borderRadius: BorderRadius.circular(20),
                                //   ),
                                // ),
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
                                    size: 16.sp,
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
            padding: EdgeInsets.only(right: rightPadding, top: topPadding),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    controller: controller.inputScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: ClampingScrollPhysics(),
                    child: Text(
                      ///remove.00
                      (controller.userInput.endsWith(".00")
                          ? controller.userInput
                              .substring(0, controller.userInput.length - 3)
                          : controller.userInput),
                      /*  (controller.userInput.endsWith(".00")
                          ? controller.userInput
                              .substring(0, controller.userInput.length - 3)
                          : controller.userInput.isEmpty
                              ? ""
                              : NumberFormat("#,##0", "en_US").format(
                                  num.parse(controller.userInput),
                                )),*/

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
