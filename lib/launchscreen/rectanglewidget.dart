import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RectangleWidget extends StatelessWidget {
  final Color color;
  final Color borderColor;

  RectangleWidget({super.key, required this.color, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5.h, left: 5.w),
      width: 16.w,
      height: 60.h,    //width = height / 3,75
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: borderColor,),
        color: color,
      ),
    );
  }
}
