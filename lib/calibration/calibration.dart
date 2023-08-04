import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calibration2.dart';
import 'package:himo/myappbar.dart';
import 'package:himo/mybottomappbar.dart';

class Calibration extends StatelessWidget {
  const Calibration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3d3d3d),
      appBar: CustomAppBar(
        title: 'Calibration',
        onBackPressed: (){
          Navigator.pop(context);
        },
      ),
      body: _buildBody(context),
      bottomNavigationBar: BottomAppBarButton(
        buttonText: 'Continue',
        backgroundColor: Color(0xff3d3d3d),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Calibration2())
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 45.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'To calibrate the app, please follow these steps: ',
                style: GoogleFonts.varelaRound(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2.h,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 23.h, bottom: 30.h, right: 20.w),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  final stepNumber = index + 1;
                  final stepText = [
                    'Take a picture of the foot on floor level. The foot should cover at least half of the picture area.',
                    'Select the picture when you are asked.',
                    'The app will try to recognize the color of the socks based on the dominant colors on the picture.',
                    'The alternatives will be offered to you to choose the right one.',
                    'Tap on a picture to select the color and finish the calibration. Press back to retry.',
                  ];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$stepNumber. ',
                        style: GoogleFonts.varelaRound(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.25.h,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          stepText[index],
                          style: GoogleFonts.varelaRound(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.2.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'You should see something like this:',
                style: GoogleFonts.varelaRound(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2.h,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 27.h),
              child: Image.asset('lib/images/img.png'),
            )
          ],
        ),
      ),
    );
  }
}