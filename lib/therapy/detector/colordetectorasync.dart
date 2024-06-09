import 'dart:isolate';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:async';
import 'colordetector.dart' as color_detector;
import 'dart:ui' as ui;
import 'dart:developer';


class ColorDetectorAsync {
  bool arThreadReady = false;
  late Isolate _detectorThread;
  late SendPort _toDetectorThread;
  int _reqId = 0;
  final Map<int, Completer> _cbs = {};

  ColorDetectorAsync() {
    _initDetectionThread();
  }

  void _initDetectionThread() async {
    // Create the port on which the detector thread will send us messages and listen to it.
    ReceivePort fromDetectorThread = ReceivePort();
    fromDetectorThread.listen(_handleMessage, onDone: () {
      arThreadReady = false;
    });

    final initReq = color_detector.InitRequest(toMainThread: fromDetectorThread.sendPort);
    _detectorThread = await Isolate.spawn(color_detector.init, initReq);
  }

  Future<Float32List?> detect(CameraImage image, int rotation) {

    if (!arThreadReady) {
      return Future.value(null);
    }

    var reqId = ++_reqId;
    var res = Completer<Float32List?>();
    _cbs[reqId] = res;
    var msg = color_detector.Request(
      reqId: reqId,
      method: 'detect',
      params: {'image': image, 'rotation': rotation},
    );

    _toDetectorThread.send(msg);
    return res.future;
  }

  void destroy() async {
    if (!arThreadReady) {
      return;
    }

    arThreadReady = false;

    // We send a Destroy request and wait for a response before killing the thread
    var reqId = ++_reqId;
    var res = Completer();
    _cbs[reqId] = res;
    var msg = color_detector.Request(reqId: reqId, method: 'destroy');
    _toDetectorThread.send(msg);

    // Wait for the detector to acknowledge the destroy and kill the thread
    await res.future;
    _detectorThread.kill();
  }

  void _handleMessage(data) {
    // The detector thread send us its SendPort on init, if we got it this means the detector is ready
    if (data is SendPort) {
      _toDetectorThread = data;
      arThreadReady = true;
      return;
    }

    // Make sure we got a Response object
    if (data is color_detector.Response) {
      // Find the Completer associated with this request and resolve it
      var reqId = data.reqId;
      _cbs[reqId]?.complete(data.data);
      _cbs.remove(reqId);
      return;
    }

    log('Unknown message from ColorDetector, got: $data');
  }
}