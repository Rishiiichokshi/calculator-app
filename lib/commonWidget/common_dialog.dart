import 'package:calculator_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../utils/string_utils.dart';
import 'custom_btn.dart';
import 'custom_text.dart';

typedef ClickOnTap = Function();

Future<void> showCommonDialog(
    {required ClickOnTap? clickOnTap, required String dialogText}) async {
  Get.dialog(
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Material(
                color: CommonColors.white,
                child: Column(
                  children: [
                    SizedBox(height: 2.5.w),
                    CustomText(
                      dialogText,
                      fontSize: 12.sp,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5.w),
                    Row(
                      children: [
                        Expanded(
                          child: CustomBtn(
                            onTap: clickOnTap,
                            height: 35.sp,
                            title: StringUtils.yes,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: CustomBtn(
                            onTap: () {
                              Get.back();
                            },
                            height: 35.sp,
                            title: StringUtils.no,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
