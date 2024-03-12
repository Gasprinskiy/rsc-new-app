import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/worker/adapters/adapters.dart';
import 'package:test_flutter/storage/hive/worker/worker.dart';

class AccountingStorage {
  final Storage storage = Storage();

  final currentReportKey = '${AppStrings.accountingStorageKey}-current-report';
  final salesKey = '${AppStrings.accountingStorageKey}-sales';

  Future<CurrentReport> getCurrentReport() {
    return storage.get(currentReportKey);
  }

  Future<void> putCurrentReport(CurrentReport payload) {
    return storage.put(currentReportKey, payload);
  }

  Future<List<Sale>> getSales() {
    return storage.get(salesKey);
  }

  Future<Sale?> getSaleById(String id) async {
    List<Sale>? sales = await storage.get(salesKey);
    if (sales != null) {
      return sales.firstWhere((item) => item.id == id);
    }
    return null;
  }

  Future<void> addSale(Sale payload) async {
    List<Sale>? sales = await storage.get(salesKey);
    if (sales != null) {
      sales.add(payload);
      await storage.put(salesKey, sales);
    } else {
      await storage.put(salesKey, [payload]);
    }
  }
}
