import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconButton extends StatelessWidget {
  final String buttonText;
  final IconData firstIcon;
  final IconData secondIcon;
  final Color color;
  final void Function() onPressed;

  const CustomIconButton({super.key,
    required this.buttonText,
    required this.firstIcon,
    required this.secondIcon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: CircleBorder(),
              side: BorderSide(
                color: Color(0xff74bec9),
                width: 5.w,
              ),
            ),
            child: Ink(
              padding: EdgeInsets.all(15.r),
              width: 130.w,
              height: 130.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      firstIcon,
                      size: 42.r,
                      color: Colors.black,
                    ),
                    Icon(
                      secondIcon,
                      size: 57.r,
                      color: color,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.h),
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