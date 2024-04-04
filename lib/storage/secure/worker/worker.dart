import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageWorker {
  static SecureStorageWorker? _instance;
  final _secureStorage = const FlutterSecureStorage();

  SecureStorageWorker._();

  static SecureStorageWorker getInstanse() {
    _instance ??= SecureStorageWorker._();
    return _instance!;
  }

  Future<void> putString(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  Future<String?> getString(String key) {
    return _secureStorage.read(key: key);
  }

  Future<void> remove(String key) {
    return _secureStorage.delete(key: key);
  }

  Future<void> removeAll() {
    return _secureStorage.deleteAll();
  }
}
