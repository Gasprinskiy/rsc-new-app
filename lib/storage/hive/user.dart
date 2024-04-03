import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/hive/worker/worker.dart';

class UserStorage {
  static UserStorage? _instanse;
  final _storage = Storage.getInstance();

  UserStorage._();

  static UserStorage getInstance() {
    _instanse ??= UserStorage._();
    return _instanse!;
  }

  Future<void> putUserInfo(User payload) {
    return _storage.put(AppStrings.userStorageKey, payload);
  }

  Future<User?> getUserInfo() {
    return _storage.get(AppStrings.userStorageKey);
  }

  Future<void> removeUserInfo() {
    return _storage.remove(AppStrings.userStorageKey);
  }

  Future<EmailConfirmation?> getEmailConfirmationData() {
    return _storage.get(AppStrings.confirmationDateStore);
  }

  Future<void> setEmailConfirmation(EmailConfirmation payload) {
    return _storage.put(AppStrings.confirmationDateStore, payload);
  }

  Future<void> removeEmailConfirmation() {
    return _storage.remove(AppStrings.confirmationDateStore);
  }

  Future<void> setBiometricsSettings(BiometricsSettings payload) {
    return _storage.put(AppStrings.biometricsSettingsStoreKey, payload);
  }

  Future<BiometricsSettings?> getBiometricsSettings() {
    return _storage.get(AppStrings.biometricsSettingsStoreKey);
  }
}
