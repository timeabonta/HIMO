import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'detection/detectionlayer.dart';
import 'detector/colordetector.dart' as color_detector;
import 'detector/colordetectorasync.dart';
import 'dart:ui' as ui;
import 'dart:developer';
import 'dart:io';

class Therapy extends StatefulWidget {
  const Therapy({Key? key}) : super(key: key);

  @override
  State<Therapy> createState() => _TherapyState();
}

class _TherapyState extends State<Therapy> with WidgetsBindingObserver{
  CameraController? _camController;
  late ColorDetectorAsync _colorDetector;
  double _camFrameToScreenScale = 0;
  int _camFrameRotation = 0;
  int _lastRun = 0;
  bool _detectionInProgress = false;
  List<double> _foot = List.empty();

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _colorDetector = ColorDetectorAsync();
    initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _camController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _colorDetector.destroy();
    _camController?.dispose();
    super.dispose();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    var idx = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
    if (idx < 0) {
      log("No front camera found");
      return;
    }

    var desc = cameras[idx];
    _camController = CameraController(
      desc,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.yuv420 : ImageFormatGroup.bgra8888,
    );

    try {
      await _camController!.initialize();
      await _camController!.startImageStream((image) => _processCameraImage(image));
    } catch (e) {
      log("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_detectionInProgress || !mounted || DateTime.now().millisecondsSinceEpoch - _lastRun < 30) {
      return;
    }

    if(image.width > image.height){
      log("LANDSCAPE");
    }

    // calc of the scale factor to convert from camera frame coords to screen coords
    if (_camFrameToScreenScale == 0) {
      double screenAspectRatio = MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
      double imageAspectRatio = image.width / image.height;
      if (screenAspectRatio > imageAspectRatio) {
        _camFrameToScreenScale = MediaQuery.of(context).size.height / image.height;
      } else {
        _camFrameToScreenScale = MediaQuery.of(context).size.width / image.width;
      }
    }


    // calling the detector
    _detectionInProgress = true;
    var res = await _colorDetector.detect(image, 0);   //camFrameRotation
    log("XXX Detection started: $res");
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;

    if (!mounted || res == null || res.isEmpty) {
      return;
    }

    if ((res.length / 4) != (res.length ~/ 4)) {
      log('Got invalid response from ColorDetector');
      return;
    }

    // from camera frame coords to screen coords
    final foot = List<double>.empty(growable: true);
    for (int i = 0; i < res.length; i += 2) {
      double newX = res[i] * _camFrameToScreenScale * 2;
      double newY = (image.height - res[i + 1]) * _camFrameToScreenScale * 2;
      foot.add(newX);
      foot.add(newY);
    }
    setState(() {
      _foot = foot;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    if (_camController == null) {
      return const Center(
        child: Text('Loading...'),
      );
    }

    return Stack(
      children: [
        CameraPreview(_camController!),
        DetectionsLayer(
          boundingBoxes: _foot,
        ),
      ],
    );
  }
}