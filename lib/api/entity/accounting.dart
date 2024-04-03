
import 'package:rsc/api/entity/user.dart';

abstract class ApiPayload {
  Map<String, dynamic> get apiParams;
}

class CreateReportResult {
  int id;

  CreateReportResult({required this.id});
}

class ApiCurrentReport {
  int id;
  DateTime creationDate;
  List<ApiSale>? sales;
  List<CommonAdditionalReportData>? tips;
  List<CommonAdditionalReportData>? prepayments;

  ApiCurrentReport({
    required this.id, 
    required this.creationDate,
    this.sales,
    this.tips,
    this.prepayments
  });
}

ApiCurrentReport apiCurrentReportFromJson(dynamic data) {
  ApiCurrentReport result = ApiCurrentReport(
    id: data['accounting_id'].toInt(),
    creationDate: DateTime.parse(data['creation_date'])
  );

  if (data['sales'] != null) {
    List<dynamic> salesApiData = data['sales'];
    List<ApiSale> sales = [];
    for (var element in salesApiData) {
      sales.add(saleFromJson(element));
    }
    result.sales = sales;
  }

  if (data['tips'] != null) {
    List<dynamic> tipsApiData = data['tips'];
    List<CommonAdditionalReportData> tips = [];
    for (var element in tipsApiData) {
      tips.add(commonAditionalDataFromJson(element));
    }
    result.tips = tips;
  }

  if (data['prepayments'] != null) {
    List<dynamic> prepaymentsApiData = data['prepayments'];
    List<CommonAdditionalReportData> prepayments = [];
    for (var element in prepaymentsApiData) {
      prepayments.add(commonAditionalDataFromJson(element));
    }
    result.prepayments = prepayments;
  }

  return result;
}

class CreateReportParams extends ApiPayload {
  DateTime creationDate;

  CreateReportParams({required this.creationDate});

  @override
  Map<String, String> get apiParams {
    return {
      'creation_date': creationDate.toIso8601String()
    };
  }
}

class ArchivedReportsDateRange extends ApiPayload {
  DateTime from;
  DateTime to;

  ArchivedReportsDateRange({required this.from, required this.to});

  @override
  Map<String, DateTime> get apiParams {
    return {
      'date_from': from,
      'date_to': to
    };
  }
}

ArchivedReportsDateRange reportsDateRangeFromJson(dynamic data) {
  return ArchivedReportsDateRange(
    from: DateTime.parse(data['min']),
    to: DateTime.parse(data['max'])
  );
}

class FindArchivedAccountngPaginParams extends ApiPayload {
  int limit;
  int offset;

  FindArchivedAccountngPaginParams({required this.limit, required this.offset});

  @override
  Map<String, int> get apiParams {
    return {
      'limit': limit,
      'offset': offset
    };
  }
}


class FindArchivedAccountingReportsParams extends ApiPayload {
  ArchivedReportsDateRange dateRange;
  FindArchivedAccountngPaginParams pagination;

  FindArchivedAccountingReportsParams({required this.dateRange, required this.pagination});

  @override
  Map<String, dynamic> get apiParams {
    return {
      'date_range': dateRange.apiParams,
      'pagination': pagination.apiParams
    };
  }
}

class AccountingReport {
  int id;
  DateTime creationDate;

  AccountingReport({required this.id, required this.creationDate});
}

AccountingReport accountingReportFromJson(dynamic data) {
  return AccountingReport(
    id: data['accounting_id'],
    creationDate: DateTime.parse(data['creation_date'])
  );
}

class FindArchivedAccountingReportsResult {
  List<AccountingReport> reports;
  int totalCount;
  int totalPage;

  FindArchivedAccountingReportsResult({required this.reports, required this.totalCount, required this.totalPage});
}

FindArchivedAccountingReportsResult archivedAccountingReportsResultFromJson(dynamic data) {
  List<dynamic> jsonReports = data['reports'];
  List<AccountingReport> reports = jsonReports.map((item) => accountingReportFromJson(item)).toList();

  return FindArchivedAccountingReportsResult(
    reports: reports, 
    totalCount: data['total_count'], 
    totalPage: data['total_page']
  );
} 

class ArchivateReportSalaryParams extends ApiPayload {
  UserSalaryInfo salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;

  ArchivateReportSalaryParams({required this.salaryInfo, this.percentChangeConditions});

  @override
  Map<String, dynamic> get apiParams {
    return {
      'info': salaryInfo.apiParams,
      'percent_change_conditions': percentChangeConditions?.map((item) => item.apiParams).toList()
    };
  }
}

class ApiSale extends ApiPayload {
  int? id;
  double total;
  double nonCash;
  double cashTaxes;
  DateTime creationDate;

  ApiSale({
    this.id,
    required this.total,
    required this.nonCash,
    required this.cashTaxes,
    required this.creationDate,
  });

  @override
  Map<String, dynamic> get apiParams {
    return {
      'total_sales': total,
      'non_cash': nonCash,
      'cash_taxes': cashTaxes,
      'creation_date': creationDate.toIso8601String()
    };
  }
}

ApiSale saleFromJson(dynamic data) {
  return ApiSale(
    id: data?['id'],
    total: data['total_sales'].toDouble(),
    nonCash: data['non_cash'].toDouble(),
    cashTaxes: data['cash_taxes'].toDouble(),
    creationDate: DateTime.parse(data['creation_date'])
  );
}

class CommonAdditionalReportData extends ApiPayload {
  int? id;
  double value;
  DateTime creationDate;

  CommonAdditionalReportData({this.id, required this.value, required this.creationDate});

  @override
  Map<String, dynamic> get apiParams {
    return {
      'value': value,
      'creation_date': creationDate.toIso8601String()
    };
  }
}

CommonAdditionalReportData commonAditionalDataFromJson(dynamic data) {
  return CommonAdditionalReportData(
    id: data?['id'],
    value: data['value'].toDouble(),
    creationDate: DateTime.parse(data['creation_date']),
  );
}


class ReportInfo {
  List<ApiSale> sales;
  List<CommonAdditionalReportData>? tips;
  List<CommonAdditionalReportData>? prepayments;
  UserSalaryInfo salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;

  ReportInfo({
    required this.sales, 
    this.tips, 
    this.prepayments, 
    required this.salaryInfo, 
    this.percentChangeConditions
  });
}

ReportInfo reportInfoFromJson(dynamic data) {
  List<dynamic> jsonSales = data['sales'];
  ReportInfo result = ReportInfo(
    sales: jsonSales.map((item) => saleFromJson(item)).toList(),
    salaryInfo: userSalaryInfoFromJson(data['salary_info']),
  );

  if (data['tips'] != null) {
    List<dynamic> jsonTips = data['tips'];
    result.tips = jsonTips.map((item) => commonAditionalDataFromJson(item)).toList();
  }


  if(data['prepayments'] != null) {
    List<dynamic> jsonPrepayments = data['prepayments'];
    result.prepayments = jsonPrepayments.map((item) => commonAditionalDataFromJson(item)).toList();
  }

  if (data['percent_change_conditions'] != null) {
    List<dynamic> jsonConditions = data['percent_change_conditions'];
    result.percentChangeConditions = jsonConditions.map((item) => percentChangeConditionsFromJson(item)).toList();
  }

  return result;
}
