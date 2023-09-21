import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScientificButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final double? width;
  final String text;
  final VoidCallback buttonTapped;

  const ScientificButton({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
    required this.buttonTapped,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonTapped,
      child: Container(
        width: width ?? double.infinity,
        // margin: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4.w),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}
