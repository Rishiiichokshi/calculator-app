import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final FontWeight? fontWeight;
  final Color textColor;
  final double? fontSize;
  final String text;
  final VoidCallback buttonTapped;

  const CustomButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: color,
          // shape: BoxShape.circle
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: textColor,
                fontSize: fontSize ?? 16.sp,
                // fontFamily: 'Poppins',
                fontWeight: fontWeight ?? FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
