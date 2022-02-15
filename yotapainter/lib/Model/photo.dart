import 'package:hive/hive.dart';

import 'drawingareaprimitives.dart';

part 'photo.g.dart';



@HiveType(typeId: 1)
class Photo{
  @HiveField(0)
  String path;
  @HiveField(1)
  List<DrawingAreaPrimitives> list;
  @HiveField(2)
  double x;
  @HiveField(3)
  double y;

  Photo({required this.path,required this.list,required this.x,required this.y});

}