import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/hive/token.dart';
import 'package:rsc/storage/hive/worker/worker.dart';
import 'package:rsc/storage/secure/pin_code.dart';
import 'package:rsc/widgets/toast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userState = UserState.getInstance();
  final accountingState = AccountingState.getInstance();
  final pinCodeStorage = PinCodeStorage.getInstance();
  final tokenStorage = TokenStorage.getInstance();
  final storage = Storage.getInstance();
  final appToast = AppToast.getInstance();

  @override
  void initState() {
    super.initState();
    checkUserDataAndNavigate();
  }

  Future<void> checkUserDataAndNavigate() async {
    appToast.init(context);

    try {
      if (!userState.isInited) {
        await userState.initUserState();
      }
      User? user = userState.user;
      if (user != null) {
        bool hasSalaryInfo = user.salaryInfo != null;
        bool userEmailConfirmed = user.personalInfo.isEmailConfirmed;

        if (!userEmailConfirmed) {
          navigateToEmailConfirmForm();
          return;
        }

        if (!hasSalaryInfo) {
          navigateToSalaryInfoForm();
          return;
        }

        String? pinCode = await pinCodeStorage.getPinCode();

        if (pinCode != null) {
          navigateLocalAuth();
          accountingState.initState();
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
      appToast.showErrorToast(err.toString());
    }
  }

  void navigateToEmailConfirmForm() {
    Navigator.of(context).pushNamedAndRemoveUntil('/auth/register/confirm-email', (Route<dynamic> route) => false);
  }

  void navigateToSalaryInfoForm() {
    Navigator.of(context).pushNamedAndRemoveUntil('/auth/register/salary-info', (Route<dynamic> route) => false);
  }

  void navigateCreateLocalAuth() {
    Navigator.of(context).pushNamedAndRemoveUntil('/create_local_auth', (Route<dynamic> route) => false);
  }

  void navigateLocalAuth() {
    Navigator.of(context).pushNamedAndRemoveUntil('/local_auth', (Route<dynamic> route) => false);
  }

  void navigateToLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil('/auth', (Route<dynamic> route) => false);
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
