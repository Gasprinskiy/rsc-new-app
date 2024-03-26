import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/worker/worker.dart';

class TokenStorage {
  static TokenStorage? _instance;
  final _storage = Storage.getInstance();

  TokenStorage._();

  static TokenStorage getInstance() {
    _instance ??= TokenStorage._();
    return _instance!;
  }

  Future<void> setToken(String token) async {
    return _storage.put(AppStrings.tokenStorageKey, token);
  }

  Future<String?> getToken() async {
    return _storage.get(AppStrings.tokenStorageKey);
  }

  Future<void> removeToken() async {
    return _storage.remove(AppStrings.tokenStorageKey);
  }
}
