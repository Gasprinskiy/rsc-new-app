
import 'package:flutter/material.dart';
import 'package:rsc/api/accounting.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/api/entity/user.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/core/accounting_calculations.dart';
import 'package:rsc/core/entity.dart';
import 'package:rsc/helpers/request_handler.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/views/main/children/accounting/children/archive/details/children/prepayments.dart';
import 'package:rsc/views/main/children/accounting/children/archive/details/children/sales.dart';
import 'package:rsc/views/main/children/accounting/children/archive/details/children/tips.dart';
import 'package:rsc/views/main/widgets/common_salary_box.dart';
import 'package:rsc/views/main/widgets/prepayments_box.dart';
import 'package:rsc/views/main/widgets/sales_box.dart';
import 'package:rsc/views/main/widgets/tips_box.dart';
import 'package:rsc/widgets/back_appbar.dart';

class ArchivedReportDetails extends StatefulWidget {
  final int reportId;
  final DateTime creationDate;

  const ArchivedReportDetails({
    super.key, 
    required this.reportId,
    required this.creationDate
  });

  @override
  State<ArchivedReportDetails> createState() => _DetailsState();
}

class _DetailsState extends State<ArchivedReportDetails> {
  final api = AccountingApi.getInstance();
  final calcCore = AccountingCalculations.getInstance();

  late int reportId;
  late DateTime creationDate;

  double commonSalary = 0;
  List<ApiSale> sales = [];
  List<CommonAdditionalReportData> prepayments = [];
  List<CommonAdditionalReportData> tips = [];
  late UserSalaryInfo salaryInfo;
  List<UserPercentChangeConditions>? percentChangeConditions;
  bool isLoading = true;

  Future<void> executeReport() async {
    ReportInfo? result = await handleRequestError(() {
      return api.getReportInfoById(reportId);
    });

    if (result != null) {
      setState(() {
        sales = result.sales ?? [];
        prepayments = result.prepayments ?? [];
        tips = result.tips ?? [];
        salaryInfo = result.salaryInfo;
        percentChangeConditions = result.percentChangeConditions;
      });
    }
    setState(() {
      isLoading = false;
    });
    calcCommonSalary();
  }

  void calcCommonSalary() {
    List<PercentChangeRule>? percentChangeRules = percentChangeConditions?.map((item) {
      return PercentChangeRule(
        percentGoal: item.percentGoal, 
        percentChange: item.percentChange, 
        salaryBonus: item.salaryBonus ?? 0
      );
    }).toList();
    setState(() {
      commonSalary = calcCore.calcCommonSalary(
        CalcCommonSalaryOptions(
          sales: sales.map((item) => item.total).toList(), 
          salary: salaryInfo.salary, 
          percentFromSales: salaryInfo.percentFromSales,
          ignorePlan: salaryInfo.ignorePlan ?? false, 
          isVariablePercent: percentChangeConditions != null, 
          plan: salaryInfo.plan ?? 0, 
          percentChangeRules: percentChangeRules ?? []
        )
      );
    });
  }

  void nivigateToSalesDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return SalesArchivedDetails(data: sales, creationDate: creationDate);
      }
    ));
  }

  void nivigateToPrepaymentsDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return PrepaymentsArchivedDetails(data: prepayments, creationDate: creationDate);
      }
    ));
  }

  void nivigateToTipsDetails() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return TipsArchivedDetails(data: tips, creationDate: creationDate);
      }
    ));
  }

  @override
  void initState() {
    super.initState();
    reportId = widget.reportId;
    creationDate = widget.creationDate;
    executeReport();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: BackAppBar(
          title: Text(
            monthAndYear(creationDate).capitalize(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600
            ),
          ),
        )
      ),
      body: 
      isLoading
      ?
      const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
      )
      :
      ListView(
        children: [
          CommonSalaryBox(
            key: Key(commonSalary.toString()),
            commonSalary: commonSalary
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                SalesBox(
                  sales: sales.map((item) {
                    return Sale(
                      total: item.total, 
                      nonCash: item.nonCash, 
                      cashTaxes: item.cashTaxes, 
                      creationDate: item.creationDate,
                      cloudId: item.id
                    );
                  }).toList(),
                  onBoxClick: nivigateToSalesDetails,
                ),
                const SizedBox(height: 20),
                PrepaymentsBox(
                  prepayments: prepayments.map((item) {
                    return Prepayment(
                      value:item.value, 
                      creationDate: item.creationDate,
                      cloudId: item.id
                    ); 
                  }).toList(),
                  onBoxClick: nivigateToPrepaymentsDetails,
                ),
                const SizedBox(height: 20),
                TipsBox(
                  tips: tips.map((item) {
                    return Tip(
                      value:item.value, 
                      creationDate: item.creationDate,
                      cloudId: item.id
                    ); 
                  }).toList(),
                  onBoxClick: nivigateToTipsDetails,
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}