import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';


class Calibration3 extends StatefulWidget {
  const Calibration3({Key? key}) : super(key: key);

  @override
  State<Calibration3> createState() => _Calibration3State();
}

class _Calibration3State extends State<Calibration3> {
  bool _isSelected1 = false;
  bool _isSelected2 = false;

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
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 300.w,
                ),
                padding: EdgeInsets.only(bottom: 20.h),
                child: Text(
                  'The following colors were identified. Please tap on the image with the correct color.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.varelaRound(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.2.h,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            _buildSelectableImage('lib/images/img.png', _isSelected1, () {
              setState(() {
                _isSelected1 = true;
              });
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }),
            SizedBox(height: 10.h),
            _buildSelectableImage('lib/images/img.png', _isSelected2, () {
              setState(() {
                _isSelected2 = true;
              });
              Future.delayed(Duration(seconds: 1), () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableImage(String imagePath, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Color(0xff74bec9) : Colors.white,
            width: isSelected ? 5 : 1,
          ),
        ),
        child: Image.asset(imagePath),
      ),
    );
  }
}
