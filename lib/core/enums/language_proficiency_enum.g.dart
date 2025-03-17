// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_proficiency_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LanguageProficiencyAdapter extends TypeAdapter<LanguageProficiency> {
  @override
  final int typeId = 2;

  @override
  LanguageProficiency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LanguageProficiency.beginner;
      case 1:
        return LanguageProficiency.intermediate;
      case 2:
        return LanguageProficiency.advanced;
      case 3:
        return LanguageProficiency.none;
      default:
        return LanguageProficiency.beginner;
    }
  }

  @override
  void write(BinaryWriter writer, LanguageProficiency obj) {
    switch (obj) {
      case LanguageProficiency.beginner:
        writer.writeByte(0);
        break;
      case LanguageProficiency.intermediate:
        writer.writeByte(1);
        break;
      case LanguageProficiency.advanced:
        writer.writeByte(2);
        break;
      case LanguageProficiency.none:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguageProficiencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
