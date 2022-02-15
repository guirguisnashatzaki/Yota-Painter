import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:yotapainter/Model/drawingarea.dart';






class MyCustomPainter extends CustomPainter{

  List<DrawingArea?> points=[];
  //Color selectedColor;
  double radius;
  List<Offset> startPoints,endPoints,centersList,intersectionList;
  double numberOfSquaresX,numberOfSquaresY;
  bool grid,centers,colouring,selectingPoints,intersections;
  Offset selecting,divideXStart,divideYStart,divideXEnd,divideYEnd;
  Offset? checked;

  MyCustomPainter({required this.points,required this.startPoints,required this.endPoints,required this.grid,required this.numberOfSquaresX,required this.numberOfSquaresY,required this.centers,required this.centersList,required this.colouring,required this.selectingPoints,required this.selecting,required this.checked,required this.intersections,required this.intersectionList,required this.radius,required this.divideXStart,required this.divideYStart,required this.divideXEnd,required this.divideYEnd});

  @override
  void paint(Canvas canvas, Size size) {
    // background
    Paint background=Paint()..color=Colors.white;
    Rect rect=Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);

    /*final arc=Path();
    arc.moveTo(100,100);
    arc.arcToPoint(
      Offset(200,200),
      radius: Radius.circular(3000000),
      //clockwise: true,
      //largeArc: true
    );
    arc.arcToPoint(
      Offset(150,100),
      radius: Radius.circular(3000000000),
    );
    arc.arcToPoint(
      Offset(100,100),
      radius: Radius.circular(300000000000),
    );
    Paint paintGrid=Paint();
    paintGrid.color=Colors.red;
    paintGrid.strokeWidth=5;
    paintGrid.isAntiAlias=true;
    paintGrid.strokeCap=StrokeCap.round;

    Paint paintGrid2=Paint();
    paintGrid2.color=Colors.yellowAccent;
    paintGrid2.strokeWidth=5;
    paintGrid2.isAntiAlias=true;
    paintGrid2.strokeCap=StrokeCap.round;

    canvas.drawPath(arc, paintGrid);
    canvas.drawPoints(PointMode.points, [Offset(100, 100)], paintGrid2);*/

    //Centers
    if(centers==true){
      Paint paintGrid=Paint();
      paintGrid.color=Colors.red;
      paintGrid.strokeWidth=radius*0.3;
      paintGrid.isAntiAlias=true;
      paintGrid.strokeCap=StrokeCap.round;

      for(int i=0;i<centersList.length;i++){
        canvas.drawPoints(PointMode.points, [centersList[i]], paintGrid);
      }
    }


    //Intersections
    if(intersections==true){
      Paint paintGrid=Paint();
      paintGrid.color=Colors.black;
      paintGrid.strokeWidth=radius*0.3;
      paintGrid.isAntiAlias=true;
      paintGrid.strokeCap=StrokeCap.round;

      for(int i=0;i<intersectionList.length;i++){
        canvas.drawPoints(PointMode.points, [intersectionList[i]], paintGrid);
      }
    }


    //Grid

    if(grid==true){
      Paint paintGrid=Paint();
      paintGrid.color=Colors.grey;
      paintGrid.strokeWidth=radius*0.025;
      paintGrid.isAntiAlias=true;
      paintGrid.strokeCap=StrokeCap.round;


      for(int i=0;i<startPoints.length;i++){
        canvas.drawLine(startPoints[i], endPoints[i], paintGrid);
      }

      Paint paintGrid2=Paint();
      paintGrid2.color=Colors.black;
      paintGrid2.strokeWidth=radius*0.05;
      paintGrid2.isAntiAlias=true;
      paintGrid2.strokeCap=StrokeCap.round;

      canvas.drawLine(divideYStart, divideYEnd, paintGrid2);
      canvas.drawLine(divideXStart, divideXEnd, paintGrid2);
    }


    //canvas.drawLine(Offset(0,0), Offset(50,50), paint);




    /*if(colouring==true){
      for(int x=0;x<points.length;x++){
        if(points[x]!=null && points[x+1]!=null){
          Paint paint=points[x].areaPaint;
          canvas.drawLine(points[x].mainPoint, points[x+1].mainPoint, paint);
        }else if(points[x]!=null && points[x+1]==null){
          Paint paint=points[x].areaPaint;
          canvas.drawPoints(PointMode.points, [points[x].mainPoint], paint);
        }
      }
    }
    */

    //Drawing

    for(int x=0;x<points.length;x++){
      if(points[x]==null){

      }else if(points[x]!.type.compareTo("Point")==0){
        canvas.drawPoints(PointMode.points, [points[x]!.mainPoint], points[x]!.areaPaint);
      }else if(points[x]!.type.compareTo("Line")==0){
        canvas.drawLine(points[x]!.mainPoint, points[x]!.secondaryPoint, points[x]!.areaPaint);
      }else if(points[x]!.type.compareTo("Upper curve")==0){
        late Offset main,secondary;
        if(points[x]!.mainPoint.dx<points[x]!.secondaryPoint.dx){
          main=points[x]!.mainPoint;
          secondary=points[x]!.secondaryPoint;
        }else if(points[x]!.mainPoint.dx>=points[x]!.secondaryPoint.dx){
          main=points[x]!.secondaryPoint;
          secondary=points[x]!.mainPoint;
        }

        final arc=Path();
        arc.moveTo(main.dx,main.dy);
        arc.arcToPoint(
          Offset(secondary.dx,secondary.dy),
          radius: Radius.circular(radius),
          //clockwise: true,
          //largeArc: true
        );
        canvas.drawPath(arc, points[x]!.areaPaint);
      }
      else if(points[x]!.type.compareTo("Lower curve")==0){
        late Offset main,secondary;
        if(points[x]!.mainPoint.dx>points[x]!.secondaryPoint.dx){
          main=points[x]!.mainPoint;
          secondary=points[x]!.secondaryPoint;
        }else if(points[x]!.mainPoint.dx<=points[x]!.secondaryPoint.dx){
          main=points[x]!.secondaryPoint;
          secondary=points[x]!.mainPoint;
        }

        final arc=Path();
        arc.moveTo(main.dx,main.dy);
        arc.arcToPoint(
          Offset(secondary.dx,secondary.dy),
          radius: Radius.circular(radius),
          //clockwise: true,
          //largeArc: true
        );
        canvas.drawPath(arc, points[x]!.areaPaint);
      }else if(points[x]!.type.compareTo("Colour")==0){
        for(int x=0;x<points.length;x++){
          if(points[x]!=null && points[x+1]!=null){
            Paint paint=points[x]!.areaPaint;
            canvas.drawLine(points[x]!.mainPoint, points[x+1]!.mainPoint, paint);
          }else if(points[x]!=null && points[x+1]==null){
            Paint paint=points[x]!.areaPaint;
            canvas.drawPoints(PointMode.points, [points[x]!.mainPoint], paint);
          }
        }

      }
    }

    //Selecting Points

    if(selectingPoints==true){
      /*Paint paintGrid=Paint();
      paintGrid.color=Colors.red;
      paintGrid.strokeWidth=1;
      //paintGrid.isAntiAlias=true;
      //paintGrid.strokeCap=StrokeCap.round;
      paintGrid.style=PaintingStyle.stroke;
      canvas.drawCircle(selecting, 10, paintGrid);*/

      if(checked!=null){
        Paint paintGrid=Paint();
        paintGrid.color=Colors.green;
        paintGrid.strokeWidth=radius*0.1;
        //paintGrid.isAntiAlias=true;
        //paintGrid.strokeCap=StrokeCap.round;
        paintGrid.style=PaintingStyle.stroke;
        canvas.drawCircle(checked!, radius*0.4, paintGrid);
      }
    }





  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}