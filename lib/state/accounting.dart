import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_flutter/api/acounting.dart';
import 'package:test_flutter/api/entity/accounting.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/core/entity.dart';
import 'package:test_flutter/helpers/toasts.dart';
import 'package:test_flutter/state/entity/entity.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/storage/hive/accounting.dart';
import 'package:test_flutter/storage/hive/synchronization_data.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/utils/event_bus/event_bus.dart';
import 'package:test_flutter/utils/widgets/toast.dart';


class AccountingState {
  static AccountingState? _instance;

  final api = AccountingApi.getInstance();
  final appToast = AppToast.getInstance();
  final storage = AccountingStorage.getInstance();
  final syncStorage = SynchronizationDataStorage.getInstance();
  final calcCore = AccointingCalculations.getInstance();
  final userState = UserState.getInstance();
  final appBus = AppEventBus.getInstance();

  int? _currentAccountingId;
  DateTime? _currentAccountingCreationDate;

  int? get currentAccuntingId => _currentAccountingId;
  DateTime? get currentAccountingCreationDate => _currentAccountingCreationDate;

  AccountingState._();

  static AccountingState getInstance() {
    _instance ??= AccountingState._();
    return _instance!;
  }

  Future<void> initState() async {
    // storage.putCurrentReport(CurrentReport(
    //   cloudId: 13,
    //   creationDate: DateTime.parse('2024-03-05 08:43:18.128-05')
    // ));
    CurrentReport? report = await storage.getCurrentReport();
    print('report ${report?.cloudId}');
    _currentAccountingId = report?.cloudId;
    _currentAccountingCreationDate = report?.creationDate;
  }

  Future<bool> hasDataToSync() async {
    List<SynchronizationData>? list = await syncStorage.getSynchronizationData();
    return list != null && list.isNotEmpty;
  }
  
  Future<List<RecentAction>?> getRecentActions() async {
    List<RecentAction> list = [];
    
    DateTime now = DateTime.now();
    DateTime from = now.subtract(const Duration(days: 7));

    // get sales
    List<Sale>? saleList = await storage.getSalesByDateRange(from, now);
    List<Sale>? commonSales = await storage.getSales();
    double? percentFromSales = userState.user?.salaryInfo?.percentFromSales;

    bool calcSales = saleList != null && commonSales != null && percentFromSales != null;
    if (calcSales) {
      if (userState.user?.percentChangeConditions != null && userState.user?.salaryInfo?.plan != null) {
        ReachedConditionResult? reachedConditions = calcCore.findReachedConditions(
          FindReachedConditionsOptions(
            sales: commonSales.map((item) => item.total).toList(), 
            plan: userState.user!.salaryInfo!.plan!, 
            rules: userState.user!.percentChangeConditions!.map((item) {
              return PercentChangeRule(
                percentGoal: item.percentGoal, 
                percentChange: item.percentChange, 
                salaryBonus: item.salaryBonus != null ? item.salaryBonus! : 0
              );
            }).toList()
          )
        );
        if (reachedConditions != null) {
          percentFromSales = reachedConditions.changedPercent;
        }
      }
      list.addAll(saleList.map((item) {
        return RecentAction(
          type: RecentActionsType.payment, 
          valueType: RecentActionsValueType.percentFromSale,
          amount: calcCore.calcPercent(item.total, percentFromSales!), 
          creationDate: item.creationDate
        );
      }));
    }
    ///
    
    // get tips
    List<Tip>? tipsList = await storage.getTipsByDateRange(from, now);
    if (tipsList != null) {
      list.addAll(tipsList.map((item) {
        return RecentAction(
          type: RecentActionsType.payment,
          valueType: RecentActionsValueType.tip, 
          amount: item.value, 
          creationDate: item.creationDate
        );
      }));
    }
    ///
    
    // get prepayments
    List<Prepayment>? prepaymentsList = await storage.getPrepaymentsByDateRange(from, now);
    if (prepaymentsList != null) {
      list.addAll(prepaymentsList.map((item) {
        return RecentAction(
          type: RecentActionsType.expense, 
          valueType: RecentActionsValueType.prepayment, 
          amount: item.value, 
          creationDate: item.creationDate
        );
      }));
    }

    if (list.isNotEmpty) {
      list.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      return list;
    }
    return null;
  }

  Future<List<Sale>?> getSaleList() {
    return storage.getSales();
  }

  Future<List<Prepayment>?> getPrepaymentList() {
    return storage.getPrepayments();
  }

  Future<void> addAndSyncSale(Sale sale) async {
    ApiSale apiPayload = ApiSale(
      total: sale.total, 
      nonCash: sale.nonCash, 
      cashTaxes: sale.cashTaxes,
      creationDate: sale.creationDate
    );
    _handleAddDataAction(
      sale,
      SynchronizationDataType.sale,
      _currentAccountingId != null ? () => api.addSale(_currentAccountingId!, apiPayload) : null,
      () => storage.addSale(sale)
    );
  }

  Future<void> updateAndSyncSale(Sale sale) async {
    ApiSale apiPayload = ApiSale(
      total: sale.total, 
      nonCash: sale.nonCash, 
      cashTaxes: sale.cashTaxes,
      creationDate: sale.creationDate
    );
    
    _handleUpdateDataAction(
      sale,
      SynchronizationDataType.sale,
      sale.cloudId != null ? () => api.updateSale(sale.cloudId!, apiPayload) : null,
      () => storage.updateSale(sale)
    );
  }

  Future<void> addAndSyncTip(Tip tip) async {
    CommonAdditionalReportData apiPayload = CommonAdditionalReportData(
      value: tip.value,
      creationDate: tip.creationDate
    );

    _handleAddDataAction(
      tip,
      SynchronizationDataType.tip,
      _currentAccountingId != null ? () => api.addTip(_currentAccountingId!, apiPayload) : null,
      () => storage.addTip(tip)
    );
  }

  Future<void> updateAndSyncTip(Tip tip) async {
    CommonAdditionalReportData apiPayload = CommonAdditionalReportData(
      value: tip.value,
      creationDate: tip.creationDate
    );

    _handleUpdateDataAction(
      tip,
      SynchronizationDataType.tip,
      tip.cloudId != null ? () => api.updateTip(tip.cloudId!, apiPayload) : null,
      () => storage.updateTip(tip)
    );
  }

  Future<void> syncAllData() async {
    List<SynchronizationData>? list = await syncStorage.getSynchronizationData();

    if (list != null && list.isNotEmpty) {
      List<SynchronizationData> dataToRemove = [];
      for (var element in list) {
        await Future.delayed(const Duration(seconds: 1));
        SyncRequestStatus status = SyncRequestStatus.success;
        if (element.type == SynchronizationDataType.sale) {
          status = await syncSale(element);
        }
        if (element.type == SynchronizationDataType.tip) {
          status = await syncTip(element);
        }
        if (element.type == SynchronizationDataType.prepayment) {
          status = await syncPrepayment(element);
        }

        if (status == SyncRequestStatus.success) {
          dataToRemove.add(element);
        }
      }

      if (dataToRemove.isNotEmpty) {
        for (var element in dataToRemove) {
          await syncStorage.removeSyncDataById(element.id);
        }
        if (dataToRemove.length < list.length) {
          appToast.showCustomToast(
            AppColors.warn, 
            Icons.cloud_off_rounded, 
            AppStrings.syncDataCount(dataToRemove.length, list.length)
          );
        } else {
          appToast.showCustomToast(
            AppColors.success, 
            Icons.cloud_done_rounded, 
            AppStrings.dataSyncronized
          );
        }
      } else {
        appToast.showCustomToast(
          AppColors.error,
          Icons.cloud_off_rounded,
          AppStrings.couldNotSyncData
        );
      }
      appBus.fire(SynchronizationDoneEvent(failedSyncCount: list.length - dataToRemove.length));
    }
  }

  Future<SyncRequestStatus> syncSale(SynchronizationData payload) async {
    if (payload.data is Sale) {
      Sale sale = payload.data;
      ApiSale apiPayload = ApiSale(
        total: sale.total, 
        nonCash: sale.nonCash, 
        cashTaxes: sale.cashTaxes,
        creationDate: sale.creationDate
      );
      SyncRequestType requestType = sale.cloudId != null ? SyncRequestType.update : SyncRequestType.add;
      switch (requestType) {
        case SyncRequestType.update:
          try {
            await api.updateSale(sale.cloudId!, apiPayload);
            return SyncRequestStatus.success;
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
        case SyncRequestType.add:
          try {
            int? cloudId = await api.addSale(_currentAccountingId!, apiPayload);
            if (cloudId != null) {
              sale.cloudId = cloudId;
              await storage.updateSale(sale);
              return SyncRequestStatus.success;
            }
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
      }
      return SyncRequestStatus.error;
    } else {
      throw Exception('Invalid data type');
    }
  }

  Future<SyncRequestStatus> syncTip(SynchronizationData payload) async {
    if (payload.data is Tip) {
      Tip tip = payload.data;
      CommonAdditionalReportData apiPayload = CommonAdditionalReportData(
        value: tip.value,
        creationDate: tip.creationDate
      );
      SyncRequestType requestType = tip.cloudId != null ? SyncRequestType.update : SyncRequestType.add;
      switch (requestType) {
        case SyncRequestType.update:
          try {
            await api.updateTip(tip.cloudId!, apiPayload);
            return SyncRequestStatus.success;
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
        case SyncRequestType.add:
          try {
            int? cloudId = await api.addTip(_currentAccountingId!, apiPayload);
            if (cloudId != null) {
              tip.cloudId = cloudId;
              await storage.updateTip(tip);
              return SyncRequestStatus.success;
            }
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
      }
      return SyncRequestStatus.error;
    } else {
      throw Exception('Invalid data type');
    }
  }

  Future<SyncRequestStatus> syncPrepayment(SynchronizationData payload) async {
    if (payload.data is Prepayment) {
      Prepayment prepayment = payload.data;
      CommonAdditionalReportData apiPayload = CommonAdditionalReportData(
        value: prepayment.value,
        creationDate: prepayment.creationDate
      );
      SyncRequestType requestType = prepayment.cloudId != null ? SyncRequestType.update : SyncRequestType.add;
      switch (requestType) {
        case SyncRequestType.update:
          try {
            await api.updatePrepayment(prepayment.cloudId!, apiPayload);
            return SyncRequestStatus.success;
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
        case SyncRequestType.add:
          try {
            int? cloudId = await api.addPrepayment(_currentAccountingId!, apiPayload);
            if (cloudId != null) {
              prepayment.cloudId = cloudId;
              await storage.updatePrepayment(prepayment);
              return SyncRequestStatus.success;
            }
          } on DioException catch(_) {
            return SyncRequestStatus.error;
          }
      }
      return SyncRequestStatus.error;
      
    } else {
      throw Exception('Invalid data type');
    }
  }

  Future<void> _handleAddDataAction<T>(
    T sourcePayload, 
    SynchronizationDataType type,
    Future<int?> Function()? apiFunc,
    Future<void> Function() storeFunc, 
  ) async {
    SynchronizationData payload = SynchronizationData(
      type: type,
      data: sourcePayload
    );

    int? id;
    String? syncErrMessge;
    (id, syncErrMessge) = await _handleSyncRequest(
      payload,
      apiFunc != null ? () => apiFunc() : null
    );

    if (id != null) {
      if (sourcePayload is Sale) {
        sourcePayload.cloudId = id;
      }
      if (sourcePayload is Tip) {
        sourcePayload.cloudId = id;
      }
      if (sourcePayload is Prepayment) {
        sourcePayload.cloudId = id;
      }
    }

    try {
      await storeFunc();
      if (id != null) {
        appToast.showCustomToast(
          AppColors.success, 
          Icons.cloud_done_rounded, 
          AppStrings.dataStoredAndSyncronized
        );
        return;
      } 

      if (syncErrMessge != null && id == null) {
        appToast.showSuccessToast(AppStrings.dataStoredInLocalStorage);
        appToast.showCustomToast(
          AppColors.warn, 
          Icons.cloud_off_rounded, 
          '${AppStrings.couldNotSyncData}: $syncErrMessge'
        );
        appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
        return;
      }

      if (syncErrMessge == null && id == null) {
        appToast.showSuccessToast(AppStrings.dataStoredInLocalStorage);
        appToast.showCustomToast(
          AppColors.warn, 
          Icons.cloud_off_rounded, 
          AppStrings.couldNotSyncData
        );
        appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
      }
    } on HiveError catch(_) {
      appToast.showErrorToast(AppStrings.errOnWritingData);
    }
  }

  Future<void> _handleUpdateDataAction<T>(
    T sourcePayload, 
    SynchronizationDataType type,
    Future<void> Function()? apiFunc,
    Future<void> Function() storeFunc, 
  ) async {
    SynchronizationData payload = SynchronizationData(
      type: type,
      data: sourcePayload
    );

    String? syncErrMessge;
    (_, syncErrMessge) = await _handleSyncRequest(
      payload,
      apiFunc != null ? () => apiFunc() : null
    );
    
    try {
      await storeFunc();
      if (apiFunc != null) {
        if (syncErrMessge == null) {
          appToast.showCustomToast(
            AppColors.success, 
            Icons.cloud_done_rounded, 
            AppStrings.dataUpdatedAndSyncronized
          );
          return;
        } else {
          appToast.showSuccessToast(AppStrings.dataUpdated);
          appToast.showCustomToast(
            AppColors.warn, 
            Icons.cloud_off_rounded, 
            '${AppStrings.couldNotSyncData}: $syncErrMessge'
          );
          appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
        }
      } else {
        appToast.showSuccessToast(AppStrings.dataUpdated);
        appToast.showCustomToast(
          AppColors.warn, 
          Icons.cloud_off_rounded, 
          AppStrings.couldNotSyncData
        );
        appBus.fire(SynchronizationDoneEvent(failedSyncCount: 1));
      }
    } on HiveError catch(_) {
      appToast.showErrorToast(AppStrings.errOnWritingData);
    }
  }

  Future<(T?, String?)> _handleSyncRequest<T>(
    SynchronizationData payload, 
    Future<T?> Function()? func,
  ) async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;
    if (hasConnection) {
      if (func != null) {
        try {
          T? repose = await func();
          return (repose, null);
        } on DioException catch (err) {
          await _addSyncData(payload);
          return (null, err.message.toString());
        } 
      } else {
        _updateSyncData(payload);
        return (null, null);
      }
    } else {
      await _addSyncData(payload);
      return (null, AppStrings.noInternetConnection);
    }
  }

  Future<void> _addSyncData(SynchronizationData payload) async {
    try {
      await syncStorage.addSynchronizationData(payload);
    } on HiveError catch(_) {
      showErrorToast(appToast.toast, AppStrings.errOnWritingData);
    }
  }

  Future<void> _updateSyncData(SynchronizationData payload) async {
    try {
      await syncStorage.updateSyncData(payload);
    } on HiveError catch(_) {
      showErrorToast(appToast.toast, AppStrings.errOnWritingData);
    }
  }
}