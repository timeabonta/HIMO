import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';
import 'package:himo/calibration/calibration3.dart';
import 'package:himo/calibration/failedcalibration.dart';

class Calibration2 extends StatefulWidget {
  const Calibration2({Key? key}) : super(key: key);

  @override
  State<Calibration2> createState() => _Calibration2State();
}

class _Calibration2State extends State<Calibration2> {
  List<File>? _imageFiles;

  void _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<DetectedObject>? detectedObjects = await NativeOpencv.detectAndFrameObjects(imageFile.path);
      if (detectedObjects != null && detectedObjects.isNotEmpty) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Calibration3(detectedObjects: detectedObjects)));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context) => FailedCalibration()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calibration'),
      ),
      body: Center(
        child: _imageFiles != null
            ? Column(
          children: _imageFiles!.map((file) => Image.file(file)).toList(),
        )
            : Text('No image selected'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
