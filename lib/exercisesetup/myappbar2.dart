import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exerciseprovider.dart';

class CustomAppBarExerciseSetup extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool isCustomSelected;
  final ValueChanged<bool> onToggle;

  CustomAppBarExerciseSetup({
    super.key,
    required this.title,
    required this.onBackPressed,
    required this.isCustomSelected,
    required this.onToggle,
  });

  @override
  Size get preferredSize => Size.fromHeight(45);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff74bec9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1.r,
            blurRadius: 5.r,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: AppBar(
        title: Text(
          title,
          style: GoogleFonts.varelaRound(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff74bec9),
        iconTheme: IconThemeData(
            color: Colors.white,
            size: 20
        ),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: onBackPressed,
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ToggleButtons(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Default'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Custom'),
                ),
              ],
              isSelected: [!isCustomSelected, isCustomSelected],
              onPressed: (int index) {
                onToggle(index == 1);
                String selectedTherapy = index == 1 ? therapyCustom : therapyDefault;
                saveSelectedTherapy(selectedTherapy);
              },
              color: Colors.white,
              selectedColor: Colors.black,
              fillColor: Colors.white54,
              borderRadius: BorderRadius.circular(10),
              constraints: BoxConstraints(minHeight: 30, minWidth: 70),
            ),
          ),
        ],
      ),
    );
  }
}