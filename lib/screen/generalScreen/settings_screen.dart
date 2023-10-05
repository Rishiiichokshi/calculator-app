import 'package:calculator_app/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../controller/theme_controller.dart';
import '../../utils/colors.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: themeController.isDark
          ? DarkColors.currencyScaffoldBgColor
          : LightColors.scaffoldBgColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              size: 5.w,
              Icons.arrow_back,
              color: themeController.isDark ? Colors.white : Colors.black,
            )),
        centerTitle: true,
        backgroundColor: themeController.isDark
            ? DarkColors.currencyScaffoldBgColor
            : LightColors.scaffoldBgColor,
        title: Text(
          StringUtils.settings,
          style: TextStyle(
              fontSize: 5.w,
              color: themeController.isDark
                  ? CommonColors.white
                  : CommonColors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  size: 18.sp,
                  color: themeController.isDark ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8.w),
                Text(
                  StringUtils.privacyPolicy,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeController.isDark ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(height: 1.5.h),
            Divider(color: Colors.grey, thickness: 0.2.sp),
            SizedBox(height: 1.5.h),
            Row(
              children: [
                Icon(
                  Icons.star_rate_rounded,
                  size: 18.sp,
                  color: themeController.isDark ? Colors.white : Colors.black,
                ),
                SizedBox(width: 8.w),
                Text(
                  StringUtils.ratingAndReviews,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: themeController.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.h),
            Divider(color: Colors.grey, thickness: 0.2.sp),
            SizedBox(height: 1.5.h),
          ],
        ),
      ),
    );
  }
}
