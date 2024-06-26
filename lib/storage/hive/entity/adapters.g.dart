// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adapters.dart';

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
      percentChange: fields[1] as double,
      salaryBonus: fields[2] as double?,
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

class BiometricsSettingsAdapter extends TypeAdapter<BiometricsSettings> {
  @override
  final int typeId = 5;

  @override
  BiometricsSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BiometricsSettings(
      allowed: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BiometricsSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.allowed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiometricsSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentReportAdapter extends TypeAdapter<CurrentReport> {
  @override
  final int typeId = 6;

  @override
  CurrentReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentReport(
      cloudId: fields[0] as int?,
      creationDate: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CurrentReport obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cloudId)
      ..writeByte(1)
      ..write(obj.creationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleAdapter extends TypeAdapter<Sale> {
  @override
  final int typeId = 7;

  @override
  Sale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sale(
      total: fields[1] as double,
      nonCash: fields[2] as double,
      cashTaxes: fields[3] as double,
      creationDate: fields[4] as DateTime,
      cloudId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Sale obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.total)
      ..writeByte(2)
      ..write(obj.nonCash)
      ..writeByte(3)
      ..write(obj.cashTaxes)
      ..writeByte(4)
      ..write(obj.creationDate)
      ..writeByte(5)
      ..write(obj.cloudId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipAdapter extends TypeAdapter<Tip> {
  @override
  final int typeId = 8;

  @override
  Tip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tip(
      value: fields[1] as double,
      creationDate: fields[2] as DateTime,
      cloudId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Tip obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(5)
      ..write(obj.cloudId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrepaymentAdapter extends TypeAdapter<Prepayment> {
  @override
  final int typeId = 9;

  @override
  Prepayment read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prepayment(
      value: fields[1] as double,
      creationDate: fields[2] as DateTime,
      cloudId: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Prepayment obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.value)
      ..writeByte(2)
      ..write(obj.creationDate)
      ..writeByte(5)
      ..write(obj.cloudId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepaymentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CurrentReportInfoAdapter extends TypeAdapter<CurrentReportInfo> {
  @override
  final int typeId = 10;

  @override
  CurrentReportInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentReportInfo(
      sales: (fields[0] as List?)?.cast<Sale>(),
      tips: (fields[1] as List?)?.cast<Tip>(),
      prepayments: (fields[2] as List?)?.cast<Prepayment>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentReportInfo obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.sales)
      ..writeByte(1)
      ..write(obj.tips)
      ..writeByte(2)
      ..write(obj.prepayments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentReportInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SynchronizationDataAdapter extends TypeAdapter<SynchronizationData> {
  @override
  final int typeId = 12;

  @override
  SynchronizationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SynchronizationData(
      type: fields[1] as SynchronizationDataType,
      data: fields[2] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, SynchronizationData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynchronizationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SaleListAdapter extends TypeAdapter<SaleList> {
  @override
  final int typeId = 13;

  @override
  SaleList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleList(
      data: (fields[0] as List).cast<Sale>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaleList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SynchronizationDataListAdapter
    extends TypeAdapter<SynchronizationDataList> {
  @override
  final int typeId = 14;

  @override
  SynchronizationDataList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SynchronizationDataList(
      data: (fields[0] as List).cast<SynchronizationData>(),
    );
  }

  @override
  void write(BinaryWriter writer, SynchronizationDataList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynchronizationDataListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TipListAdapter extends TypeAdapter<TipList> {
  @override
  final int typeId = 15;

  @override
  TipList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TipList(
      data: (fields[0] as List).cast<Tip>(),
    );
  }

  @override
  void write(BinaryWriter writer, TipList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TipListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PrepaymentListAdapter extends TypeAdapter<PrepaymentList> {
  @override
  final int typeId = 16;

  @override
  PrepaymentList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrepaymentList(
      data: (fields[0] as List).cast<Prepayment>(),
    );
  }

  @override
  void write(BinaryWriter writer, PrepaymentList obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrepaymentListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ArchivateReportAdapter extends TypeAdapter<ArchivateReport> {
  @override
  final int typeId = 17;

  @override
  ArchivateReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArchivateReport(
      reportId: fields[0] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ArchivateReport obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.reportId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArchivateReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UpdatedSalaryInfoAdapter extends TypeAdapter<UpdatedSalaryInfo> {
  @override
  final int typeId = 18;

  @override
  UpdatedSalaryInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UpdatedSalaryInfo(
      salaryInfo: fields[0] as SalaryInfo,
    );
  }

  @override
  void write(BinaryWriter writer, UpdatedSalaryInfo obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.salaryInfo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdatedSalaryInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SynchronizationDataTypeAdapter
    extends TypeAdapter<SynchronizationDataType> {
  @override
  final int typeId = 11;

  @override
  SynchronizationDataType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SynchronizationDataType.report;
      case 1:
        return SynchronizationDataType.sale;
      case 2:
        return SynchronizationDataType.tip;
      case 3:
        return SynchronizationDataType.prepayment;
      case 4:
        return SynchronizationDataType.salaryinfo;
      case 5:
        return SynchronizationDataType.percentchangeconditions;
      default:
        return SynchronizationDataType.report;
    }
  }

  @override
  void write(BinaryWriter writer, SynchronizationDataType obj) {
    switch (obj) {
      case SynchronizationDataType.report:
        writer.writeByte(0);
        break;
      case SynchronizationDataType.sale:
        writer.writeByte(1);
        break;
      case SynchronizationDataType.tip:
        writer.writeByte(2);
        break;
      case SynchronizationDataType.prepayment:
        writer.writeByte(3);
        break;
      case SynchronizationDataType.salaryinfo:
        writer.writeByte(4);
        break;
      case SynchronizationDataType.percentchangeconditions:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SynchronizationDataTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
