// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controller/theme_controller.dart';
import '../utils/colors.dart';

class MyWebView extends StatefulWidget {
  const MyWebView({super.key});

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeController = Get.find<ThemeController>();
    return Scaffold(
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
          "Privacy Policy",
          style: TextStyle(
              fontSize: 5.w,
              color: themeController.isDark
                  ? CommonColors.white
                  : CommonColors.black),
        ),
      ),
      body: const WebView(
        initialUrl:
            "https://medium.com/@app.writespace/calcon-privacy-policy-aae55453da9a",
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
