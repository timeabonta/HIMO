import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:himo/launchscreen/rectanglewidget.dart';

class BackgroundWidget extends StatelessWidget {

  BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xff3d3d3d),
      ),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children:
          List.generate(100, (index) {
            bool isEvenRow = index % 2 == 0;
            return SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (!isEvenRow) SizedBox(height: 60.h,)
                  else SizedBox(height: 30.h,),
                  for (int i = 0; i < 100; i++)
                    if((index == 2 || index == 3 || index == 4) && (i == 1 || i == 2 || i == 3 || i == 4)) RectangleWidget(color:  Color(0xff74bec9), borderColor: Color(0xff74bec9),)
                    else RectangleWidget(color:  Colors.transparent, borderColor: Color(0x1e000000),),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
