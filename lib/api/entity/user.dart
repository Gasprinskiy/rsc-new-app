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

  // Map<String, dynamic> get apiParams {
  //   return {
  //     'date_from': from,
  //     'date_to': to
  //   };
  // }
}

SignInResult signInResultFromJson(dynamic data) {
  UserPersonalInfo personalInfo = UserPersonalInfo(
    email: data['email'],
    name: data['user_name'],
    isEmailConfirmed: data['is_email_confirmed'],
  );

  SignInResult result = SignInResult(
    personalInfo: personalInfo,
  );

  if (data['salary_info'] != null) {
    result.salaryInfo = UserSalaryInfo(
        salary: data['salary_info']['info']['salary'].toDouble(),
        percentFromSales: data['salary_info']['info']['percent_from_sales'].toDouble(),
        plan: data['salary_info']['info']['plan'].toDouble(),
        ignorePlan: data['salary_info']['info']['ignore_plan']);

    if (data['salary_info']['percent_change_conditions'] != null) {
      List<UserPercentChangeConditions> percentChangeConditions = [];
      List<dynamic> responseChangeConditions =
          data['salary_info']['percent_change_conditions'];
      for (var element in responseChangeConditions) {
        UserPercentChangeConditions condition = UserPercentChangeConditions(
            percentGoal: element['percent_goal'].toDouble(),
            percentChange: element['percent_change'].toDouble(),
            salaryBonus: element['salary_bonus']?.toDouble());
        percentChangeConditions.add(condition);
      }
      result.percentChangeConditions = percentChangeConditions;
    }
  }

  return result;
}

class UpdateUserInfoParams extends SignInResult {
  UpdateUserInfoParams({
    required super.personalInfo,
    super.salaryInfo,
    super.percentChangeConditions,
  });
}

class CreateSalaryInfoPayload {
  UserSalaryInfo salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;

  CreateSalaryInfoPayload({
    required this.salaryInfo,
    this.percentChangeConditions,
  });

  Map<String, Object?> toJson() {
    List<Map> conditions = [];
    if (percentChangeConditions != null) {
      percentChangeConditions?.forEach((element) {
        Map condition = {
          'percent_goal': element.percentGoal,
          'percent_change': element.percentChange,
          'salary_bonus': element.salaryBonus
        };
        conditions.add(condition);
      });
    }

    return {
      'info': {
        'salary': salaryInfo.salary,
        'percent_from_sales': salaryInfo.percentFromSales,
        'plan': salaryInfo.plan,
        'ignore_plan': salaryInfo.ignorePlan,
      },
      'percent_change_conditions': conditions.isNotEmpty ? conditions : null,
    };
  }
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
  double percentChange;
  double? salaryBonus;

  UserPercentChangeConditions(
      {required this.percentGoal,
      required this.percentChange,
      this.salaryBonus});

  Map<String, double?> get apiParams {
    return {
      'percent_goal': percentGoal,
      'percent_change': percentChange,
      'salary_bonus': salaryBonus
    };
  }
}

UserPercentChangeConditions percentChangeConditionsFromJson(dynamic data) {
  return UserPercentChangeConditions(
    percentGoal: data['percent_goal'],
    percentChange: data['percent_change'],
    salaryBonus: data['salary_bonus']
  );
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

  Map<String, dynamic> get apiParams {
    return {
      'salary': salary,
      'percent_from_sales': percentFromSales,
      'ignore_plan': ignorePlan,
      'plan': plan
    };
  }
}

UserSalaryInfo userSalaryInfoFromJson(dynamic data) {
  return UserSalaryInfo(
    salary: data['salary'],
    percentFromSales: data['percent_from_sales'],
    ignorePlan: data['ignore_plan'],
    plan: data['plan']
  );
}

class ConfirmEmailResult {
  String accesToken;

  ConfirmEmailResult({required this.accesToken});
}
