// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_location_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedLocationAdapter extends TypeAdapter<SavedLocation> {
  @override
  final int typeId = 2;

  @override
  SavedLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedLocation(
      airportName: fields[0] as String,
      airportCode: fields[1] as String,
      terminal: fields[2] as String,
      gate: fields[3] as String,
      isCurrent: fields[4] as bool,
      addedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedLocation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.airportName)
      ..writeByte(1)
      ..write(obj.airportCode)
      ..writeByte(2)
      ..write(obj.terminal)
      ..writeByte(3)
      ..write(obj.gate)
      ..writeByte(4)
      ..write(obj.isCurrent)
      ..writeByte(5)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
