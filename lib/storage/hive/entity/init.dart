import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';

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
    Hive.registerAdapter(SynchronizationDataAdapter());
    Hive.registerAdapter(SaleListAdapter());
    Hive.registerAdapter(SynchronizationDataTypeAdapter());
    Hive.registerAdapter(SynchronizationDataListAdapter());
    Hive.registerAdapter(TipListAdapter());
    Hive.registerAdapter(PrepaymentListAdapter());
    Hive.registerAdapter(ArchivateReportAdapter());
    Hive.registerAdapter(UpdatedSalaryInfoAdapter());
  }
}
