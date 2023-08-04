import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';

class TherapyEnd extends StatelessWidget {
  const TherapyEnd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff3d3d3d),
        appBar: CustomAppBar(
          title: 'Exercise',
          onBackPressed: (){
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown,
            ]);
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        ),
        body: _buildBody(context),
      );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Container(
        constraints:  BoxConstraints (
          maxWidth:  338,
        ),
        child: Text(
          'The session ended.\nYou can go back to the main screen now.',
          textAlign: TextAlign.center,
          style: GoogleFonts.varelaRound(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 1.2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
