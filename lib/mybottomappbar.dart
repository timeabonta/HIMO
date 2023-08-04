import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomAppBarButton extends StatelessWidget {
  final String buttonText;
  final Color backgroundColor;
  final void Function() onPressed;

  const BottomAppBarButton({super.key,
    required this.buttonText,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context){
    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(vertical: 23, horizontal: 120.w),
      decoration: BoxDecoration(
        color: Color(0xff74bec9),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.r),
          topRight: Radius.circular(8.r),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xff3d3d3d))
          ),
          child: Center(
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: GoogleFonts.varelaRound(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                height: 1.2,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}