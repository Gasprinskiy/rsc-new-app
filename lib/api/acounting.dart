
import 'package:dio/dio.dart';
import 'package:test_flutter/api/entity/accounting.dart';
import 'package:test_flutter/api/tools/error_handler.dart';
import 'package:test_flutter/api/worker/worker.dart';


class AccountingApi {
  static AccountingApi? _instance;
  final _worker = ApiWorker.getInstance();

  AccountingApi._();

  static AccountingApi getInstance() {
    _instance ??= AccountingApi._();
    return _instance!;
  }

  Future<int?> createReport(CreateReportParams payload) async {
    Response<dynamic> response = await _worker.post('/accounting/create_report', payload.apiParams);
    return response.data['accounting_id'];
  }

  Future<ApiCurrentReport?> getCurrentReport() async {
    return handleResponseDataParse<ApiCurrentReport?>(
      () => _worker.get('/accounting/current_report', null, null),
      (data) => apiCurrentReportFromJson(data)
    );
  }

  Future<ArchivedReportsDateRange?> getArchivedReportsDateRange() async {
    Response<dynamic> response = await _worker.get('/accounting/report_date_range', null, null);
    return reportsDateRangeFromJson(response.data);
  }

  Future<FindArchivedAccountingReportsResult> findUserArchivedReportsByDateRange(FindArchivedAccountingReportsParams params) async {
    Response<dynamic> response = await _worker.get('/accounting/archived_reports', params.apiParams, null);
    return archivedAccountingReportsResultFromJson(response.data);
  }

  Future<void> archivateReport(int reportId, ArchivateReportSalaryParams payload) {
    return _worker.post('/accounting/archivate_report/$reportId', payload.apiParams);
  }

  Future<ReportInfo?> getReportInfoById(int reportId) async {
    Response<dynamic> response = await _worker.get('/accounting/report_datails/$reportId', null, null);
    return reportInfoFromJson(response.data);
  }

  Future<int?> addSale(int reportId, ApiSale payload) async {
    Response<dynamic> response = await _worker.post('/accounting/add_sale/$reportId', payload.apiParams);
    return response.data['id'];
  }

  Future<void> updateSale(int saleId, ApiSale payload) {
    return _worker.post('/accounting/update_sale/$saleId', payload.apiParams);
  }

  Future<int?> addTip(int reportId, CommonAdditionalReportData payload) async {
    Response<dynamic> response = await _worker.post('/accounting/add_tip/$reportId', payload.apiParams);
    return response.data['id'];
  }

  Future<void> updateTip(int tipId, CommonAdditionalReportData payload) {
    return _worker.post('/accounting/update_tip/$tipId', payload.apiParams);
  }

  Future<int?> addPrepayment(int reportId, CommonAdditionalReportData payload) async {
    Response<dynamic> response = await _worker.post('/accounting/add_prepayment/$reportId', payload.apiParams);
    return response.data['id'];
  }

  Future<void> updatePrepayment(int prepeymentId, CommonAdditionalReportData payload) {
    return _worker.post('/accounting/update_prepayment/$prepeymentId', payload.apiParams);
  }
}