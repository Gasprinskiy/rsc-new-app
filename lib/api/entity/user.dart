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
  UserSalaryInfo? salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;

  SignInResult({
    required this.personalInfo,
    this.salaryInfo,
    this.percentChangeConditions,
  });
}

SignInResult signInResultFromJson(dynamic data) {
  UserPersonalInfo personalInfo = UserPersonalInfo(
    email: data['email'],
    name: data['user_name'],
    isEmailConfirmed: true,
  );

  SignInResult result = SignInResult(
    personalInfo: personalInfo,
  );

  if (data['salary_info'] != null) {
    result.salaryInfo = UserSalaryInfo(
        salary: data['salary_info']['salary'].toDouble(),
        percentFromSales: data['salary_info']['percent_from_sales'].toDouble(),
        plan: data['salary_info']['plan'].toDouble(),
        ignorePlan: data['salary_info']['ignore_plan']);

    if (data['salary_info']['percent_change_conditions']) {
      List<UserPercentChangeConditions> percentChangeConditions = [];
      List<dynamic> responseChangeConditions =
          data['salary_info']['percent_change_conditions'];
      for (var element in responseChangeConditions) {
        UserPercentChangeConditions condition = UserPercentChangeConditions(
            percentGoal: element.percent_goal.toDouble(),
            percentChange: element.percent_change.toDouble(),
            salaryBonus: element.salary_bonus.toDouble());
        percentChangeConditions.add(condition);
      }
      result.percentChangeConditions = percentChangeConditions;
    }
  }

  return result;
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

class ConfirmEmailResult {
  String accesToken;

  ConfirmEmailResult({required this.accesToken});
}
