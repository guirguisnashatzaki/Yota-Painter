import 'package:flutter/material.dart';

import 'Model/drawingarea.dart';



class PanAndZoomNotifier extends ChangeNotifier {
  bool panning =true,zooming =true;

  void setPanToTrue() {
      panning=true;
      notifyListeners();
  }

  void setPanToFalse() {
    panning=false;
    notifyListeners();
  }

  void setZoomToTrue() {
    zooming=true;
    notifyListeners();
  }

  void setZoomToFalse() {
    zooming=false;
    notifyListeners();
  }


}

class ZoomNotifier extends ChangeNotifier{

  bool zooming =true;

  void setZoomToTrue() {
    zooming=true;
    notifyListeners();
  }

  void setZoomToFalse() {
    zooming=false;
    notifyListeners();
  }
}

class PointNotifier extends ChangeNotifier{

  bool point =false;

  void setPointToTrue() {
    point=true;
    notifyListeners();
  }

  void setPointToFalse() {
    point=false;
    notifyListeners();
  }
}

class ColouringNotifier extends ChangeNotifier{

  bool colouring =false;

  void setColouringToTrue() {
    colouring=true;
    notifyListeners();
  }

  void setColouringToFalse() {
    colouring=false;
    notifyListeners();
  }
}

class CustomPaintNotifier extends ChangeNotifier{

  bool panning =true,zooming =true;

  void setPanToTrue() {
    panning=true;
    notifyListeners();
  }

  void setPanToFalse() {
    panning=false;
    notifyListeners();
  }

  void setZoomToTrue() {
    zooming=true;
    notifyListeners();
  }

  void setZoomToFalse() {
    zooming=false;
    notifyListeners();
  }

  bool grid =true;

  void setGridToTrue() {
    grid=true;
    notifyListeners();
  }

  void setGridToFalse() {
    grid=false;
    notifyListeners();
  }

  bool centers =false;

  void setCentersToTrue() {
    centers=true;
    notifyListeners();
  }

  void setCentersToFalse() {
    centers=false;
    notifyListeners();
  }

  bool intersections=false;

  void setIntersectionsToTrue() {
    intersections=true;
    notifyListeners();
  }

  void setIntersectionsToFalse() {
    intersections=false;
    notifyListeners();
  }

  bool colouring =false;

  void setColouringToTrue() {
    colouring=true;
    notifyListeners();
  }

  void setColouringToFalse() {
    colouring=false;
    notifyListeners();
  }

  List<DrawingArea> points=[];

  void addPoint(DrawingArea area){
    points.add(area);
    notifyListeners();
  }

  void undo(){
    if(points.isNotEmpty){
      points.removeLast();
      notifyListeners();
    }
  }

  void clear(){
    points.clear();
    notifyListeners();
  }

  void remove(int index){
    points.removeAt(index);
    notifyListeners();
  }

  void addall(List<DrawingArea> list){
    points.addAll(list);
    notifyListeners();
  }


  bool selectingPoints=false;

  void setSelectingPointsToTrue(){
    selectingPoints=true;
    notifyListeners();
  }

  void setSelectingPointsToFalse(){
    selectingPoints=false;
    notifyListeners();
  }


  List<Offset> pointsToBeSelected=[];

  void addPointToBeSelected(Offset point){
    pointsToBeSelected.add(point);
    notifyListeners();
  }

  void deletePointToBeSelected(Offset point){
    pointsToBeSelected.remove(point);
    notifyListeners();
  }

  int indexOfPoints=0;

  void increment(){
    indexOfPoints++;
    notifyListeners();
  }

  void decrement(){
    indexOfPoints--;
    notifyListeners();
  }

  Offset? checkedPoint=null;

  void makePointChecked(Offset p){
    checkedPoint=p;
    notifyListeners();
  }

  void makePointCheckedNull(){
    checkedPoint=null;
    notifyListeners();
  }

  void makePointNull(){
    checkedPoint=null;
    notifyListeners();
  }

  Color color=Colors.black;

  void changeColor(Color color){
    this.color=color;
    notifyListeners();
  }
}

class SelectingPointsNotifier extends ChangeNotifier{

  bool selectingPoints=false;

  void setSelectingPointsToTrue(){
    selectingPoints=true;
    notifyListeners();
  }

  void setSelectingPointsToFalse(){
    selectingPoints=false;
    notifyListeners();
  }

  Color color=Colors.black;

  void changeColor(Color color){
    this.color=color;
    notifyListeners();
  }

  double strokeWidth=1.0;

  void changeStrokeWidth(double width){
    strokeWidth=width;
    notifyListeners();
  }
}

class ColorNotifier extends ChangeNotifier{

  Color color=Colors.black;

  void changeColor(Color color){
    this.color=color;
    notifyListeners();
  }

  double strokeWidth=1.0;

  void changeStrokeWidth(double width){
    strokeWidth=width;
    notifyListeners();
  }
}

class DrawingNotifier extends ChangeNotifier{
  bool line=false,arc=false,antiArc=false;

  void setLineToTrue(){
    line=true;
    arc=false;
    antiArc=false;
    notifyListeners();
  }

  void setArcToTrue(){
    line=false;
    arc=true;
    antiArc=false;
    notifyListeners();
  }

  void setAntiArcToTrue(){
    line=false;
    arc=false;
    antiArc=true;
    notifyListeners();
  }

  void setAllToFalse(){
    line=false;
    arc=false;
    antiArc=false;
    notifyListeners();
  }
}

class LineOrArc{
  String lineorarc="";

  void setstring(String s){
    this.lineorarc=s;
  }

}