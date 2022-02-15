import 'dart:ui';

import 'package:flutter/material.dart';

class DotPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paintGrid=Paint();
    paintGrid.color=Colors.black;
    paintGrid.strokeWidth=2;
    paintGrid.isAntiAlias=true;
    paintGrid.strokeCap=StrokeCap.round;

    canvas.drawPoints(PointMode.points, [const Offset(0, 0)], paintGrid);
    canvas.drawCircle(const Offset(0, 0), 2, paintGrid);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}