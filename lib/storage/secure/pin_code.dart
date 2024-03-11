import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/secure/worker/worker.dart';

class PinCodeStorage {
  final _worker = SecureStorageWorker();

  Future<void> putPinCode(String pin) {
    return _worker.putString(AppStrings.pincodeStorageKey, pin);
  }

  Future<String?> getPinCode() {
    return _worker.getString(AppStrings.pincodeStorageKey);
  }
}
