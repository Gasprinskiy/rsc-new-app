import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/secure/pin_code.dart';
import 'package:rsc/tools/pincrypt.dart';
import 'package:rsc/views/local_auth/widgets/pin_code_screen.dart';

class CreateLocalAuthRoute extends StatefulWidget {
  
  const CreateLocalAuthRoute({super.key});

  @override
  State<CreateLocalAuthRoute> createState() => _CreateLocalAuthRouteState();
}

class _CreateLocalAuthRouteState extends State<CreateLocalAuthRoute> {
  final userState = UserState.getInstance();
  final PinCodeStorage pinCodeStorage = PinCodeStorage.getInstance();
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> checkDeviceFingerprintAuth() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    if (availableBiometrics.contains(BiometricType.strong) && canAuthenticate) {
      return true;
    }
    return false;
  }

  Future<void> onPinEnter(List<String> pin) async {
    String hashedPin = createPin(pin.join());
    await pinCodeStorage.putPinCode(hashedPin);

    bool isBimetricsAllowed = await checkDeviceFingerprintAuth();
    if (isBimetricsAllowed) {
      showAllowBiometricsDialog();
    }
  }

  void showAllowBiometricsDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              AppStrings.useBiometricsForAuthification,
              style: TextStyle(fontSize: 18),
            ),
            content: const Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(height: 20),
              Icon(Icons.fingerprint, size: 50)
            ]),
            actions: [
              TextButton(
                  onPressed: () =>
                      setBiometricsSettingsAndNaviageteToHomePage(false),
                  child: const Text(AppStrings.no)),
              TextButton(
                  onPressed: () =>
                      setBiometricsSettingsAndNaviageteToHomePage(true),
                  child: const Text(AppStrings.yes))
            ],
          );
        });
  }

  Future<void> setBiometricsSettingsAndNaviageteToHomePage(bool allowed) async {
    await userState.setBiometricsSettings(BiometricsSettings(allowed: allowed));
    navigateToHomePage();
  }

  void navigateToHomePage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeWidget(
      padding: 20,
      title: AppStrings.createPinCode,
      submitText: AppStrings.proceed,
      onEnter: onPinEnter,
    );
  }
}
