import 'package:flutter/material.dart';

class LinePainter extends CustomPainter{
  late bool selected;
  LinePainter({required this.selected});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paintCircle=Paint();
    paintCircle.color=selected? Colors.black:Colors.white;
    paintCircle.strokeWidth=selected? 30:2;
    paintCircle.isAntiAlias=true;
    paintCircle.strokeCap=StrokeCap.round;
    paintCircle.style=PaintingStyle.stroke;


    Paint paint=Paint();
    paint.color=selected? Colors.white:Colors.black;
    paint.strokeWidth=2;
    paint.isAntiAlias=true;
    paint.strokeCap=StrokeCap.round;


    canvas.drawCircle(const Offset(0, 0), 2, paintCircle,);

    canvas.drawLine(const Offset(0, -7),const Offset(0, 7) , paint);
    //canvas.drawLine(const Offset(-7, 0),const Offset(7, 0) , paintGrid);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}