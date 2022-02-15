// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawingareaprimitives.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DrawingAreaPrimitivesAdapter extends TypeAdapter<DrawingAreaPrimitives> {
  @override
  final int typeId = 0;

  @override
  DrawingAreaPrimitives read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DrawingAreaPrimitives(
      width: fields[4] as double,
      mainDx: fields[0] as double,
      mainDy: fields[1] as double,
      secondaryDx: fields[2] as double,
      secondaryDy: fields[3] as double,
      color: fields[5] as int,
      Mytype: fields[6].toString() as String,
    );
  }

  @override
  void write(BinaryWriter writer, DrawingAreaPrimitives obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.mainDx)
      ..writeByte(1)
      ..write(obj.mainDy)
      ..writeByte(2)
      ..write(obj.secondaryDx)
      ..writeByte(3)
      ..write(obj.secondaryDy)
      ..writeByte(4)
      ..write(obj.width)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.Mytype);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DrawingAreaPrimitivesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
