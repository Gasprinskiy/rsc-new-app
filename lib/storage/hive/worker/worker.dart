import 'package:hive/hive.dart';
import 'package:test_flutter/constants/app_strings.dart';

class Storage {
  Future<T> get<T>(String key) async {
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
    T res = box.get(key);
    await box.close();
    return res;
  }

  Future<void> put<T>(String key, T payload) async {
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
    await box.put(key, payload);
    await box.close();
  }

  Future<void> remove(String key) async {
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
    await box.delete(key);
    await box.close();
  }
}
