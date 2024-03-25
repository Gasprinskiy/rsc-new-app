
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/storage/hive/worker/worker.dart';

class SynchronizationDataStorage {
  final Storage storage = Storage.getInstance();

  Future<List<SynchronizationData>?> getSynchronizationData() async {
    // await storage.remove(AppStrings.syncStorageKey);
    SynchronizationDataList? result = await storage.get(AppStrings.syncStorageKey);
    return result?.data;
  }

  Future<void> addSynchronizationData(SynchronizationData payload) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      data.add(payload);
      return storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
    } else {
      return storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: [payload]));
    }
  }

  Future<void> updateSyncData(SynchronizationData payload) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      int index = await _findIndexById(data, payload.id);
      if (index >= 0) {
        data[index] = payload;
        await storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      }
    }
  }

  Future<void> removeSyncDataById(String id) async {
    List<SynchronizationData>? data = await getSynchronizationData();
    if (data != null) {
      int index = await _findIndexById(data, id);
      if (index >= 0) {
        data.removeAt(index);
        await storage.put(AppStrings.syncStorageKey, SynchronizationDataList(data: data));
      } 
    }
  }

  Future<int> _findIndexById(List<SynchronizationData> data, String id) async {
    return data.indexWhere((element) => element.id == id);
  }
}