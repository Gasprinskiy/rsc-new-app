import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/secure/worker/worker.dart';

class PinCodeStorage {
  final _worker = SecureStorageWorker.getInstanse();
  static PinCodeStorage? _instance;

  PinCodeStorage._();

  static PinCodeStorage getInstance() {
    _instance ??= PinCodeStorage._();
    return _instance!;
  }

  Future<void> putPinCode(String pin) {
    return _worker.putString(AppStrings.pincodeStorageKey, pin);
  }

  Future<String?> getPinCode() {
    return _worker.getString(AppStrings.pincodeStorageKey);
  }
}
