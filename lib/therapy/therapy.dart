import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:himo/therapy/therapyend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../exercisesetup/exerciseprovider.dart';
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

  int _countdown = 15;
  Timer? _countdownTimer;
  bool _countdownComplete = false;
  List<Exercise> _exercises = [];
  int _currentExerciseIndex = 0;
  int _currentRepetitionCount = 0;
  int _currentHoldDuration = 0;
  int _remainedHoldDuration = 0;
  bool _exerciseAnnounced = false;
  bool _secondAudioPlayed = false;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _colorDetector = ColorDetectorAsync();
    initCamera();
    loadSelectedExercises();
    startCountdown();
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
    _countdownTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String fileName) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.release();
      //await _audioPlayer.setSource(AssetSource(fileName));
      await _audioPlayer.play(AssetSource(fileName));
      _audioPlayer.onPlayerComplete.listen((event) {
        _audioPlayer.release();
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _announceExercise(Exercise exercise) async {
    String announcement = 'Következő gyakorlat: ${exercise.name}, ${exercise.repetitions} ismétlés';
    print(announcement);
    _secondAudioPlayed = false;
    if(exercise.name == "ToeStand"){
      _remainedHoldDuration = _exercises[_currentExerciseIndex].repetitions;
    }
    if(exercise.name == "Time"){
      await _playAudioWithCompletion('${exercise.name}.mp3', () async {
        if (!_secondAudioPlayed) {
          await _playAudio('${exercise.repetitions}s.mp3');
          _secondAudioPlayed = true;
        }
      });
      Future.delayed(Duration(seconds: exercise.repetitions), () {
        _currentRepetitionCount = 0;
        _currentExerciseIndex++;
        if (_currentExerciseIndex < _exercises.length) {
          Future.delayed(Duration(seconds: 3), () {
            _announceExercise(_exercises[_currentExerciseIndex]);
          });
        } else {
          print("Az összes gyakorlat befejeződött");
          _exerciseAnnounced = false;
          boundingBoxHistory.clear();
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TherapyEnd()),
            );
          });
        }
      });
    }
    else{
      await _playAudioWithCompletion('${exercise.name}.mp3', () async {
        if (!_secondAudioPlayed) {
          if(exercise.isTime){
            await _playAudio('${exercise.repetitions}s.mp3');
          }
          else{
            await _playAudio('${exercise.repetitions}.mp3');
          }
          _secondAudioPlayed = true;
        }
        _exerciseAnnounced = true;
      });
    }
  }


  Future<void> _playAudioWithCompletion(String fileName, VoidCallback onComplete) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.release();
      //await _audioPlayer.setSource(AssetSource(fileName));
      await _audioPlayer.play(AssetSource(fileName));
      _audioPlayer.onPlayerComplete.listen((event) {
        onComplete();
        _audioPlayer.release();
      });
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        setState(() {
          _countdownComplete = true;
        });
        _countdownTimer?.cancel();
        if (_exercises.isNotEmpty) {
          _announceExercise(_exercises[_currentExerciseIndex]);
        }
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  Future<void> loadSelectedExercises() async {
    String selectedTherapy = await loadSelectedTherapy();
    if (selectedTherapy == therapyDefault) {
      _exercises = await loadDefaultExercises();
    } else {
      _exercises = await loadExercises();
    }
    setState(() {
      _currentExerciseIndex = 0;
    });
  }

  void analyzeMovements() {
    if (!_countdownComplete || boundingBoxHistory.length < 2 || !_exerciseAnnounced) return;

    var previous = boundingBoxHistory[boundingBoxHistory.length - 2];
    var current = boundingBoxHistory.last;

    // Idő különbség a két bounding box adat között milliszekundumban
    var timeDiff = current.timestamp.difference(previous.timestamp).inMilliseconds;

    // Szélesség és magasság változása a két bounding box között
    double widthChange = (current.boundingBox[2] - current.boundingBox[0]).abs() - (previous.boundingBox[2] - previous.boundingBox[0]).abs();
    double heightChange = (current.boundingBox[3] - current.boundingBox[1]).abs() - (previous.boundingBox[3] - previous.boundingBox[1]).abs();

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
        if (heightChange > 10 && heightChangeRate > 0.3) {
          currentMovement.setState(MovementState.toeRising);
          print("Lábujjhegyre állás kezdete");
        } else if (widthChange < -5 && widthChangeRate < -0.05 && (heightChangeRate).abs() < 0.05) {
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
          handleRepetitionCompletion("CalfRaises");
        }
        break;
      case MovementState.waitingNextMovement:
        if (DateTime.now().difference(currentMovement.lastTransition).inMilliseconds > 100) {
          currentMovement.setState(MovementState.idle);
          boundingBoxHistory.clear();
          print("Állapot visszaállítása, újra kész a detektálásra");
        }
        break;
      case MovementState.toeHeld:
        if (heightChange < -10 && heightChangeRate < -0.1) {
          currentMovement.setState(MovementState.toeFalling);
          print("Lábujjhegy állás vége, visszatérés a talajra");
          if(_exercises[_currentExerciseIndex].name == "ToeStand"){
            if (_currentHoldDuration < _remainedHoldDuration){
              _remainedHoldDuration -= _currentHoldDuration;
              _playAudio("keepgoing.mp3");
            }
          }
        } else {
          print("Lábujjhegyen maradva: ${currentMovement.toeHoldDuration().inSeconds} másodperc");
          if(_exercises[_currentExerciseIndex].name == "ToeStand"){
            _currentHoldDuration = currentMovement.toeHoldDuration().inSeconds;
            if (_currentHoldDuration >= _remainedHoldDuration) {
              _playAudio("finished.mp3");
              _currentRepetitionCount = 0;
              _currentHoldDuration = 0;
              _currentExerciseIndex++;
              if (_currentExerciseIndex < _exercises.length) {
                _exerciseAnnounced = false;
                print("ToeStand gyakorlat vége");
                Future.delayed(Duration(seconds: 3), () {
                  _announceExercise(_exercises[_currentExerciseIndex]);
                });
              } else {
                print("Az összes gyakorlat befejeződött");
                _exerciseAnnounced = false;
                boundingBoxHistory.clear();
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TherapyEnd()),
                  );
                });
              }
            }
          }
        }
        break;
      case MovementState.toesContracting:
        if (widthChange > 5 && widthChangeRate > 0.05) {
          currentMovement.setState(MovementState.toesExpanding);
          print("Lábujjhegyek behúzás vége, visszatérés az eredeti pozícióra");
        }
        break;
      case MovementState.toesExpanding:
        if ((widthChangeRate).abs() < 0.05) {
          currentMovement.setState(MovementState.waitingNextMovement);
          print("Készen áll a következő mozgás érzékelésére");
          handleRepetitionCompletion("ToeCurls");
        }
        break;
      default:
        break;
    }
  }

  void handleRepetitionCompletion(String exerciseName) {
    if(_exercises[_currentExerciseIndex].name == exerciseName){
      if(_currentRepetitionCount == _exercises[_currentExerciseIndex].repetitions - 1){
        _playAudio('finished.mp3');
      }
      else{
        _playAudio('correct.mp3');
      }
      _currentRepetitionCount++;
      if (_currentRepetitionCount >= _exercises[_currentExerciseIndex].repetitions) {
        _currentRepetitionCount = 0;
        _currentExerciseIndex++;
        if (_currentExerciseIndex < _exercises.length) {
          _exerciseAnnounced = false;
          print("$exerciseName gyakorlat vége");
          Future.delayed(Duration(seconds: 3), () {
            _announceExercise(_exercises[_currentExerciseIndex]);
          });
        } else {
          print("Az összes gyakorlat befejeződött");
          _exerciseAnnounced = false;
          boundingBoxHistory.clear();
          Future.delayed(Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => TherapyEnd()),
            );
          });
        }
      }
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
    if(_exerciseAnnounced){
      analyzeMovements();
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
        if (!_countdownComplete)
          Center(
            child: Container(
              color: Colors.transparent,
              child: Text(
                '$_countdown',
                style: TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.withOpacity(0.7),
                  decoration: TextDecoration.none
                ),
              ),
            ),
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
