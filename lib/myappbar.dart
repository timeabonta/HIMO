import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;

  CustomAppBar({super.key, required this.title, required this.onBackPressed});

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
      ),
    );
  }
}
