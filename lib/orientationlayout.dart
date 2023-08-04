import 'package:flutter/material.dart';

class OrientationLayout extends StatelessWidget {
  final Widget portraitLayout;
  final Widget landscapeLayout;

  const OrientationLayout({
    required this.portraitLayout,
    required this.landscapeLayout,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return landscapeLayout;
        } else {
          return portraitLayout;
        }
      },
    );
  }
}