
import 'package:dio/dio.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/api/tools/error_handler.dart';
import 'package:rsc/api/worker/worker.dart';


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

  Future<ApiReport?> getCurrentReport() {
    return handleResponseDataParse<ApiReport?>(
      () => _worker.get('/accounting/current_report', null, null),
      (data) => apiReportFromJson(data)
    );
  }

  Future<ArchivedReportsDateRange?> getArchivedReportsDateRange() async {
    Response<dynamic> response = await _worker.get('/accounting/report_date_range', null, null);
    return reportsDateRangeFromJson(response.data);
  }

  Future<FindArchivedAccountingReportsResult?> findUserArchivedReportsByDateRange(FindArchivedAccountingReportsParams params) {
    return handleResponseDataParse<FindArchivedAccountingReportsResult?>(
      () => _worker.get('/accounting/archived_reports', params.apiParams, null),
      (data) => archivedAccountingReportsResultFromJson(data)
    );
  }

  Future<List<ReportInfo>?> findAllUserArchivedReportsByDateRange() {
    return handleResponseDataParse<List<ReportInfo>?>(
      () => _worker.get('/accounting/archived_reports_all', null, null),
      (data) {
        List<dynamic>? list = data;
        return list?.map((item) => reportInfoFromJson(item)).toList();
      } 
    );
  }

  Future<void> archivateReport(int reportId, ArchivateReportSalaryParams payload) {
    return _worker.post('/accounting/archivate_report/$reportId', payload.apiParams);
  }

  Future<ReportInfo?> getReportInfoById(int reportId) {
    return handleResponseDataParse<ReportInfo?>(
      () => _worker.get('/accounting/report_datails/$reportId', null, null),
      (data) => reportInfoFromJson(data)
    );
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