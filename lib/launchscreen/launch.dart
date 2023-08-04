import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rectanglewidget.dart';
import '../homescreen/home.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen ({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState(){
    super.initState();
    _navigateToHome();
  }
  
  _navigateToHome() async{
    await Future.delayed(Duration(milliseconds: 2000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 47.w),
      decoration: BoxDecoration(
        color: Color(0xff3d3d3d),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < 100; i++)
                  RectangleWidget(color: Color(0xff74bec9), borderColor: Color(0xff74bec9)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 501.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'HIMO',
                    style: GoogleFonts.varelaRound(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2.h,
                      letterSpacing: 16.6.w,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  Text(
                    'gesture recognition module',
                    style: GoogleFonts.varelaRound(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2.h,
                      color: Color(0xffe5e5e5),
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


