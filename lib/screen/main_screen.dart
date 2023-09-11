import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

///
import '../controller/theme_controller.dart';
import '../controller/calculate_controller.dart';
import '../utils/colors.dart';
import '../widget/button.dart';

class MainScreen extends StatelessWidget {
  MainScreen({
    Key? key,
  }) : super(key: key);

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

  /////////////////////////////////////
  //@CodeWithFlexz on Instagram
  //
  //AmirBayat0 on Github
  //Programming with Flexz on Youtube
  /////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CalculateController>();
    var themeController = Get.find<ThemeController>();

    return GetBuilder<ThemeController>(builder: (context) {
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
    });
  }

  /// In put Section - Enter Numbers
  Expanded inPutSection(
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        flex: 2,
        child: Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: themeController.isDark
                  ? DarkColors.sheetBgColor
                  : LightColors.sheetBgColor,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: buttons.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisExtent: 12.7.h),
              itemBuilder: (contex, index) {
                switch (index) {
                  /// CLEAR BTN
                  case 0:
                    return CustomButton(
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
                  case 1:
                    return CustomButton(
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

                  /// EQUAL BTN
                  case 19:
                    return CustomButton(
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
                    return CustomButton(
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
      ThemeController themeController, CalculateController controller) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ///Theme change light and dark
        Container(
          alignment: Alignment.topCenter,
          width: 100,
          height: 45,
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
                    color: themeController.isDark ? Colors.grey : Colors.black,
                    size: 25,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                GestureDetector(
                  onTap: () {
                    themeController.darkTheme();
                  },
                  child: Icon(
                    Icons.dark_mode_outlined,
                    color: themeController.isDark ? Colors.white : Colors.grey,
                    size: 25,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 70),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: Text(
                  ///remove.00
                  (controller.userInput.endsWith(".00")
                      ? controller.userInput
                          .substring(0, controller.userInput.length - 3)
                      : controller.userInput),
                  style: TextStyle(
                      color:
                          themeController.isDark ? Colors.white : Colors.black,
                      fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Text(

                    ///remove.00
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
                        fontSize: 32)),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  ///
  bool isOperator(String y) {
    if (y == "%" || y == "/" || y == "x" || y == "-" || y == "+" || y == "=") {
      return true;
    }
    return false;
  }
}
