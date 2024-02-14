import 'package:hive/hive.dart';

class Storage {
  final Box<dynamic> storageInstance;

  Storage({required this.storageInstance});

  Future<T> get<T>(String key) async {
    return storageInstance.get(key);
  }

  Future<void> put<T>(String key, T payload) async {
    return storageInstance.put(key, payload);
  }

  Future<void> remove(String key) async {
    return storageInstance.delete(key);
  }
}
