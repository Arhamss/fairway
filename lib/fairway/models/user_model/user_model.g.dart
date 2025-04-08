// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      role: fields[4] as String,
      createdAt: fields[8] as DateTime,
      phone: fields[3] as String?,
      savedLocations: (fields[5] as List).cast<SavedLocation>(),
      passwordResetToken: fields[6] as String?,
      passwordResetExpires: fields[7] as DateTime?,
      subscriber: fields[9] as bool,
      subscriptionStart: fields[10] as DateTime?,
      subscriptionEnd: fields[11] as DateTime?,
      blacklistedTokens: (fields[12] as List).cast<String>(),
      notificationPreference: fields[13] as bool,
      signupType: fields[14] as String?,
      googleId: fields[15] as String?,
      appleId: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.role)
      ..writeByte(5)
      ..write(obj.savedLocations)
      ..writeByte(6)
      ..write(obj.passwordResetToken)
      ..writeByte(7)
      ..write(obj.passwordResetExpires)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.subscriber)
      ..writeByte(10)
      ..write(obj.subscriptionStart)
      ..writeByte(11)
      ..write(obj.subscriptionEnd)
      ..writeByte(12)
      ..write(obj.blacklistedTokens)
      ..writeByte(13)
      ..write(obj.notificationPreference)
      ..writeByte(14)
      ..write(obj.signupType)
      ..writeByte(15)
      ..write(obj.googleId)
      ..writeByte(16)
      ..write(obj.appleId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
