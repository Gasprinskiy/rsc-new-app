import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/storage/hive/worker/worker.dart';

class AccountingStorage {
  final Storage storage = Storage.getInstance();

  final currentReportKey = '${AppStrings.accountingStorageKey}-current-report';
  final salesKey = '${AppStrings.accountingStorageKey}-sales';
  final tipsKey = '${AppStrings.accountingStorageKey}-tips';
  final prepaymentsKey = '${AppStrings.accountingStorageKey}-prepayments';

  Future<CurrentReport?> getCurrentReport() {
    return storage.get(currentReportKey);
  }

  Future<void> putCurrentReport(CurrentReport payload) {
    return storage.put(currentReportKey, payload);
  }

  Future<List<Sale>?> getSales() async {
    SaleList? list = await storage.get(salesKey);
    return list?.data;
  }

  Future<List<Tip>?> getTips() async {
    TipList? list = await storage.get(tipsKey);
    return list?.data;
  }

  Future<List<Prepayment>?> getPrepayments() async {
    PrepaymentList? list = await storage.get(prepaymentsKey);
    return list?.data;
  }

  Future<Sale?> getSaleById(String id)  {
    return _handleGetByIdAction<Sale>(
      () => getSales(),
      (List<Sale> list) => list.firstWhere((item) => item.id == id)
    );
  }

  Future<void> addSale(Sale payload) async {
    List<Sale> newData = await _handleAddAction<Sale>(
      payload,
      () => getSales()
    );
    await storage.put(salesKey, SaleList(data: newData));
  }

  Future<void> updateSale(Sale payload) async {
    List<Sale>? sales = await _handleUpdateAction<Sale>(
      payload,
      () => getSales(),
      (List<Sale> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (sales != null) {
      await storage.put(salesKey, SaleList(data: sales));
    }
  }

  Future<Tip?> getTipById(String id) {
    return _handleGetByIdAction<Tip>(
      () => getTips(),
      (List<Tip> list) => list.firstWhere((item) => item.id == id)
    );
  }

  Future<void> addTip(Tip payload) async {
    List<Tip> newData = await _handleAddAction<Tip>(
      payload,
      () => getTips()
    );
    await storage.put(tipsKey, TipList(data: newData));
  }

  Future<void> updateTip(Tip payload) async {
    List<Tip>? tips = await _handleUpdateAction<Tip>(
      payload,
      () => getTips(),
      (List<Tip> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (tips != null) {
      await storage.put(tipsKey, TipList(data: tips));
    }
  }

  Future<Prepayment?> getPrepaymentById(String id) {
    return _handleGetByIdAction<Prepayment>(
      () => getPrepayments(),
      (List<Prepayment> list) => list.firstWhere((item) => item.id == id)
    );
  }

  Future<void> addPrepayment(Prepayment payload) async {
    List<Prepayment> newData = await _handleAddAction<Prepayment>(
      payload,
      () => getPrepayments()
    );
    await storage.put(prepaymentsKey, PrepaymentList(data: newData));
  }

  Future<void> updatePrepayment(Prepayment payload) async {
    List<Prepayment>? prepayments = await _handleUpdateAction<Prepayment>(
      payload,
      () => getPrepayments(),
      (List<Prepayment> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (prepayments != null) {
      await storage.put(prepaymentsKey, PrepaymentList(data: prepayments));
    }
  }

  Future<List<T>> _handleAddAction<T>(
    T payload,
    Future<List<T>?> Function() getListFunc,
  ) async {
    List<T>? list = await getListFunc();
    if (list != null) {
      list.add(payload);
      return list;
    } else {
      return [payload];
    }
  }

  Future<List<T>?> _handleUpdateAction<T>(
    T payload,
    Future<List<T>?> Function() getListFunc,
    int Function(List<T>) findIndexFunc
  ) async {
    List<T>? list = await getListFunc();
    if (list != null) {
      int indexOfSaleToUpdate = findIndexFunc(list);
      if (indexOfSaleToUpdate >= 0) {
        list[indexOfSaleToUpdate] = payload;
        return list;
      }
    }
    return null;
  }

  Future<T?> _handleGetByIdAction<T>(
    Future<List<T>?> Function() getListFunc,
    T? Function(List<T> list) findFunc
  ) async {
    List<T>? list = await getListFunc();
    if (list != null) {
      return findFunc(list);
    }
    return null;
  }
}
