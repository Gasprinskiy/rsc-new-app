import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';

class StorageInitializer {
  Future<void> initStorage() async {
    Directory path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);

    _registerTypeAdapters();
  }

  void _registerTypeAdapters() {
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(PersonalInfoAdapter());
    Hive.registerAdapter(SalaryInfoAdapter());
    Hive.registerAdapter(PercentChangeConditionsAdapter());
    Hive.registerAdapter(EmailConfirmationAdapter());
  }
}
