import 'package:hive/hive.dart';
import 'package:rsc/constants/app_strings.dart';

class Storage {
  static Storage? _instanse;

  Storage._();

  static Storage getInstance() {
    _instanse ??= Storage._();
    return _instanse!;
  }

  Future<T> get<T>(String key) async {
    Box<dynamic> box = await _openBox();
    T res = box.get(key);
    return res;
  }

  Future<void> put<T>(String key, T payload) async {
    Box<dynamic> box = await _openBox();
    await box.put(key, payload);
  }

  Future<void> remove(String key) async {
    Box<dynamic> box = await _openBox();
    await box.delete(key);
  }

  Future<void> removeAllData() async {
    Box<dynamic> box = await _openBox();
    await box.deleteFromDisk();
  }

  Future<Box<dynamic>> _openBox() async {
    if (Hive.isBoxOpen(AppStrings.appStorageKey)) {
      return Hive.box(AppStrings.appStorageKey);
    }
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
    return box;
  }
}
