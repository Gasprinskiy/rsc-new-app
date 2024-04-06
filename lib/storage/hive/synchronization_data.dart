
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/hive/worker/worker.dart';

class SynchronizationDataStorage {
  static SynchronizationDataStorage? _instanse;
  final _storage = Storage.getInstance();

  SynchronizationDataStorage._();

  static SynchronizationDataStorage getInstance() {
    _instanse ??= SynchronizationDataStorage._();
    return _instanse!;
  }

  Future<List<SynchronizationData>?> getSynchronizationData() async {
    // await storage.remove(AppStrings.syncStorageKey);
    SynchronizationDataList? result = await _storage.get(AppStrings.syncStorageKey);
    return result?.data.toList();
  }

  Future<void> addSynchronizationData(SynchronizationData payload) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      data.add(payload);
      return _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
    } else {
      return _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: [payload]));
    }
  }

  Future<void> updateReportSyncData(SynchronizationData payload) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      int index = data.indexWhere((element) {
        return element.data?.id == element.data?.id;
      });
      if (index >= 0) {
        data[index] = payload;
        await _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      } else {
        data.add(payload);
        await _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      }
    }
  }

  Future<void> updateUserSyncData(SynchronizationData payload) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      int userDataIndex = data.indexWhere((element) => element.data is User);
      if (userDataIndex >= 0) {
        data[userDataIndex] = payload;
        await _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      } else {
        data.add(payload);
        await _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      }
    }
  }

  Future<void> removeSyncDataById(String id) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      int index = await _findIndexById(data, id);
      if (index >= 0) {
        data.removeAt(index);
        await _storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      } 
    }
  }

  Future<int> _findIndexById(List<SynchronizationData> data, String id) async {
    return data.indexWhere((element) => element.id == id);
  }

  Future<void> removeAll() {
    return _storage.remove(AppStrings.syncStorageKey);
  }
}