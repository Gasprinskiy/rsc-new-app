
import 'package:dio/dio.dart';
import 'package:test_flutter/api/entity/accounting.dart';
import 'package:test_flutter/api/worker/worker.dart';

class AccountingApi {
  ApiWorker worker = ApiWorker();

  Future<CreateReportResult?> createReport(CreateReportParams payload) async {
    Response<dynamic> response = await worker.post('/accounting/create_report', payload.apiParams);
    return CreateReportResult(id: response.data['accounting_id']);
  }

  Future<ArchivedReportsDateRange?> getArchivedReportsDateRange() async {
    Response<dynamic> response = await worker.get('/accounting/report_date_range', null, null);
    return reportsDateRangeFromJson(response.data);
  }

  Future<FindArchivedAccountingReportsResult> findUserArchivedReportsByDateRange(FindArchivedAccountingReportsParams params) async {
    Response<dynamic> response = await worker.get('/accounting/archived_reports', params.apiParams, null);
    return archivedAccountingReportsResultFromJson(response.data);
  }

  Future<void> archivateReport(int reportId, ArchivateReportSalaryParams payload) {
    return worker.post('/accounting/archivate_report/$reportId', payload.apiParams);
  }

  Future<ReportInfo?> getReportInfoById(int reportId) async {
    Response<dynamic> response = await worker.get('/accounting/report_datails/$reportId', null, null);
    return reportInfoFromJson(response.data);
  }

  Future<int?> addSale(int reportId, Sale payload) async {
    Response<dynamic> response = await worker.post('/accounting/add_sale/$reportId', payload.apiParams);
    return response.data['id'];
  }

  Future<void> updateSale(int saleId, Sale payload) {
    return worker.post('/accounting/update_sale/$saleId', payload.apiParams);
  }

  Future<int?> addTip(int reportId, CommonAdditionalReportData payload) async {
    Response<dynamic> response = await worker.post('/accounting/add_tip/$reportId', payload.apiParams);
    return response.data['id'];
  }
}