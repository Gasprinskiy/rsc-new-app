import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/storage/hive/worker/worker.dart';
import 'package:rsc/tools/datetime.dart';

class AccountingStorage {
  static AccountingStorage? _instanse;
  final _storage = Storage.getInstance();

  final currentReportKey = '${AppStrings.accountingStorageKey}-current-report';
  final salesKey = '${AppStrings.accountingStorageKey}-sales';
  final tipsKey = '${AppStrings.accountingStorageKey}-tips';
  final prepaymentsKey = '${AppStrings.accountingStorageKey}-prepayments';

  AccountingStorage._();

  static AccountingStorage getInstance() {
    _instanse ??= AccountingStorage._();
    return _instanse!;
  }

  Future<CurrentReport?> getCurrentReport() {
    return _storage.get(currentReportKey);
  }

  Future<void> putCurrentReport(CurrentReport payload) {
    return _storage.put(currentReportKey, payload);
  }

  Future<List<Sale>?> getSalesByDateRange(DateTime from, DateTime to) async {
    List<Sale>? list = await getSales();
    if (list != null) {
      return list.where((element) => isDateInDateRange(element.creationDate, from, to)).toList();
    }
    return null;
  }

  Future<List<Tip>?> getTipsByDateRange(DateTime from, DateTime to) async {
    List<Tip>? list = await getTips();
    if (list != null) {
      return list.where((element) => isDateInDateRange(element.creationDate, from, to)).toList();
    }
    return null;
  }

  Future<List<Prepayment>?> getPrepaymentsByDateRange(DateTime from, DateTime to) async {
    List<Prepayment>? list = await getPrepayments();
    if (list != null) {
      return list.where((element) => isDateInDateRange(element.creationDate, from, to)).toList();
    }
    return null;
  }

  Future<List<Sale>?> getSales() async {
    SaleList? list = await _storage.get(salesKey);
    return list?.data.toList();
  }

  Future<List<Tip>?> getTips() async {
    TipList? list = await _storage.get(tipsKey);
    return list?.data.toList();
  }

  Future<List<Prepayment>?> getPrepayments() async {
    PrepaymentList? list = await _storage.get(prepaymentsKey);
    return list?.data.toList();
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
    await _storage.put(salesKey, SaleList(data: newData));
  }

  Future<void> updateSale(Sale payload) async {
    List<Sale>? sales = await _handleUpdateAction<Sale>(
      payload,
      () => getSales(),
      (List<Sale> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (sales != null) {
      await _storage.put(salesKey, SaleList(data: sales));
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
    await _storage.put(tipsKey, TipList(data: newData));
  }

  Future<void> updateTip(Tip payload) async {
    List<Tip>? tips = await _handleUpdateAction<Tip>(
      payload,
      () => getTips(),
      (List<Tip> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (tips != null) {
      await _storage.put(tipsKey, TipList(data: tips));
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
    await _storage.put(prepaymentsKey, PrepaymentList(data: newData));
  }

  Future<void> updatePrepayment(Prepayment payload) async {
    List<Prepayment>? prepayments = await _handleUpdateAction<Prepayment>(
      payload,
      () => getPrepayments(),
      (List<Prepayment> list) => list.indexWhere((item) => item.id == payload.id)
    );
    if (prepayments != null) {
      await _storage.put(prepaymentsKey, PrepaymentList(data: prepayments));
    }
  }

  Future<void> removeAll() async {
    await _storage.remove(currentReportKey);
    await _storage.remove(salesKey);
    await _storage.remove(tipsKey);
    await _storage.remove(prepaymentsKey);
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
