import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/worker/worker.dart';

class TokenWorker {
  final Storage storage = Storage();

  Future<void> setToken(String token) async {
    return storage.put(AppStrings.tokenStorageKey, token);
  }

  Future<String?> getToken() async {
    return storage.get(AppStrings.tokenStorageKey);
  }

  Future<void> removeToken() async {
    return storage.remove(AppStrings.tokenStorageKey);
  }
}
