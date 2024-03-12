import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:native_opencv/native_opencv.dart';

class Calibration2 extends StatefulWidget {
  const Calibration2({Key? key}) : super(key: key);

  @override
  State<Calibration2> createState() => _Calibration2State();
}

class _Calibration2State extends State<Calibration2> {
  File? _imageFile;

  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String result = await NativeOpencv.processImage(imageFile.path);
      print(result);
      setState(() {
        _imageFile = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calibration'),
      ),
      body: Center(
        child: _imageFile != null
            ? Image.file(_imageFile!)
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
