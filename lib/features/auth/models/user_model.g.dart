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
      id: fields[0] as int,
      username: fields[1] as String,
      firstName: fields[2] as String?,
      lastName: fields[3] as String?,
      email: fields[4] as String?,
      isSuperuser: fields[5] as bool,
      isStaff: fields[6] as bool,
      isActive: fields[7] as bool,
      dateJoined: fields[8] as DateTime,
      lastLogin: fields[9] as DateTime?,
      role: fields[10] as String,
      phoneNumber: fields[11] as String?,
      profilePicture: fields[12] as String?,
      organization: fields[13] as String?,
      station: fields[14] as String?,
      groups: (fields[15] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.isSuperuser)
      ..writeByte(6)
      ..write(obj.isStaff)
      ..writeByte(7)
      ..write(obj.isActive)
      ..writeByte(8)
      ..write(obj.dateJoined)
      ..writeByte(9)
      ..write(obj.lastLogin)
      ..writeByte(10)
      ..write(obj.role)
      ..writeByte(11)
      ..write(obj.phoneNumber)
      ..writeByte(12)
      ..write(obj.profilePicture)
      ..writeByte(13)
      ..write(obj.organization)
      ..writeByte(14)
      ..write(obj.station)
      ..writeByte(15)
      ..write(obj.groups);
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
