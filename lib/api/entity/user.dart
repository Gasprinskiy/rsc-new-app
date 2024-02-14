class SignUpParams {
  String name;
  String email;
  String? password;

  SignUpParams({required this.name, required this.email, this.password});
}

class SignInParams {
  String email;
  String password;

  SignInParams({required this.email, required this.password});
}

class SignUpResult {
  int userId;
  DateTime date;

  SignUpResult({required this.userId, required this.date});
}

class SignInResult {
  UserPersonalInfo personalInfo;
  UserSalaryInfo salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;
  String accesToken;

  SignInResult(
      {required this.personalInfo,
      required this.salaryInfo,
      this.percentChangeConditions,
      required this.accesToken});
}

SignInResult signInResultFromJson(dynamic data) {
  List<dynamic>? responseChangeConditions =
      data['salary_info']['percent_change_conditions'];

  UserPersonalInfo personalInfo = UserPersonalInfo(
    email: data['email'],
    name: data['user_name'],
    isEmailConfirmed: true,
  );

  UserSalaryInfo salaryInfo = UserSalaryInfo(
      salary: data['salary_info']['salary'].toDouble(),
      percentFromSales: data['salary_info']['percent_from_sales'].toDouble(),
      plan: data['salary_info']['plan'].toDouble(),
      ignorePlan: data['salary_info']['ignore_plan']);

  List<UserPercentChangeConditions> percentChangeConditions = [];
  if (responseChangeConditions != null) {
    for (var element in responseChangeConditions) {
      UserPercentChangeConditions condition = UserPercentChangeConditions(
          percentGoal: element.percent_goal.toDouble(),
          percentChange: element.percent_change.toDouble(),
          salaryBonus: element.salary_bonus.toDouble());
      percentChangeConditions.add(condition);
    }
  }

  return SignInResult(
      personalInfo: personalInfo,
      salaryInfo: salaryInfo,
      percentChangeConditions: percentChangeConditions,
      accesToken: data['access_token']);
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

class UserPercentChangeConditions {
  double percentGoal;
  double? percentChange;
  double salaryBonus;

  UserPercentChangeConditions(
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
