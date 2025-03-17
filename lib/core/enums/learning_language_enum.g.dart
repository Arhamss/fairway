// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_language_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LearningLanguageEnumAdapter extends TypeAdapter<LearningLanguageEnum> {
  @override
  final int typeId = 1;

  @override
  LearningLanguageEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LearningLanguageEnum.english;
      case 1:
        return LearningLanguageEnum.spanish;
      case 2:
        return LearningLanguageEnum.englishSpanish;
      case 3:
        return LearningLanguageEnum.none;
      default:
        return LearningLanguageEnum.english;
    }
  }

  @override
  void write(BinaryWriter writer, LearningLanguageEnum obj) {
    switch (obj) {
      case LearningLanguageEnum.english:
        writer.writeByte(0);
        break;
      case LearningLanguageEnum.spanish:
        writer.writeByte(1);
        break;
      case LearningLanguageEnum.englishSpanish:
        writer.writeByte(2);
        break;
      case LearningLanguageEnum.none:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LearningLanguageEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
