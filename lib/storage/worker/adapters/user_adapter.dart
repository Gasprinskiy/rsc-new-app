import 'package:hive/hive.dart';

part 'user_adapter.g.dart';

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
class SalaryInfo {
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
class PercentChangeConditions {
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
class EmailConfirmation {
  @HiveField(0)
  int userId;
  @HiveField(1)
  DateTime date;

  EmailConfirmation({required this.userId, required this.date});
}
