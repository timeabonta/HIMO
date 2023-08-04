import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:himo/calibration/calibration.dart';
import 'package:himo/homescreen/background.dart';
import 'package:himo/homescreen/textbutton.dart';
import 'package:himo/therapy/therapysetup.dart';
import 'iconbutton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/exercisesetup//exercisesetup.dart';
import 'package:himo/settings/settings.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(46.h),
        child: AppBar(
          backgroundColor: Color(0xff74bec9),
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.r),
              bottomRight: Radius.circular(25.r),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
              child: Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Image.asset(
                  'lib/images/setting.png',
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 95.h, right: 40.w, left: 40.w, bottom: 30.h),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: Column(
                          children: [
                            CustomButton(
                              buttonText: "Calibration",
                              letter: "C",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Calibration(),
                                    )
                                );
                              },
                            ),
                            SizedBox(height: 15.h),
                            CustomButton(
                              buttonText: "Excercise setup",
                              letter: "E",
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExerciseSetup()
                                    )
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 25.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: CustomIconButton(
                                      buttonText: "Start therapy with game",
                                      firstIcon: Icons
                                          .phone_iphone_outlined,
                                      secondIcon: Icons
                                          .computer_outlined,
                                      color: Colors.black,
                                      onPressed: () {},
                                    ),
                                  ),
                                  //SizedBox(width: 30.w),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: CustomIconButton(
                                      buttonText: "Start standalone mode",
                                      firstIcon: Icons
                                          .phone_iphone_outlined,
                                      secondIcon: Icons
                                          .computer_rounded,
                                      color: Colors.black26,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => TherapySetup())
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'HIMO',
                              style: GoogleFonts.varelaRound(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.2.h,
                                letterSpacing: 16.6.w,
                                color: Color(0xff74bec9),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            Text(
                              'gesture recognition module',
                              style: GoogleFonts.varelaRound(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                height: 1.2.h,
                                color: Color(0xff74bec9),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


