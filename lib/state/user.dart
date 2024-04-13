import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rsc/api/entity/user.dart';
import 'package:rsc/api/user.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/synchronization_data.dart';
import 'package:rsc/storage/hive/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/hive/worker/worker.dart';
import 'package:rsc/storage/secure/worker/worker.dart';
import 'package:rsc/utils/event_bus.dart';
import 'package:rsc/widgets/toast.dart';

class UserState {
  static UserState? _instance;
  final userStorage = UserStorage.getInstance();
  final syncStorage = SynchronizationDataStorage.getInstance();
  final userApi = UserApi.getInstance();
  final appToast = AppToast.getInstance();
  final appBus = AppEventBus.getInstance();

  User? _userState;
  BiometricsSettings? _userBimetricsSettings;
  EmailConfirmation? _emailConfirmationInfo;
  bool _inited = false;

  UserState._();

  static UserState getInstance() {
    _instance ??= UserState._();
    return _instance!;
  }

  Future<void> initUserState() async {
    _userState = await userStorage.getUserInfo();
    await setBiometricsSettingsFromStorage();
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

  Future<void> setAndSyncSalaryInfo(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions) async {
    _userState?.salaryInfo = salaryInfo;
    _userState?.percentChangeConditions = conditions;

    if (_userState != null) {
      await userStorage.putUserInfo(_userState!);
      await userApi.createSalaryInfo(CreateSalaryInfoPayload(
        salaryInfo: UserSalaryInfo(
          salary: salaryInfo.salary,
          percentFromSales: salaryInfo.percentFromSales,
          plan: salaryInfo.plan,
          ignorePlan: salaryInfo.ignorePlan
        ),
        percentChangeConditions: conditions?.map((item) {
          return UserPercentChangeConditions(
            percentGoal: item.percentGoal, 
            percentChange: item.percentChange,
            salaryBonus: item.salaryBonus
          );
        }).toList()
      ));
    }
  }

  Future<void> syncSalaryInfoData(UpdatedSalaryInfo payload) async {
    try {
      await userApi.updateUserSalaryInfo(UpdateUserSalaryInfoParams(
        salaryInfo: UserSalaryInfo(
          salary: payload.salaryInfo.salary,
          percentFromSales: payload.salaryInfo.percentFromSales,
          plan: payload.salaryInfo.plan,
          ignorePlan: payload.salaryInfo.ignorePlan,
        ),
        percentChangeConditions: payload.percentChangeConditions?.map((item) {
          return UserPercentChangeConditions(
            percentGoal: item.percentGoal, 
            percentChange: item.percentChange,
            salaryBonus: item.salaryBonus
          );
        }).toList()
      ));
    } on DioException catch(err) {
      appToast.showCustomToast(
        AppColors.error,
        Icons.cloud_off_rounded,
        '${AppStrings.couldNotSyncUserData}: ${err.message}'
      );
      appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
    }
  }

  Future<void> updateSalaryInfo(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions) async {
    _userState?.salaryInfo = salaryInfo;
    _userState?.percentChangeConditions = conditions;

    if (_userState != null) {
      bool hasConnection = await InternetConnectionChecker().hasConnection;
      try {
        await userStorage.putUserInfo(_userState!);
        if (hasConnection) {
          await userApi.updateUserSalaryInfo(UpdateUserSalaryInfoParams(
            salaryInfo: UserSalaryInfo(
              salary: salaryInfo.salary,
              percentFromSales: salaryInfo.percentFromSales,
              plan: salaryInfo.plan,
              ignorePlan: salaryInfo.ignorePlan,
            ),
            percentChangeConditions: conditions?.map((item) {
              return UserPercentChangeConditions(
                percentGoal: item.percentGoal, 
                percentChange: item.percentChange,
                salaryBonus: item.salaryBonus
              );
            }).toList()
          ));

          appToast.showCustomToast(
            AppColors.success,
            Icons.cloud_done_rounded,
            AppStrings.dataUpdatedAndSyncronized
          );
        } else {
          SynchronizationData syncPayload = SynchronizationData(
            type: SynchronizationDataType.salaryinfo,
            data: UpdatedSalaryInfo(
              salaryInfo: salaryInfo,
              percentChangeConditions: conditions
            )
          );
          await syncStorage.addSynchronizationData(syncPayload);
          appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
          appToast.showCustomToast(
            AppColors.warn,
            Icons.cloud_off_rounded,
            '${AppStrings.couldNotSyncData}: ${AppStrings.noInternetConnection}'
          );
        }
      } on DioException catch (err) {
        SynchronizationData syncPayload = SynchronizationData(
          type: SynchronizationDataType.salaryinfo,
          data: UpdatedSalaryInfo(
            salaryInfo: salaryInfo,
            percentChangeConditions: conditions
          )
        );
        await syncStorage.addSynchronizationData(syncPayload);
        appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
        appToast.showCustomToast(
          AppColors.warn,
          Icons.cloud_off_rounded,
          '${AppStrings.couldNotSyncData}: ${err.message}'
        );
      }
    }
  }

  Future<void> setBiometricsSettings(BiometricsSettings settings) async {
    await userStorage.setBiometricsSettings(settings);
    //
    _userBimetricsSettings = settings;
  }

  Future<void> setBiometricsSettingsFromStorage() async {
    _userBimetricsSettings = await userStorage.getBiometricsSettings();
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

  Future<void> updateUserInfo(User user) async {
    await updateUserState(user);
    // await userApi.
  }

  Future<void> logout() async {
    final storage = Storage.getInstance();
    final secureStorage = SecureStorageWorker.getInstanse();

    await storage.removeAllData();
    await secureStorage.removeAll();
    _userState = null;
    _userBimetricsSettings = null;
    _emailConfirmationInfo = null;
    _inited = false;
    return;
  }

  User? get user {
    if (_userState != null) {
      return User(
        personalInfo: _userState!.personalInfo,
        salaryInfo: _userState!.salaryInfo,
        percentChangeConditions: _userState!.percentChangeConditions?.map((element) {
          return PercentChangeConditions(
            percentGoal: element.percentGoal, 
            percentChange: element.percentChange,
            salaryBonus: element.salaryBonus
          );
        }).toList()
      );
    }
    return null;
  }
  EmailConfirmation? get verificationInfo => _emailConfirmationInfo;
  bool get isInited => _inited;
  bool get isNotEmpty => _userState != null;
  bool get biometricsAllowed => _userBimetricsSettings?.allowed ?? false;
}