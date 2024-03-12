import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/storage/hive/worker/adapters/adapters.dart';
import 'package:test_flutter/storage/secure/pin_code.dart';

class SplashScreen extends StatefulWidget {
  final UserState userState;
  const SplashScreen({super.key, required this.userState});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late UserState userState;
  final PinCodeStorage pinCodeStorage = PinCodeStorage();

  @override
  void initState() {
    super.initState();
    userState = widget.userState;
    checkUserDataAndNavigate();
  }

  Future<void> checkUserDataAndNavigate() async {
    // Navigator.pushNamed(context, '/auth/register/confirm-email');
    // return;
    try {
      //
      // await userState.removeUserState(); // remove
      //
      if (!userState.isInited) {
        await userState.initUserState();
      }
      User? user = userState.user;
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

        // const secureStorage = FlutterSecureStorage(); // remove
        // await secureStorage.deleteAll(); // remove
        String? pinCode = await pinCodeStorage.getPinCode();

        if (pinCode != null) {
          navigateLocalAuth();
          return;
        }
        if (pinCode == null) {
          navigateCreateLocalAuth();
          return;
        }

        navigateLocalAuth();
      } else {
        navigateToLogin();
      }
    } catch (err) {
      print('err: $err');
    }
  }

  void navigateToEmailConfirmForm() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/register/confirm-email', (Route<dynamic> route) => false);
  }

  void navigateToSalaryInfoForm() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/register/salary-info', (Route<dynamic> route) => false);
  }

  void navigateCreateLocalAuth() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/create_local_auth', (Route<dynamic> route) => false);
  }

  void navigateLocalAuth() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/local_auth', (Route<dynamic> route) => false);
  }

  void navigateToLogin() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
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
