// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_adapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      personalInfo: fields[0] as PersonalInfo,
      salaryInfo: fields[1] as SalaryInfo?,
      percentChangeConditions:
          (fields[2] as List?)?.cast<PercentChangeConditions>(),
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.personalInfo)
      ..writeByte(1)
      ..write(obj.salaryInfo)
      ..writeByte(2)
      ..write(obj.percentChangeConditions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonalInfoAdapter extends TypeAdapter<PersonalInfo> {
  @override
  final int typeId = 1;

  @override
  PersonalInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PersonalInfo(
      name: fields[0] as String,
      email: fields[1] as String,
      isEmailConfirmed: fields[2] as bool,
      isEmailConfirmSciped: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PersonalInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.isEmailConfirmed)
      ..writeByte(3)
      ..write(obj.isEmailConfirmSciped);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonalInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SalaryInfoAdapter extends TypeAdapter<SalaryInfo> {
  @override
  final int typeId = 2;

  @override
  SalaryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalaryInfo(
      salary: fields[0] as double,
      percentFromSales: fields[1] as double,
      plan: fields[2] as double?,
      ignorePlan: fields[3] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, SalaryInfo obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.salary)
      ..writeByte(1)
      ..write(obj.percentFromSales)
      ..writeByte(2)
      ..write(obj.plan)
      ..writeByte(3)
      ..write(obj.ignorePlan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalaryInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PercentChangeConditionsAdapter
    extends TypeAdapter<PercentChangeConditions> {
  @override
  final int typeId = 3;

  @override
  PercentChangeConditions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PercentChangeConditions(
      percentGoal: fields[0] as double,
      percentChange: fields[1] as double?,
      salaryBonus: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, PercentChangeConditions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.percentGoal)
      ..writeByte(1)
      ..write(obj.percentChange)
      ..writeByte(2)
      ..write(obj.salaryBonus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PercentChangeConditionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmailConfirmationAdapter extends TypeAdapter<EmailConfirmation> {
  @override
  final int typeId = 4;

  @override
  EmailConfirmation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EmailConfirmation(
      userId: fields[0] as int,
      date: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, EmailConfirmation obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailConfirmationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
