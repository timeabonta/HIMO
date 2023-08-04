import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';
import 'package:himo/mybottomappbar.dart';

class FailedCalibration extends StatelessWidget {

  const FailedCalibration({Key? key}) : super(key: key);

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
          buttonText: 'Cancel',
          backgroundColor: Color(0xff3d3d3d),
          onPressed: (){
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 200, horizontal: 40),
      alignment: Alignment.topCenter,
      child: Text(
        'No region found. Go back to try again or tap on Cancel to return to home screen.',
        style: GoogleFonts.varelaRound(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
}