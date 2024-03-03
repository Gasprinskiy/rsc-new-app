import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/user.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';
import 'package:test_flutter/tools/pincrypt.dart';
import 'package:test_flutter/utils/widgets/pin_code_screen.dart';

class CreateLocalAuthRoute extends StatefulWidget {
  const CreateLocalAuthRoute({super.key});

  @override
  State<CreateLocalAuthRoute> createState() => _CreateLocalAuthRouteState();
}

class _CreateLocalAuthRouteState extends State<CreateLocalAuthRoute> {
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

  Future<void> savePinCode(List<String> enteredPin) async {
    String pinCode = createPin(enteredPin.join());

    const secureStorage = FlutterSecureStorage();

    await secureStorage.write(
        key: AppStrings.pincodeStorageKey, value: pinCode);
  }

  Future<void> setAllowedBiometricsSettings() async {
    // open storage
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
    Storage appStorage = Storage(storageInstance: box);
    UserStorage userStorage = UserStorage(storage: appStorage);
    //

    await userStorage.setBiometricsSettings(BiometricsSettings(allowed: true));
    navigateToHomePage();
  }

  Future<void> onPinEnter(List<String> pin) async {
    await savePinCode(pin);
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
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(AppStrings.no)),
              TextButton(
                  onPressed: () => {
                        setAllowedBiometricsSettings(),
                      },
                  child: const Text(AppStrings.yes))
            ],
          );
        });
  }

  void navigateToHomePage() {
    Navigator.pushNamed(context, '/main');
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
