// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiUserAdapter extends TypeAdapter<ApiUser> {
  @override
  final int typeId = 2;

  @override
  ApiUser read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiUser(
      email: fields[4] as String,
      firebaseUid: fields[7] as String,
      name: fields[3] as String,
      phoneNumber: fields[8] as String,
      photoUrl: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ApiUser obj) {
    writer
      ..writeByte(5)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.photoUrl)
      ..writeByte(7)
      ..write(obj.firebaseUid)
      ..writeByte(8)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiUserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
