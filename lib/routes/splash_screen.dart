import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/user.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkUserDataAndNavigate();
  }

  Future<void> checkUserDataAndNavigate() async {
    // Navigator.pushNamed(context, '/auth/register/confirm-email');
    // return;

    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);

    Storage appStorage = Storage(storageInstance: box);
    UserStorage userStorage = UserStorage(storage: appStorage);

    try {
      // await userStorage.removeUserInfo();
      User? user = await userStorage.getUserInfo();
      if (user != null) {
        bool hasSalaryInfo = user.salaryInfo != null;
        bool userEmailConfirmed = user.personalInfo.isEmailConfirmed;
        bool userScipedEmailConfirm = user.personalInfo.isEmailConfirmSciped;

        if (!userEmailConfirmed && !userScipedEmailConfirm) {
          navigateToEmailConfirmForm();
          return;
        }

        if (!hasSalaryInfo) {
          navigateToSalaryInfoForm();
          return;
        }

        navigateToHome();
      } else {
        navigateToLogin();
      }
    } catch (err) {
      print('err: $err');
    }
  }

  void navigateToEmailConfirmForm() {
    Navigator.pushNamed(context, '/auth/register/confirm-email');
  }

  void navigateToSalaryInfoForm() {
    Navigator.pushNamed(context, '/auth/register/salary-info');
  }

  void navigateToHome() {
    Navigator.pushNamed(context, '/main');
  }

  void navigateToLogin() {
    Navigator.pushNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
      ),
    );
  }
}
