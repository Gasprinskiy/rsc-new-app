import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageWorker {
  final _secureStorage = const FlutterSecureStorage();

  Future<void> putString(String key, String value) {
    return _secureStorage.write(key: key, value: value);
  }

  Future<String?> getString(String key) {
    return _secureStorage.read(key: key);
  }

  Future<void> remove(String key) {
    return _secureStorage.delete(key: key);
  }
}
