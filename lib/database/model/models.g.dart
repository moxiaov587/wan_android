// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponseCacheAdapter extends TypeAdapter<ResponseCache> {
  @override
  final int typeId = 0;

  @override
  ResponseCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseCache(
      uri: fields[0] as String,
      timeStamp: fields[1] as int,
      data: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ResponseCache obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.uri)
      ..writeByte(1)
      ..write(obj.timeStamp)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseCacheAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
