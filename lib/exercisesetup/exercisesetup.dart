import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';



class ExerciseSetup extends StatefulWidget {
  const ExerciseSetup({Key? key}) : super(key: key);

  @override
  _ExerciseSetupState createState() => _ExerciseSetupState();
}

class _ExerciseSetupState extends State<ExerciseSetup> {
  static int selectedRepetition = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3d3d3d),
      appBar: CustomAppBar(
        title: 'Exercise setup',
        onBackPressed: (){
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 55.h),
          child: Column(
            children: [
              Text(
                "Select the number of repetitions:",
                style: GoogleFonts.varelaRound(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2.h,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton(5),
                  _buildButton(10),
                  _buildButton(15),
                ],
              ),
              SizedBox(height: 50.h),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(int repetition) {
    bool isSelected = selectedRepetition == repetition;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 80.w, height: 30.h),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedRepetition = repetition;
          });
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Color(0xffcb732b) : Colors.white, backgroundColor: isSelected ? Colors.white : Color(0xffcb732b),
          side: BorderSide(color: Color(0xffcb732b)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.r),
          )
        ),
        child: Text(
          "$repetition",
          style: GoogleFonts.varelaRound(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            height: 1.2.h,
            color: isSelected ? Colors.black : Colors.white
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return IntrinsicWidth(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildRows(selectedRepetition, Image.asset('lib/images/foot2.png')),
            _buildRows(selectedRepetition * 3, Image.asset('lib/images/time.png')),
            _buildRows(selectedRepetition, Image.asset('lib/images/flatfoot.png')),
            _buildRows(selectedRepetition * 3, Image.asset('lib/images/time.png'), suffix: "sec"),
            _buildRows(selectedRepetition * 3, Image.asset('lib/images/foot3.png'), suffix: "sec"),
          ],
        ),
      ),
    );
  }

  Widget _buildRows(int value, Image image, {String suffix = "X"}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "$value $suffix",
          style: GoogleFonts.varelaRound(
            fontSize: 24.sp,
            fontWeight: FontWeight.w400,
            height: 0.8.h,
            color: Colors.white
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.w, bottom: 8.h),
          child: Container(
            padding: EdgeInsets.all(7.r),
            width: 60.w,
            height: 60.h,
            decoration:BoxDecoration(
              border: Border.all(color: Color(0xffcb732b)),
              borderRadius: BorderRadius.circular(5.r),
              color: Colors.transparent
            ),
            child: FittedBox(
              child: image,
            )
          ),
        )
      ],
    );
  }
}
