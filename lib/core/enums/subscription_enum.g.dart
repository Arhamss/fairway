// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionTypeAdapter extends TypeAdapter<SubscriptionType> {
  @override
  final int typeId = 7;

  @override
  SubscriptionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionType.unlimitedCredits;
      case 1:
        return SubscriptionType.bammbuuGroups;
      case 2:
        return SubscriptionType.none;
      default:
        return SubscriptionType.unlimitedCredits;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionType obj) {
    switch (obj) {
      case SubscriptionType.unlimitedCredits:
        writer.writeByte(0);
        break;
      case SubscriptionType.bammbuuGroups:
        writer.writeByte(1);
        break;
      case SubscriptionType.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubscriptionStatusAdapter extends TypeAdapter<SubscriptionStatus> {
  @override
  final int typeId = 11;

  @override
  SubscriptionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SubscriptionStatus.active;
      case 1:
        return SubscriptionStatus.inactive;
      case 2:
        return SubscriptionStatus.none;
      default:
        return SubscriptionStatus.active;
    }
  }

  @override
  void write(BinaryWriter writer, SubscriptionStatus obj) {
    switch (obj) {
      case SubscriptionStatus.active:
        writer.writeByte(0);
        break;
      case SubscriptionStatus.inactive:
        writer.writeByte(1);
        break;
      case SubscriptionStatus.none:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
