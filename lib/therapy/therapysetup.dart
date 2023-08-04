import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/myappbar.dart';
import 'package:himo/mybottomappbar.dart';
import 'package:himo/orientationlayout.dart';
import 'package:himo/therapy/therapy.dart';

class TherapySetup extends StatefulWidget {
  const TherapySetup({Key? key}) : super(key: key);

  @override
  State<TherapySetup> createState() => _TherapySetupState();
}

class _TherapySetupState extends State<TherapySetup> {

  static String selectedOrientation = 'left';

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
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Therapy())
            );
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
}
