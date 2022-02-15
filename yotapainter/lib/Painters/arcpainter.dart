import 'package:flutter/material.dart';

class ArcPainter extends CustomPainter{
  late bool selected;
  ArcPainter({required this.selected});
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paintGrid=Paint();
    paintGrid.color=selected? Colors.white:Colors.black;
    paintGrid.strokeWidth=2;
    paintGrid.style=PaintingStyle.stroke;
    paintGrid.isAntiAlias=true;
    paintGrid.strokeCap=StrokeCap.round;
    Paint paintGrid2=Paint();
    paintGrid2.color=selected? Colors.black:Colors.white;
    paintGrid2.strokeWidth=selected? 30:2;
    paintGrid2.style=PaintingStyle.stroke;
    //paintGrid.isAntiAlias=true;
    //paintGrid.strokeCap=StrokeCap.round;

    final arc=Path();
    arc.moveTo(-10,0);
    arc.arcToPoint(
      const Offset(10, 0),
      radius: const Radius.circular(10),
      //clockwise: true,
      //largeArc: true
    );

    canvas.drawCircle(const Offset(0, 0), 2, paintGrid2,);
    //canvas.drawLine(const Offset(0, -7),const Offset(0, 7) , paintGrid);
    //canvas.drawLine(const Offset(-7, 0),const Offset(7, 0) , paintGrid);
    canvas.drawPath(arc, paintGrid);



  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}