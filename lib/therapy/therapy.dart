import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'detection/detectionlayer.dart';
import 'detector/colordetector.dart' as color_detector;
import 'detector/colordetectorasync.dart';
import 'dart:ui' as ui;
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

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
  List<BoundingBoxData> boundingBoxHistory = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? analysisTimer;
  MovementInfo currentMovement = MovementInfo(MovementState.idle, DateTime.now());

  Future<void> _playAudio(String fileName) async {
    try {
      await _audioPlayer.setSource(AssetSource(fileName));
      await _audioPlayer.play(AssetSource(fileName));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _colorDetector = ColorDetectorAsync();
    initCamera();
    _playAudio('ToeRising1.mp3');
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
    analysisTimer?.cancel();
    super.dispose();
  }

  void analyzeMovements() {
    if (boundingBoxHistory.length < 2) return;

    var previous = boundingBoxHistory[boundingBoxHistory.length - 2];
    var current = boundingBoxHistory.last;

    // Idő különbség a két bounding box adat között milliszekundumban
    var timeDiff = current.timestamp.difference(previous.timestamp).inMilliseconds;

    // Szélesség és magasság változása a két bounding box között
    double widthChange = (current.boundingBox[2] - current.boundingBox[0]) - (previous.boundingBox[2] - previous.boundingBox[0]);
    double heightChange = (current.boundingBox[3] - current.boundingBox[1]) - (previous.boundingBox[3] - previous.boundingBox[1]);

    // A változás sebessége, amit a magasság és a szélesség változásából számolunk, időegységre normálva
    double heightChangeRate = heightChange / timeDiff;
    double widthChangeRate = widthChange / timeDiff;

    // Hibakezelés: Ha a változások túl nagyok, lehet, hogy hiba történt
    if ((widthChange).abs() > 100 || (heightChange).abs() > 100) {
      currentMovement.setState(MovementState.idle);
      boundingBoxHistory.clear();
      print("Hiba: értelmetlen adatok érzékelve, állapot visszaállítása");
      return;
    }

    // Állapotgép logika a mozgás típusának azonosítására
    switch (currentMovement.state) {
      case MovementState.idle:
        if (heightChange > 10 && heightChangeRate > 0.1) {
          currentMovement.setState(MovementState.toeRising);
          print("Lábujjhegyre állás kezdete");
        } else if (widthChange < -10 && widthChangeRate < -0.1) {
          currentMovement.setState(MovementState.toesContracting);
          print("Lábujjhegyek behúzása");
        }
        break;
      case MovementState.toeRising:
        if (heightChange < -10 && heightChangeRate < -0.1) {
          currentMovement.setState(MovementState.toeFalling);
          print("Lábujjhegy állás vége, visszatérés a talajra");
        } else if ((heightChangeRate).abs() < 0.05) {
          currentMovement.setState(MovementState.toeHeld);
          print("Lábujjhegyen maradva");
        }
        break;
      case MovementState.toeFalling:
        if ((heightChangeRate).abs() < 0.05) {
          currentMovement.setState(MovementState.waitingNextMovement);
          print("Készen áll a következő mozgás érzékelésére");
        }
        break;
      case MovementState.waitingNextMovement:
        if (DateTime.now().difference(currentMovement.lastTransition).inMilliseconds > 500) {
          currentMovement.setState(MovementState.idle);
          boundingBoxHistory.clear();
          print("Állapot visszaállítása, újra kész a detektálásra");
        }
        break;
      case MovementState.toeHeld:
        if (heightChange < -10 && heightChangeRate < -0.1) {
          currentMovement.setState(MovementState.toeFalling);
          print("Lábujjhegy állás vége, visszatérés a talajra");
        } else {
          print("Lábujjhegyen maradva: ${currentMovement.toeHoldDuration().inSeconds} másodperc");
        }
        break;
      case MovementState.toesContracting:
        if (widthChange > 10 && widthChangeRate > 0.1) {
          currentMovement.setState(MovementState.toesExpanding);
          print("Lábujjhegyek behúzás vége, visszatérés az eredeti pozícióra");
        }
        break;
      case MovementState.toesExpanding:
        if ((widthChangeRate).abs() < 0.05) {
          currentMovement.setState(MovementState.waitingNextMovement);
          print("Készen áll a következő mozgás érzékelésére");
        }
        break;
      default:
        break;
    }
  }



  Future<void> initCamera() async {
    final cameras = await availableCameras();
    var idx = cameras.indexWhere((c) => c.lensDirection == CameraLensDirection.front);
    if (idx < 0) {
      print("No front camera found");
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
      print("Error initializing camera, error: ${e.toString()}");
    }

    if (mounted) {
      setState(() {});
    }
  }



  void _processCameraImage(CameraImage image) async {
    if (_detectionInProgress || !mounted || DateTime.now().millisecondsSinceEpoch - _lastRun < 30) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    int selectedHue = prefs.getInt('selectedHue') ?? 0;

    if(image.width > image.height){
      //print("LANDSCAPE");
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
    var res = await _colorDetector.detect(image, selectedHue);   //camFrameRotation
    //print("Hue to be detected: $selectedHue");
    //print("XXX Detection started: $res");
    _detectionInProgress = false;
    _lastRun = DateTime.now().millisecondsSinceEpoch;

    if (!mounted || res == null || res.isEmpty) {
      return;
    }

    if ((res.length / 4) != (res.length ~/ 4)) {
      print('Got invalid response from ColorDetector');
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

    // for (int i = 0; i < res.length; i += 2) {
    //   double newX = (image.width - res[i]) * _camFrameToScreenScale * 2;
    //   double newY = res[i + 1] * _camFrameToScreenScale * 2;
    //   foot.add(newX);
    //   foot.add(newY);
    // }

    boundingBoxHistory.add(BoundingBoxData(DateTime.now(), foot));
    analyzeMovements();

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

class BoundingBoxData {
  final DateTime timestamp;
  final List<double> boundingBox;

  BoundingBoxData(this.timestamp, this.boundingBox);
}

enum MovementState {
  idle,
  toeRising,
  toeElevated,
  toeFalling,
  waitingNextMovement,
  toeHeld,
  toesContracting,
  toesExpanding,
}


class MovementInfo {
  MovementState state;
  DateTime lastTransition;
  DateTime? toeHoldStart;

  MovementInfo(this.state, this.lastTransition);

  void setState(MovementState newState) {
    state = newState;
    lastTransition = DateTime.now();
    if (newState == MovementState.toeHeld) {
      toeHoldStart = DateTime.now();
    } else {
      toeHoldStart = null;
    }
  }

  Duration timeInCurrentState() {
    return DateTime.now().difference(lastTransition);
  }

  Duration toeHoldDuration() {
    return toeHoldStart != null ? DateTime.now().difference(toeHoldStart!) : Duration.zero;
  }
}
