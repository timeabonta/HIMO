import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';
import 'package:native_opencv/native_opencv.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Calibration3 extends StatefulWidget {
  final List<DetectedObject> detectedObjects;

  const Calibration3({Key? key, required this.detectedObjects}) : super(key: key);

  @override
  _Calibration3State createState() => _Calibration3State();
}

class _Calibration3State extends State<Calibration3> {
  List<bool> _isSelected = [];

  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(widget.detectedObjects.length, (_) => false);
  }

  Future<void> _saveSelectedHue(int hue) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedHue', hue);
    print("Elmentett hue: $hue");
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
            for (int i = 0; i < widget.detectedObjects.length; i++)
              _buildSelectableImage(widget.detectedObjects[i].imageFile, _isSelected[i], () {
                setState(() {
                  for (int j = 0; j < _isSelected.length; j++) {
                    _isSelected[j] = i == j;
                  }
                });
                Future.delayed(Duration(seconds: 1), () async {
                  int selectedHue = widget.detectedObjects[i].dominantHue;
                  await _saveSelectedHue(selectedHue);
                  print("Kiválasztott kép domináns színe: $selectedHue");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectableImage(File imagePath, bool isSelected, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Color(0xff74bec9) : Colors.white,
            width: isSelected ? 5 : 1,
          ),
        ),
        child: Image.file(imagePath),
      ),
    );
  }
}
