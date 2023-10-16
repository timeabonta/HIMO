import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';

class Settings extends StatelessWidget{

  const Settings({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: CustomAppBar(
        title: "",
        onBackPressed: (){
          Navigator.pop(context);
        },
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(40.r),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'Privacy Policy',
                style: GoogleFonts.varelaRound(
                  fontSize:  12.sp,
                  fontWeight:  FontWeight.w400,
                  height:  1.2.h,
                  color:  Color(0xff000000),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 20.h),
              child: Text(
                'Pairing & connection - sends to the OS settings',
                style: GoogleFonts.varelaRound(
                  fontSize:  11.sp,
                  fontWeight:  FontWeight.w400,
                  height:  1.2.h,
                  color:  Color(0xff000000),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}