import 'package:hive/hive.dart';
part 'drawingareaprimitives.g.dart';


@HiveType(typeId: 0)
class DrawingAreaPrimitives{
  @HiveField(0)
  double mainDx;
  @HiveField(1)
  double mainDy;
  @HiveField(2)
  double secondaryDx;
  @HiveField(3)
  double secondaryDy;
  @HiveField(4)
  double width;
  @HiveField(5)
  int color;
  @HiveField(6)
  String Mytype;


  DrawingAreaPrimitives({required this.width,required this.mainDx,required this.mainDy,required this.secondaryDx,required this.secondaryDy,required this.color,required this.Mytype});

}