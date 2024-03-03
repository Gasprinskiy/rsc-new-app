import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';

class UserStorage {
  final Storage storage;

  UserStorage({required this.storage});

  Future<void> putUserInfo(User payload) {
    return storage.put(AppStrings.userStorageKey, payload);
  }

  Future<User?> getUserInfo() {
    return storage.get(AppStrings.userStorageKey);
  }

  Future<void> removeUserInfo() {
    return storage.remove(AppStrings.userStorageKey);
  }

  Future<EmailConfirmation?> getEmailConfirmationData() {
    return storage.get(AppStrings.confirmationDateStore);
  }

  Future<void> setEmailConfirmation(EmailConfirmation payload) {
    return storage.put(AppStrings.confirmationDateStore, payload);
  }

  Future<void> removeEmailConfirmation(EmailConfirmation payload) {
    return storage.remove(AppStrings.confirmationDateStore);
  }

  Future<void> setBiometricsSettings(BiometricsSettings payload) {
    return storage.put(AppStrings.biometricsSettingsStoreKey, payload);
  }

  Future<void> getBiometricsSettings() {
    return storage.get(AppStrings.biometricsSettingsStoreKey);
  }
}
