import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';
import 'package:himo/therapy/therapyend.dart';

class Therapy extends StatefulWidget {
  const Therapy({Key? key}) : super(key: key);

  @override
  State<Therapy> createState() => _TherapyState();
}

class _TherapyState extends State<Therapy> {

  @override
  void initState(){
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(Duration(milliseconds: 5000), (){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TherapyEnd()));
  }

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
          Navigator.pop(context);
        },
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container();
  }
}
