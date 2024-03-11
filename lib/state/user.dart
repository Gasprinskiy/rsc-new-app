import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/storage/hive/user.dart';
import 'package:test_flutter/storage/hive/worker/adapters/user_adapter.dart';

class UserState {
  UserStorage userStorage = UserStorage();

  User? _userState;
  BiometricsSettings? _userBimetricsSettings;
  EmailConfirmation? _emailConfirmationInfo;
  bool _inited = false;

  UserState();

  Future<void> initUserState() async {
    _userState = await userStorage.getUserInfo();
    _inited = true;
  }

  Future<void> initUserStateFromSignInResult(SignInResult payload) async {
    // put user data into storage
    PersonalInfo personalInfo = PersonalInfo(
        name: payload.personalInfo.name,
        email: payload.personalInfo.email,
        isEmailConfirmed: payload.personalInfo.isEmailConfirmed,
        isEmailConfirmSciped: false);

    User user = User(
      personalInfo: personalInfo,
    );

    if (payload.salaryInfo != null) {
      user.salaryInfo = SalaryInfo(
          salary: payload.salaryInfo!.salary,
          percentFromSales: payload.salaryInfo!.percentFromSales,
          plan: payload.salaryInfo!.plan,
          ignorePlan: payload.salaryInfo!.ignorePlan);
    }

    if (payload.percentChangeConditions != null) {
      user.percentChangeConditions = [];
      for (var element in payload.percentChangeConditions!) {
        user.percentChangeConditions!.add(PercentChangeConditions(
            percentGoal: element.percentGoal,
            percentChange: element.percentChange,
            salaryBonus: element.salaryBonus));
      }
    }

    try {
      await userStorage.putUserInfo(user);
    } on HiveError catch (err) {
      throw err.message;
    }
    //

    _userState = user;
    _inited = true;
  }

  Future<void> updateUserState(User? state) async {
    //
    _userState = state;
    //
    if (_userState != null) {
      await userStorage.putUserInfo(_userState!);
    }
  }

  Future<void> removeUserState() async {
    await userStorage.removeUserInfo();
    //
    _userState = null;
    _inited = false;
  }

  Future<void> setBiometricsSettings(BiometricsSettings settings) async {
    await userStorage.setBiometricsSettings(settings);
    //
    _userBimetricsSettings = settings;
  }

  Future<void> setEmailConfirmationInfo(EmailConfirmation info) async {
    await userStorage.setEmailConfirmation(info);
    //
    _emailConfirmationInfo = info;
  }

  Future<void> removeEmailConfirmationInfo() {
    return userStorage.removeEmailConfirmation();
  }

  User? getUserInstanse() {
    if (_userState != null) {
      return User(
          personalInfo: _userState!.personalInfo,
          salaryInfo: _userState?.salaryInfo,
          percentChangeConditions: _userState?.percentChangeConditions);
    }
    return null;
  }

  User? get user => _userState;
  EmailConfirmation? get verificationInfo => _emailConfirmationInfo;
  bool get isInited => _inited;
  bool get isNotEmpty => _userState != null;
  bool get biometricsAllowed => _userBimetricsSettings?.allowed ?? false;
}
