import 'package:hive_flutter/adapters.dart';

part 'document_type_enum.g.dart';

@HiveType(typeId: 6)
enum DocumentType {
  @HiveField(0)
  pdf,
  @HiveField(1)
  docx,
}

extension DocumentTypeExtensions on DocumentType {
  static DocumentType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pdf':
        return DocumentType.pdf;
      case 'docx':
        return DocumentType.docx;
      default:
        throw ArgumentError('Invalid document type: $value');
    }
  }

  String get toShortString => name.toUpperCase();
}
