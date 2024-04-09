import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:rsc/api/accounting.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/constants/app_theme.dart';
import 'package:rsc/core/accounting_calculations.dart';
import 'package:rsc/core/entity.dart';
import 'package:rsc/helpers/request_handler.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/views/main/entity/entity.dart';
import 'package:rsc/views/main/widgets/statistics_circular_diagram.dart';
import 'package:rsc/widgets/back_appbar.dart';
import 'package:rsc/widgets/button_box.dart';

class ReportStatistics extends StatefulWidget {
  const ReportStatistics({super.key});

  @override
  State<ReportStatistics> createState() => _ReportStatisticsState();
}

class _ReportStatisticsState extends State<ReportStatistics> {
  final api = AccountingApi.getInstance();
  final calcCore = AccountingCalculations.getInstance();

  final Map<int, Color> monthColorsMap = {
    1: const Color(0xFFBC2A95),
    2: const Color(0xFF8D2095),
    3: const Color(0xFF5D1793),
    4: const Color(0xFF1553CC),
    5: const Color(0xFF4CB2C0),
    6: const Color(0xFF409629),
    7: const Color(0xFF7FC73D),
    8: const Color(0xFFFFEA67),
    9: const Color(0xFFF9CD46),
    10: const Color(0xFFF39D38),
    11: const Color(0xFFEF6F2E),
    12: const Color(0xFFEC3223),
  };
  final Map<int, double> salesDiagramMap = {};

  List<ReportInfo> data = [];
  double total = 0;
  double totalSalary = 0;
  double avarageSales = 0;
  double avarageSalary = 0;
  DatedValue? recordSales;
  DatedValue? recordSalary;
  DatedValue? lastYearData;
  DatedValue? lastYearUntilThisDayData;
  bool isLoading = true;
  DateTime? dateFrom;
  DateTime? dateTo;
  

  Future<void> getAllData() async {
    List<ReportInfo>? result = await handleRequestError(() {
      return api.findAllUserArchivedReportsByDateRange();
    });

    if (result != null) {
      setState(() {
        data = result;
      });
    }
  }

  void calcDiagramValues() {
    List<double> salesTotal = data.map((element) {
      return calcCore.calcTotal(element.sales?.map((e) => e.total).toList() ?? []);
    }).where((element) => element > 0).toList();
    
    if (salesTotal.isNotEmpty) {
      setState(() {
        total = calcCore.calcTotal(salesTotal);
      });
      for (var element in data) {
        double elementSalesTotal = calcCore.calcTotal(element.sales!.map((item) => item.total).toList());
        double percentFromTotal = calcCore.calcPercentOfValueFromTotalValue(elementSalesTotal, total);
        if (salesDiagramMap[element.creationDate.month] == null) {
          salesDiagramMap[element.creationDate.month] = 0;
        } 
        salesDiagramMap[element.creationDate.month] = salesDiagramMap[element.creationDate.month]! + percentFromTotal;
      }
    }
  }

  void calcAverageValues() {
    List<double> salesTotal = data.map((element) {
      return calcCore.calcTotal(element.sales?.map((e) => e.total).toList() ?? [0]);
    }).where((element) => element > 0).toList();

    setState(() {
      avarageSales = calcCore.calcAverageValue(salesTotal);
    });

    List<double> salaryTotalList = data.map((element) {
      return calcCore.calcCommonSalary(
        CalcCommonSalaryOptions(
          sales: element.sales?.map((e) => e.total).toList() ?? [], 
          salary: element.salaryInfo.salary, 
          percentFromSales: element.salaryInfo.percentFromSales, 
          ignorePlan: element.salaryInfo.ignorePlan ?? false, 
          isVariablePercent: element.percentChangeConditions != null, 
          plan: element.salaryInfo.plan ?? 0, 
          percentChangeRules: element.percentChangeConditions?.map((item) {
            return PercentChangeRule(
              percentGoal: item.percentGoal, 
              percentChange: item.percentChange, 
              salaryBonus: item.salaryBonus ?? 0
            );
          }).toList() ?? []
        )
      );
    }).toList();

    setState(() {
      totalSalary = calcCore.calcTotal(salaryTotalList);
      avarageSalary = calcCore.calcAverageValue(salaryTotalList);
    });
  }

  void findLastYearData() {
    DateTime lastYearDate = todayLastYear();
    int lastYaer = lastYearDate.year;
    int lastYearMonth = lastYearDate.month;

    int lastYearReportIndex = data.indexWhere((element) {
      int reportLastYear = element.creationDate.year;
      int reportLastMonth = element.creationDate.month;
      if (reportLastYear == lastYaer && reportLastMonth == lastYearMonth) {
        return true;
      }
      return false;
    });

    if (lastYearReportIndex >= 0) {
      ReportInfo lastYearReportData = data[lastYearReportIndex];
      List<ApiSale> lastYearReportDataSales = data[lastYearReportIndex].sales?.toList() ?? [];

      if (lastYearReportDataSales.isNotEmpty) {
        List<ApiSale> salesUntilCurrentDay = lastYearReportDataSales.where((element) {
          return isDateBeforeOrEqual(element.creationDate, lastYearDate);
        }).toList();

        if (salesUntilCurrentDay.isNotEmpty) {
          setState(() {
            lastYearUntilThisDayData = DatedValue(
              date: lastYearDate,
              value: calcCore.calcTotal(salesUntilCurrentDay.map((e) => e.total).toList()),
              additionalValue: calcCore.calcCommonSalary(
                CalcCommonSalaryOptions(
                  sales: salesUntilCurrentDay.map((e) => e.total).toList(), 
                  salary: lastYearReportData.salaryInfo.salary, 
                  percentFromSales: lastYearReportData.salaryInfo.percentFromSales, 
                  ignorePlan: lastYearReportData.salaryInfo.ignorePlan ?? false, 
                  isVariablePercent: lastYearReportData.percentChangeConditions != null, 
                  plan: lastYearReportData.salaryInfo.plan ?? 0, 
                  percentChangeRules: lastYearReportData.percentChangeConditions?.map((item) {
                    return PercentChangeRule(
                      percentGoal: item.percentGoal, 
                      percentChange: item.percentChange, 
                      salaryBonus: item.salaryBonus ?? 0
                    );
                  }).toList() ?? []
                )
              )
            );
          });
        }
      }

      setState(() {
        lastYearData = DatedValue(
          date: lastYearReportData.creationDate, 
          value: calcCore.calcTotal(lastYearReportData.sales?.map((e) => e.total).toList() ?? [0]),
          additionalValue: calcCore.calcCommonSalary(
            CalcCommonSalaryOptions(
              sales: lastYearReportData.sales?.map((e) => e.total).toList() ?? [0], 
              salary: lastYearReportData.salaryInfo.salary, 
              percentFromSales: lastYearReportData.salaryInfo.percentFromSales, 
              ignorePlan: lastYearReportData.salaryInfo.ignorePlan ?? false, 
              isVariablePercent: lastYearReportData.percentChangeConditions != null, 
              plan: lastYearReportData.salaryInfo.plan ?? 0, 
              percentChangeRules: lastYearReportData.percentChangeConditions?.map((item) {
                return PercentChangeRule(
                  percentGoal: item.percentGoal, 
                  percentChange: item.percentChange, 
                  salaryBonus: item.salaryBonus ?? 0
                );
              }).toList() ?? []
            )
          )
        );
      });
    }
  }

  void findRecords() {
    ReportInfo recordSalesReport = data.reduce((curr, next) {
      double currTotal = calcCore.calcTotal(curr.sales?.map((e) => e.total).toList() ?? [0]);
      double nextTotal = calcCore.calcTotal(next.sales?.map((e) => e.total).toList() ?? [0]);
      return currTotal > nextTotal ? curr : next;
    });

    setState(() {
      recordSales = DatedValue(
        id: recordSalesReport.id,
        date: recordSalesReport.creationDate, 
        value: calcCore.calcTotal(recordSalesReport.sales?.map((e) => e.total).toList() ?? [0])
      );
    });

    ReportInfo recordSalaryReport = data.reduce((curr, next) {
      double currTotal = calcCore.calcCommonSalary(
        CalcCommonSalaryOptions(
          sales: curr.sales?.map((e) => e.total).toList() ?? [0], 
          salary: curr.salaryInfo.salary, 
          percentFromSales: curr.salaryInfo.percentFromSales, 
          ignorePlan: curr.salaryInfo.ignorePlan ?? false, 
          isVariablePercent: curr.percentChangeConditions != null, 
          plan: curr.salaryInfo.plan ?? 0, 
          percentChangeRules: curr.percentChangeConditions?.map((item) {
            return PercentChangeRule(
              percentGoal: item.percentGoal, 
              percentChange: item.percentChange, 
              salaryBonus: item.salaryBonus ?? 0
            );
          }).toList() ?? []
        )
      );
      double nextTotal = calcCore.calcCommonSalary(
        CalcCommonSalaryOptions(
          sales: next.sales?.map((e) => e.total).toList() ?? [0], 
          salary: next.salaryInfo.salary, 
          percentFromSales: next.salaryInfo.percentFromSales, 
          ignorePlan: next.salaryInfo.ignorePlan ?? false, 
          isVariablePercent: next.percentChangeConditions != null, 
          plan: next.salaryInfo.plan ?? 0, 
          percentChangeRules: next.percentChangeConditions?.map((item) {
            return PercentChangeRule(
              percentGoal: item.percentGoal, 
              percentChange: item.percentChange, 
              salaryBonus: item.salaryBonus ?? 0
            );
          }).toList() ?? []
        )
      );
      return currTotal > nextTotal ? curr : next;
    });

    setState(() {
      recordSalary = DatedValue(
        id: recordSalaryReport.id,
        date: recordSalaryReport.creationDate, 
        value: calcCore.calcCommonSalary(
          CalcCommonSalaryOptions(
            sales: recordSalaryReport.sales?.map((e) => e.total).toList() ?? [0], 
            salary: recordSalaryReport.salaryInfo.salary, 
            percentFromSales: recordSalaryReport.salaryInfo.percentFromSales, 
            ignorePlan: recordSalaryReport.salaryInfo.ignorePlan ?? false, 
            isVariablePercent: recordSalaryReport.percentChangeConditions != null, 
            plan: recordSalaryReport.salaryInfo.plan ?? 0, 
            percentChangeRules: recordSalaryReport.percentChangeConditions?.map((item) {
              return PercentChangeRule(
                percentGoal: item.percentGoal, 
                percentChange: item.percentChange, 
                salaryBonus: item.salaryBonus ?? 0
              );
            }).toList() ?? []
          )
        )
      );
    });
  }

  void calcStatistics() {
    calcDiagramValues();
    findLastYearData();
    findRecords();
    calcAverageValues();
  }

  void executeInitialData() {
    getAllData().then((_) {
      calcStatistics();
      setState(() {
        isLoading = false;
      });
    });
  }

  Widget totalItems() {
    if (data.isNotEmpty) {
      return Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            AppStrings.finalSalaryShort,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          AnimatedDigitWidget(
            value: totalSalary,
            enableSeparator: true,
            // suffix: shortedTotal[ShortedNumberResultKeys.suffix]!,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 38,
            ),
            duration: const Duration(milliseconds: 500),
          ),
          const SizedBox(height: 10),
          const Text(
            AppStrings.sales,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          AnimatedDigitWidget(
            value: total,
            enableSeparator: true,
            // suffix: shortedTotal[ShortedNumberResultKeys.suffix]!,
            textStyle: const TextStyle(
              color: Colors.black,
              fontSize: 38,
            ),
            duration: const Duration(milliseconds: 500),
          ),
          // const SizedBox(height: 10),
        ],
      );
    }
    return const SizedBox();
  }
  
  Wrap monthColorsBoxes() {
    return Wrap(
      alignment: WrapAlignment.spaceAround,
      runSpacing: 5,
      children: [
            ...monthColorsMap.keys.map((int key) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2.8,
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: monthColorsMap[key],
                        borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      child: SizedBox(
                        width: 55, 
                        height: 30,
                        child: Center(
                          child: Text(
                            salesDiagramMap[key] != null 
                            ? 
                            '${salesDiagramMap[key]!.toStringAsFixed(1)}%'
                            : 
                            '0%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      monthList[key]!.capitalize(),
                      style: const TextStyle(
                        fontSize: 16,
                        // fontWeight: 
                      ),
                    )
                  ],
                )  
              );
            }),
          ],
    );
  }

  Widget recordSalesItem() {
    if (recordSales != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.sales,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          ButtonBox(
            // onPressed: () => {},
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.amount}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(recordSales!.value), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.date}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          monthAndYear(recordSales!.date).capitalize(), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget recordSalaryItem() {
    if (recordSalary != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.finalSalary,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          ButtonBox(
            // onPressed: () => {},
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.amount}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(recordSalary!.value), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.date}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          monthAndYear(recordSalary!.date).capitalize(), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget lastYearDataItem() {
    if (lastYearData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            monthAndYear(lastYearData!.date).capitalize(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          ButtonBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.finalSalary}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(lastYearData?.additionalValue ?? 0), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.sales}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(lastYearData!.value).capitalize(), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget lastYearUntilThisDayDataItem() {
    if (lastYearUntilThisDayData != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.progress} ${monthDateYear(lastYearUntilThisDayData!.date).capitalize()}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 20),
          ButtonBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.finalSalaryShort}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(lastYearUntilThisDayData?.additionalValue ?? 0), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.sales}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(lastYearUntilThisDayData!.value).capitalize(), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  Widget avarageDataItem() {
    if (avarageSalary > 0 && avarageSales > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ButtonBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.finalSalaryShort}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(avarageSalary), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('${AppStrings.sales}:', style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500
                    )),
                    DecoratedBox(
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(3))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          currencyFormat(avarageSales), 
                          style: const TextStyle(
                            color: Colors.white
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();
    executeInitialData();
  }

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: BackAppBar(
          title: Text(
            AppStrings.statistics,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
          )
        ),
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
        padding: const EdgeInsets.all(20),
        children: [
          // DateRangeFilter(
          //   from: dateFrom,
          //   to: dateTo,
          //   onSubmit: getDataByRange,
          //   onReset: () => {},
          // ),
          // const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade200)),
              data.isNotEmpty 
              ?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  AppStrings.commonData,
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
              :
              const SizedBox(),
              Expanded(child: Divider(color: Colors.grey.shade200)),
            ],
          ),
          data.isNotEmpty
          ?
          Column(
            children: [
              totalItems(),
              const SizedBox(height: 20),
              StatisticsCircularDiagram(
                // text: shortenNumber(total),
                size: const Size(300, 300),
                diagramMap: salesDiagramMap, 
                monthColorsMap: monthColorsMap
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: monthColorsBoxes()
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  lastYearData != null && lastYearUntilThisDayData != null
                  ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.lastYear,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  :
                  const SizedBox(),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),
              const SizedBox(height: 20),
              lastYearDataItem(),
              const SizedBox(height: 20),
              lastYearUntilThisDayDataItem(),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  data.isNotEmpty 
                  ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.recordData,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  :
                  const SizedBox(),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),
              const SizedBox(height: 20),
              recordSalesItem(),
              const SizedBox(height: 20),
              recordSalaryItem(),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  data.isNotEmpty 
                  ?
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.avarageData,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                  :
                  const SizedBox(),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),
              const SizedBox(height: 20),
              avarageDataItem()
            ],
          )
          :
          SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: const Center(
              child: Text(AppStrings.dataNotFound, style: TextStyle(fontSize: 20))
            ),
          )
        ],
      )
      ,
    );
  }
}