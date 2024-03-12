import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_flutter/storage/hive/worker/adapters/adapters.dart';

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
    Hive.registerAdapter(BiometricsSettingsAdapter());
    Hive.registerAdapter(CurrentReportAdapter());
    Hive.registerAdapter(SaleAdapter());
    Hive.registerAdapter(TipAdapter());
    Hive.registerAdapter(PrepaymentAdapter());
  }
}
