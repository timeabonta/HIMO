import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';
import 'package:himo/mybottomappbar.dart';
import 'package:himo/orientationlayout.dart';
import 'package:himo/therapy/therapy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TherapySetup extends StatefulWidget {
  const TherapySetup({Key? key}) : super(key: key);

  @override
  State<TherapySetup> createState() => _TherapySetupState();
}

class _TherapySetupState extends State<TherapySetup> {

  static String selectedOrientation = 'left';
  File? _selectedImage;

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadImageFromPrefs() async {
    await _initPrefs();

    String? imagePath = _prefs.getString('selectedImage');
    if (imagePath != null) {
      setState(() {
        _selectedImage = File(imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);

    return Scaffold(
        backgroundColor: Color(0xff3d3d3d),
        appBar: CustomAppBar(
          title: 'Exercise',
          onBackPressed: (){
            SystemChrome.setPreferredOrientations([
              DeviceOrientation.portraitUp,
              DeviceOrientation.portraitDown
            ]);
            Navigator.pop(context);
          },
        ),
        body: _buildBody(context),
        bottomNavigationBar: BottomAppBarButton(
          buttonText: 'Start',
          backgroundColor: Color(0xff636366),
          onPressed: (){
            _showConfirmationDialog();
          },
        ),
    );
  }

  Widget _buildBody(BuildContext context) {

    return OrientationLayout(
      portraitLayout: Container(
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final stepNumber = index + 1;
                    final stepText = [
                      'Please rotate the device so that the camera to be on the left of right upper corner.',
                      'Select the orientation of the foot and start the session.',
                    ];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$stepNumber. ',
                          style: GoogleFonts.varelaRound(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            stepText[index],
                            style: GoogleFonts.varelaRound(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildButton(Image.asset('lib/images/flatfoot2.png'), 'left'),
                  SizedBox(width: 35,),
                  _buildButton(Image.asset('lib/images/flatfoot3.png'), 'right')
                ],
              ),
            )
          ],
        ),
      ),
      landscapeLayout: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 13),
                constraints: BoxConstraints(maxWidth: 480),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    final stepNumber = index + 1;
                    final stepText = [
                      'Please rotate the device so that the camera to be on the left of right upper corner.',
                      'Select the orientation of the foot and start the session.',
                    ];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$stepNumber. ',
                          style: GoogleFonts.varelaRound(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            stepText[index],
                            style: GoogleFonts.varelaRound(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildButton(Image.asset('lib/images/flatfoot2.png'), 'left'),
                    SizedBox(width: 35,),
                    _buildButton(Image.asset('lib/images/flatfoot3.png'), 'right')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildButton(Image image, String orientation) {
    bool isSelected = selectedOrientation == orientation;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 140, height: 140),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedOrientation = orientation;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff636366),
          side: BorderSide(
            color: isSelected ? Color(0xff74bec9) : Color(0xffdadada),
            width: isSelected ? 4.5 : 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.00),
          ),
          padding: EdgeInsets.all(13),
        ),
        child: Center(
          child: Container(
            child: image
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xff3d3d3d),
          title: Text(
            'Last Calibration',
            style: GoogleFonts.varelaRound(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_selectedImage != null)
                Container(
                  constraints: BoxConstraints(maxHeight: 100),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 16),
              Text(
                'Make sure you are wearing the same sock as in this picture.',
                textAlign: TextAlign.center,
                style: GoogleFonts.varelaRound(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Therapy()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
