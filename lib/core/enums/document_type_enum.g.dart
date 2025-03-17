// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_type_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DocumentTypeAdapter extends TypeAdapter<DocumentType> {
  @override
  final int typeId = 6;

  @override
  DocumentType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DocumentType.pdf;
      case 1:
        return DocumentType.docx;
      default:
        return DocumentType.pdf;
    }
  }

  @override
  void write(BinaryWriter writer, DocumentType obj) {
    switch (obj) {
      case DocumentType.pdf:
        writer.writeByte(0);
        break;
      case DocumentType.docx:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DocumentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
