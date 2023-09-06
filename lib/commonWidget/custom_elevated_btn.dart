import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'custom_text.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? title;
  final double? radius;
  final double? height;
  final double? width;
  final Color? bgColor;
  final Color? textColor;
  final Color? borderColor;
  final double? fontSize;
  final bool? isDownloadFile;
  final IconData? leading;
  final bool? withIcon;
  final String? iconPath;

  // Constructor
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.radius,
    this.borderColor,
    this.height,
    this.width,
    this.fontSize,
    this.bgColor,
    this.textColor,
    this.leading,
    this.withIcon = false,
    this.iconPath,
    this.isDownloadFile = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: bgColor,
        onPrimary: textColor,
        side: BorderSide(color: borderColor!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 0),
        ),
        minimumSize: Size(width ?? Get.width, height ?? 35.sp),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustomText(
          title!,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: fontSize ?? 14.sp,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
