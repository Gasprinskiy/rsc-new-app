import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'adapters.g.dart';

Uuid uid = const Uuid();

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  PersonalInfo personalInfo;
  @HiveField(1)
  SalaryInfo? salaryInfo;
  @HiveField(2)
  List<PercentChangeConditions>? percentChangeConditions;

  User(
      {required this.personalInfo,
      this.salaryInfo,
      this.percentChangeConditions});
}

@HiveType(typeId: 1)
class PersonalInfo extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  bool isEmailConfirmed;
  @HiveField(3)
  bool isEmailConfirmSciped;

  PersonalInfo(
      {required this.name,
      required this.email,
      required this.isEmailConfirmed,
      required this.isEmailConfirmSciped});
}

@HiveType(typeId: 2)
class SalaryInfo extends HiveObject {
  @HiveField(0)
  double salary;
  @HiveField(1)
  double percentFromSales;
  @HiveField(2)
  double? plan;
  @HiveField(3)
  bool? ignorePlan;

  SalaryInfo(
      {required this.salary,
      required this.percentFromSales,
      this.plan,
      this.ignorePlan});
}

@HiveType(typeId: 3)
class PercentChangeConditions extends HiveObject {
  @HiveField(0)
  double percentGoal;
  @HiveField(1)
  double percentChange;
  @HiveField(2)
  double? salaryBonus;

  PercentChangeConditions(
      {required this.percentGoal,
      required this.percentChange,
      this.salaryBonus});
}

@HiveType(typeId: 4)
class EmailConfirmation extends HiveObject {
  @HiveField(0)
  int userId;
  @HiveField(1)
  DateTime date;

  EmailConfirmation({required this.userId, required this.date});
}

@HiveType(typeId: 5)
class BiometricsSettings {
  @HiveField(0)
  bool allowed;

  BiometricsSettings({required this.allowed});
}

@HiveType(typeId: 6)
class CurrentReport extends HiveObject {
  @HiveField(0)
  int? cloudId;
  @HiveField(1)
  DateTime creationDate;

  CurrentReport({this.cloudId, required this.creationDate});
}

@HiveType(typeId: 7)
class Sale extends HiveObject {
  @HiveField(0)
  final String id = uid.v1();
  @HiveField(1)
  double total;
  @HiveField(2)
  double nonCash;
  @HiveField(3)
  double cashTaxes;
  @HiveField(4)
  DateTime creationDate;
  @HiveField(5)
  int? cloudId;

  Sale(
      {required this.total,
      required this.nonCash,
      required this.cashTaxes,
      required this.creationDate,
      this.cloudId});
}

@HiveType(typeId: 8)
class Tip extends HiveObject {
  @HiveField(0)
  final String id = uid.v1();
  @HiveField(1)
  double value;
  @HiveField(2)
  DateTime creationDate;
  @HiveField(5)
  int? cloudId;

  Tip({required this.value, required this.creationDate, this.cloudId});
}

@HiveType(typeId: 9)
class Prepayment extends HiveObject {
  @HiveField(0)
  final String id = uid.v1();
  @HiveField(1)
  double value;
  @HiveField(2)
  DateTime creationDate;
  @HiveField(5)
  int? cloudId;

  Prepayment({required this.value, required this.creationDate, this.cloudId});
}

@HiveType(typeId: 10)
class CurrentReportInfo extends HiveObject {
  @HiveField(0)
  List<Sale>? sales;
  @HiveField(1)
  List<Tip>? tips;
  @HiveField(2)
  List<Prepayment>? prepayments;

  CurrentReportInfo({this.sales, this.tips, this.prepayments});
}

@HiveType(typeId: 11)
enum SynchronizationDataType {
  @HiveField(0)
  sale,
  @HiveField(1) 
  tip, 
  @HiveField(2)
  prepayment,
  @HiveField(3)
  salaryinfo,
  @HiveField(4)
  percentchangeconditions
}

@HiveType(typeId: 12)
class SynchronizationData extends HiveObject {
  @HiveField(0)
  final String id = uid.v1();
  @HiveField(1)
  SynchronizationDataType type;
  @HiveField(2)
  dynamic data;

  SynchronizationData({required this.type, required this.data});
}



@HiveType(typeId: 13)
class SaleList extends HiveObject {
  @HiveField(0)
  List<Sale> data;

  SaleList({required this.data});
}

@HiveType(typeId: 14)
class SynchronizationDataList extends HiveObject {
  @HiveField(0)
  List<SynchronizationData> data;
  
  SynchronizationDataList({required this.data});
}

@HiveType(typeId: 15)
class TipList extends HiveObject {
  @HiveField(0)
  List<Tip> data;

  TipList({required this.data});
}

@HiveType(typeId: 16)
class PrepaymentList extends HiveObject {
  @HiveField(0)
  List<Prepayment> data;

  PrepaymentList({required this.data});
}