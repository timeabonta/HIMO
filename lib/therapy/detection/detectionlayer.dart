import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui' as ui;


class DetectionsLayer extends StatelessWidget {
  const DetectionsLayer({
    Key? key,
    required this.boundingBoxes,
  }) : super(key: key);

  final List<double> boundingBoxes;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BoundingBoxesPainter(boundingBoxes: boundingBoxes),
    );
  }
}

class BoundingBoxesPainter extends CustomPainter {
  BoundingBoxesPainter({required this.boundingBoxes});

  final List<double> boundingBoxes;

  final _paint = Paint()
    ..strokeWidth = 2.0
    ..color = Colors.lightGreenAccent
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {

    for (int i = 0; i < boundingBoxes.length; i += 4) {
      // Convert the bounding box to four corners
      final x1 = boundingBoxes[i];
      final y1 = boundingBoxes[i + 1];
      final x2 = boundingBoxes[i + 2];
      final y2 = boundingBoxes[i + 3];

      final rect = Rect.fromLTRB(x1, y1, x2, y2);
      canvas.drawRect(rect, _paint);
    }
  }

  @override
  bool shouldRepaint(BoundingBoxesPainter oldDelegate) {
    return !listEquals(oldDelegate.boundingBoxes, boundingBoxes);
  }
}