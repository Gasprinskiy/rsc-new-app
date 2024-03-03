import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/tools/pincrypt.dart';
import 'package:test_flutter/utils/widgets/pin_code_screen.dart';

const androidAuthMessage = AndroidAuthMessages(
  signInTitle: AppStrings.authRequired,
  biometricRequiredTitle: '',
  cancelButton: AppStrings.cancel,
  biometricHint: '',
  biometricNotRecognized: '',
  biometricSuccess: '',
  goToSettingsDescription: '',
  goToSettingsButton: '',
  deviceCredentialsSetupDescription: '',
  deviceCredentialsRequiredTitle: '',
);

class LocalAuthRoute extends StatefulWidget {
  const LocalAuthRoute({super.key});

  @override
  State<LocalAuthRoute> createState() => _LocalAuthRouteState();
}

class _LocalAuthRouteState extends State<LocalAuthRoute> {
  final LocalAuthentication auth = LocalAuthentication();
  String _hashedPin = '';

  @override
  void initState() {
    super.initState();
    setHasedPin();
    _authenticateWithBiometrics();
  }

  @override
  void dispose() {
    auth.stopAuthentication();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        authMessages: [androidAuthMessage],
        localizedReason: 'Авторизуйтесь с помощью биометрических данных',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      print(e);
      return;
    } finally {
      if (authenticated) {
        navigateToHomePage();
      }
    }
    if (!mounted) {
      return;
    }
  }

  void setHasedPin() {
    getHasedPin().then((value) => {
          setState(() {
            _hashedPin = value ?? '';
          })
        });
  }

  Future<String?> getHasedPin() async {
    const secureStorage = FlutterSecureStorage();
    return secureStorage.read(key: AppStrings.pincodeStorageKey);
  }

  bool checkPinCode(List<String> pin) {
    return checkPin(pin.join(), _hashedPin);
  }

  void navigateToHomePage() {
    Navigator.pushNamed(context, '/main');
  }

  void onPinEnter(_) {
    navigateToHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return PinCodeWidget(
      padding: 20,
      title: AppStrings.typePinCode,
      submitText: AppStrings.proceed,
      validator: checkPinCode,
      onEnter: onPinEnter,
      onBiometricsClicked: _authenticateWithBiometrics,
    );
  }
}
