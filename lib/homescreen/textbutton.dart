import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final String letter;
  final void Function() onPressed;

  const CustomButton({
    required this.buttonText,
    required this.letter,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65.w,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
              side: BorderSide(
                color: Color(0xff74bec9),
                width: 4.w,
              ),
            ),
            child: Ink(
              width: 45.w,
              height: 45.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  letter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'TsukimiRounded',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                    height: 1.0.h,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            buttonText,
            style: GoogleFonts.varelaRound(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.2.h,
              color: Color(0xffe5e5e5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

