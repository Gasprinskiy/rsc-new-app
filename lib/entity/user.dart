class UserCommonInfo {
  UserPersonalInfo personalInfo;
  UserSalaryInfo salaryInfo;
  List<PercentChangeConditions>? percentChangeConditions;

  UserCommonInfo(
      {required this.personalInfo,
      required this.salaryInfo,
      this.percentChangeConditions});
}

class UserPersonalInfo {
  String name;
  String email;
  bool isEmailConfirmed;

  UserPersonalInfo({
    required this.name,
    required this.email,
    required this.isEmailConfirmed,
  });
}

class PercentChangeConditions {
  double percentGoal;
  double? percentChange;
  double salaryBonus;

  PercentChangeConditions(
      {required this.percentGoal,
      this.percentChange,
      required this.salaryBonus});
}

class UserSalaryInfo {
  double salary;
  double percentFromSales;
  double? plan;
  bool? ignorePlan;

  UserSalaryInfo(
      {required this.salary,
      required this.percentFromSales,
      this.plan,
      this.ignorePlan});
}
