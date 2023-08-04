import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calibration3.dart';
import 'failedcalibration.dart';
import 'package:himo/myappbar.dart';

class Calibration2 extends StatefulWidget {
  const Calibration2({Key? key}) : super(key: key);

  @override
  State<Calibration2> createState() => _Calibration2State();
}

class _Calibration2State extends State<Calibration2> {

  @override
  void initState(){
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async{
    await Future.delayed(Duration(milliseconds: 3000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Calibration3()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff3d3d3d),
      appBar: CustomAppBar(
        title: 'Calibration',
        onBackPressed: (){
          Navigator.pop(context);
        },
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 200.h),
      alignment: Alignment.topCenter,
      child: Text(
        'Searching for dominant color areas....',
        style: GoogleFonts.varelaRound(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.2.h,
          color: Colors.white,
        ),
      ),
    );
  }
}
