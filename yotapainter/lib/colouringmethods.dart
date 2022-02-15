import 'dart:math';
import 'dart:ui';

import 'package:yotapainter/Model/drawingarea.dart';

class methods{

  Offset closestPoint(Offset tappedPoint,List<Offset> points){
    List<double> distances=[];
    for(int i=0;i<points.length;i++){
      distances.add(sqrt(pow(tappedPoint.dx-points[i].dx,2)+pow(tappedPoint.dy-points[i].dy,2)));
    }

    double min=99999999999999991611392;

    for(int j=0;j<distances.length;j++){
      if(distances[j]<min){
        min=distances[j];
      }
    }

    return points[distances.indexOf(min)];
  }

  double _calcDistance(Offset firstPoint,Offset secondPoint){
    return sqrt(pow(firstPoint.dx-secondPoint.dx,2)+pow(firstPoint.dy-secondPoint.dy,2));
  }

  double _calcdistancebetshapeandpoint(Offset tappedPoint,DrawingArea drawingArea){
    double firstDistance=_calcDistance(tappedPoint, drawingArea.mainPoint);
    double secondDistance=_calcDistance(tappedPoint, drawingArea.secondaryPoint);

    if(firstDistance<secondDistance){
      return secondDistance;
    }

    return firstDistance;
  }

  bool compareoffsets(Offset first,Offset second){
    if(first.dx==second.dx && first.dy==second.dy){
      return true;
    }
    return false;
  }

  bool searchpointinshape(Offset point,DrawingArea shape){
    if(compareoffsets(point, shape.mainPoint)){
      return true;
    }

    if(compareoffsets(point, shape.secondaryPoint)){
      return true;
    }

    return false;
  }

  DrawingArea? findclosestshapeintersectedwiththefirst(Offset pointatnow,List<DrawingArea> sortedshapes,int bannedshapeindex,Offset tappedpoint){
    DrawingArea selectedshape=sortedshapes[0];

    List<DrawingArea> intersectedshapes=[];
    for(int i=0;i<sortedshapes.length;i++){
      if(i!=bannedshapeindex){
        if(searchpointinshape(pointatnow, sortedshapes[i])){
          intersectedshapes.add(sortedshapes[i]);
        }
      }
    }

    if(intersectedshapes.isEmpty){
      return null;
    }

    List<double> dists=[];

    for(int i=0;i<intersectedshapes.length;i++){
      dists.add(_calcdistancebetshapeandpoint(tappedpoint, intersectedshapes[i]));
    }

    double min =double.maxFinite;
    int chosenindex=0;

    for(int i=0;i<dists.length;i++){
      if(min>dists[i]){
        min=dists[i];
        chosenindex=i;
      }
    }

    return intersectedshapes[chosenindex];
  }

}