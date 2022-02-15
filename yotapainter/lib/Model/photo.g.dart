// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PhotoAdapter extends TypeAdapter<Photo> {
  @override
  final int typeId = 1;

  @override
  Photo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Photo(
      path: fields[0] as String,
      list: (fields[1] as List).cast<DrawingAreaPrimitives>(),
      x: fields[2] as double,
      y: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Photo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.path)
      ..writeByte(1)
      ..write(obj.list)
      ..writeByte(2)
      ..write(obj.x)
      ..writeByte(3)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
