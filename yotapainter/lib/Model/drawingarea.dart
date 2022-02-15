import 'package:flutter/material.dart';





class DrawingArea{

  Offset mainPoint;

  Offset secondaryPoint;

  Paint areaPaint;

  String type;

  DrawingArea({required this.mainPoint,required this.areaPaint,required this.secondaryPoint,required this.type});
}