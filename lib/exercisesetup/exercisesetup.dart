import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:himo/exercisesetup/myappbar2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exerciseprovider.dart';
import 'dart:developer' as developer;


class ExerciseSetup extends StatefulWidget {
  const ExerciseSetup({Key? key}) : super(key: key);

  @override
  _ExerciseSetupState createState() => _ExerciseSetupState();
}

class _ExerciseSetupState extends State<ExerciseSetup> {
  static int selectedRepetition = 5;
  bool isCustomSelected = false;
  List<Exercise> selectedExercises = [];

  @override
  void initState() {
    super.initState();
    _loadLastSelectedRepetition();
    loadExercises().then((loadedExercises) {
      setState(() {
        selectedExercises = loadedExercises;
        logExercises(selectedExercises, "Selected Exercises");
      });
    });
    loadDefaultExercises().then((loadedDefaultExercises) {
      logExercises(loadedDefaultExercises, "Default Exercises");
    });
    _loadSelectedTherapy();
  }

  void logExercises(List<Exercise> exercises, String listName) {
    developer.log('\nLogging $listName:');
    for (var exercise in exercises) {
      developer.log('${exercise.name}: ${exercise.repetitions} repetitions');
    }
  }

  Future<void> _loadLastSelectedRepetition() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastRepetition = prefs.getInt('lastSelectedRepetition') ?? 5;
    setState(() {
      selectedRepetition = lastRepetition;
    });
  }

  void _loadSelectedTherapy() async {
    String selectedTherapy = await loadSelectedTherapy();
    developer.log('Selected Therapy: $selectedTherapy');
    setState(() {
      isCustomSelected = selectedTherapy == therapyCustom;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3d3d3d),
      appBar: CustomAppBarExerciseSetup(
        title: 'Exercise setup',
        onBackPressed: (){
          Navigator.pop(context);
        },
        isCustomSelected: isCustomSelected,
        onToggle: (bool value) {
          setState(() {
            isCustomSelected = value;
          });
        },
      ),
      body: isCustomSelected ? _buildCustomView() : _buildDefaultView(),
    );
  }



  Widget _buildCustomView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDraggableWidget(Exercise(name: 'Calf Raises', repetitions: 5, imagePath: 'lib/images/calfraises.png', isTime: false,)),
              _buildDraggableWidget(Exercise(name: 'Toe Stand', repetitions: 5, imagePath: 'lib/images/toestand.png', isTime: true,)),
              _buildDraggableWidget(Exercise(name: 'Toe Curls', repetitions: 5, imagePath: 'lib/images/toecurls.png', isTime: false,)),
              _buildDraggableWidget(Exercise(name: 'Time', repetitions: 10, imagePath: 'lib/images/time.png', isTime: true,)),
            ],
          ),
        ),
        _buildDragTarget(),
        Expanded(
          child: ListView.builder(
            itemCount: selectedExercises.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: _buildExerciseContainer(selectedExercises[index]),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white38,),
                    onPressed: () {
                      setState(() {
                        selectedExercises.removeAt(index);
                        saveExercises(selectedExercises);
                      });
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableWidget(Exercise exercise) {
    return Draggable<Exercise>(
      data: exercise,
      feedback: withOpacity(_buildImageContainer(Image.asset(exercise.imagePath))),
      childWhenDragging: withOpacity(_buildImageContainer(Image.asset(exercise.imagePath)), 0.3),
      onDragCompleted: () {},
      child: _buildImageContainer(Image.asset(exercise.imagePath)),
    );
  }

  Widget _buildDragTarget() {
    return DragTarget<Exercise>(
      onAccept: (exercise) {
        setState(() {
          selectedExercises.add(exercise);
          saveExercises(selectedExercises);
          print('selectedExercises:');
          for (var item in selectedExercises) {
            print('${item.name}, repetitions: ${item.repetitions}');
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100.h,
          width: 100.w,
          margin: EdgeInsets.only(bottom: 20.0),
          child: DottedBorder(
            color: Colors.white54,
            strokeWidth: 1.5,
            borderType: BorderType.RRect,
            dashPattern: [10, 5],
            radius: Radius.circular(10),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Drag exercises here',
                  style: GoogleFonts.varelaRound(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseContainer(Exercise exercise) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 15.w),
      width: 60.w,
      height: 60.h,
      margin: EdgeInsets.only(left: 50.h, right: 10.h, top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffcb732b)),
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (exercise.repetitions > 1) {
                  exercise.repetitions--;
                  saveExercises(selectedExercises);
                }
              });
            },
            child: Icon(Icons.remove),
          ),
          Text(
            '${exercise.repetitions} ${exercise.isTime ? "sec" : "X    "}',
            style: GoogleFonts.varelaRound(
              fontSize: 22.sp,
              fontWeight: FontWeight.w400,
              height: 0.8.h,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                exercise.repetitions++;
                saveExercises(selectedExercises);
              });
            },
            child: Icon(Icons.add),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: 40.w,
              height: 40.h,
              child: Image.asset(exercise.imagePath, fit: BoxFit.cover),
            ),
          ),
        ],
      ),
    );
  }

  Widget withOpacity(Widget widget, [double opacity = 0.7]) {
    return Opacity(
      opacity: opacity,
      child: widget,
    );
  }


  Widget _buildButton(int repetition) {
    bool isSelected = selectedRepetition == repetition;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 80.w, height: 30.h),
      child: ElevatedButton(
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('lastSelectedRepetition', repetition);
          setState(() {
            selectedRepetition = repetition;
            saveDefaultExercises(getDefaultExercises(repetition));
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

  Widget _buildDefaultView() {
    return SingleChildScrollView(
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
            IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRows(selectedRepetition, Image.asset('lib/images/calfraises.png')),
                  _buildRows(selectedRepetition * 3, Image.asset('lib/images/time.png'), suffix: "sec"),
                  _buildRows(selectedRepetition, Image.asset('lib/images/toecurls.png')),
                  _buildRows(selectedRepetition * 3, Image.asset('lib/images/time.png'), suffix: "sec"),
                  _buildRows(selectedRepetition * 3, Image.asset('lib/images/toestand.png'), suffix: "sec"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildImageContainer(Image image) {
    return Container(
      padding: EdgeInsets.all(7.r),
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffcb732b)),
        borderRadius: BorderRadius.circular(5.r),
        color: Colors.transparent,
      ),
      child: FittedBox(
        child: image,
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
          child: _buildImageContainer(image),
        ),
      ],
    );
  }
}
