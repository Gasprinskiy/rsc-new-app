import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/state/entity/entity.dart';
import 'package:rsc/views/main/children/accounting/children/archive/archive.dart';
import 'package:rsc/views/main/children/accounting/children/statistics.dart';
import 'package:rsc/widgets/app_text_form_field.dart';
import 'package:rsc/core/accounting_calculations.dart';
import 'package:rsc/core/entity.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/widgets/button_box.dart';
import 'package:rsc/widgets/dialog.dart';
import 'package:rsc/widgets/toast.dart';
import 'package:rsc/views/main/children/accounting/children/details/details.dart';
import 'package:rsc/views/main/entity/entity.dart';
import 'package:rsc/views/main/helpers/dialog.dart';
import 'package:rsc/views/main/helpers/input_controllers.dart';
import 'package:rsc/views/main/widgets/prepayments_box.dart';
import 'package:rsc/views/main/widgets/sales_box.dart';
import 'package:rsc/views/main/widgets/tips_box.dart';
import 'package:rsc/views/main/widgets/common_salary_box.dart';

class TestClass {
  double value;
  DateTime creationDate;

  TestClass({required this.value, required this.creationDate});
}

List<TestClass> testList = [
  TestClass(
    creationDate: DateTime(2024, 1, 0, 0),
    value: 20000000
  ),
  TestClass(
    creationDate: DateTime(2024, 2, 0, 0),
    value: 10000000
  ),
  TestClass(
    creationDate: DateTime(2024, 3, 0, 0),
    value: 30000000
  ),
];

final Map<int, double> map = {};

void calcPercentsByList() {
  final calcCore = AccountingCalculations.getInstance();
  double total = calcCore.calcTotal(testList.map((e) => e.value).toList());
  for (var element in testList) {
    double percentFromTotal = calcCore.calcPercentOfValueFromTotalValue(total, element.value);
    map[element.creationDate.month] = 0;
    map[element.creationDate.month] = map[element.creationDate.month]! + percentFromTotal;
  }
}


class Accounting extends StatefulWidget {
  const Accounting({super.key});

  @override
  State<Accounting> createState() => _AccountingState();
}

class _AccountingState extends State<Accounting> {
  final _createNewReportFormKey = GlobalKey<FormState>();
  final _addUpdateSaleFormKey = GlobalKey<FormState>();
  final _addUpdateTipsAndPrepaymentsFormKey = GlobalKey<FormState>();

  final calcCore = AccountingCalculations.getInstance();
  final userState = UserState.getInstance();
  final accountingState = AccountingState.getInstance();
  final appToast = AppToast.getInstance();
  final appDialog = AppDialog.getInstance();

  late final TextEditingController reportCrationDateController;
  late final CurrencyTextFieldController totalSalesController;
  late final CurrencyTextFieldController cashTaxesController;
  late final CurrencyTextFieldController nonCashController;
  late final CurrencyTextFieldController defaultCurrencyController;

  List<Sale>? _sales;
  List<Tip>? _tips;
  List<Prepayment>? _prepayments;
  double _commonSalary = 0;
  bool _isReportStarted = false;
  bool _showAddActions = false;
  bool _addOrUpdateInProgress = false;
  String _prepaymentsKey = 'prepayments-0';
  String _salesKey = 'sales-0';
  String _tipsKey = 'tips-0';
  int _reportKey = 1;
  String defaultValue = DateTime.now().toString().split(' ')[0];

  void initializeControllers() {
    // defaultValue = accountingState.currentAccountingCreationDate != null ? accountingState.currentAccountingCreationDate.toString().split(' ')[0] : DateTime.now().toString().split(' ')[0];
    reportCrationDateController = TextEditingController();
    reportCrationDateController.text = defaultValue;
    totalSalesController = getDefaultCurrencyTextFieldController(null);
    cashTaxesController = getDefaultCurrencyTextFieldController(null);
    nonCashController = getDefaultCurrencyTextFieldController(null);
    defaultCurrencyController = getDefaultCurrencyTextFieldController(null);
  }

  void disposeControllers() {
    reportCrationDateController.dispose();
    totalSalesController.dispose();
    cashTaxesController.dispose();
    nonCashController.dispose();
    defaultCurrencyController.dispose();
  }

  void resetDefaultControllers() {
    reportCrationDateController.value = TextEditingValue(text: defaultValue);
    defaultCurrencyController.value = const TextEditingValue(text: '0');
  }

  void resetSaleFormController() {
    reportCrationDateController.value = TextEditingValue(text: defaultValue);
    totalSalesController.value = const TextEditingValue(text: '0');
    cashTaxesController.value = const TextEditingValue(text: '0');
    nonCashController.value = const TextEditingValue(text: '0');
  }

  void createReport() {
    appToast.init(context);
    setState(() {
      _addOrUpdateInProgress = true;
    });
    accountingState.addAndSyncReport(DateTime.parse(reportCrationDateController.text))
    .then((_) => {
      setState(() {
        _isReportStarted = true;
        _addOrUpdateInProgress = false;
      }),
      setReportData(),
      Navigator.of(context).pop()
    });
  }

  void addSaleAction() {
    appToast.init(context);
    showSalesDialog(
      ShowSalesDialogParams(
        context: context, 
        formKey: _addUpdateSaleFormKey, 
        title: '${AppStrings.add} ${AppStrings.saleAddRedact}', 
        totalSalesController: totalSalesController, 
        cashTaxesController: cashTaxesController,
        nonCashController: nonCashController, 
        dateController: reportCrationDateController,
        onSave: addSale
      )
    );
  }

  void addPrepaymentAction() {
    appToast.init(context);
    showDefaultDialog(
      ShowDefaultDialogParams(
        context: context, 
        formKey: _addUpdateTipsAndPrepaymentsFormKey, 
        title: '${AppStrings.add} ${AppStrings.prepaymentAddRedact}', 
        valueController: defaultCurrencyController, 
        dateController: reportCrationDateController,
        onSave: addPrepayment
      )
    );
  }

  void addTipsAction() {
    appToast.init(context);
    showDefaultDialog(
      ShowDefaultDialogParams(
        context: context, 
        formKey: _addUpdateTipsAndPrepaymentsFormKey, 
        title: '${AppStrings.add} ${AppStrings.tipAddRedact}', 
        valueController: defaultCurrencyController, 
        dateController: reportCrationDateController,
        onSave: addTip
      )
    );
  }

  Future<void> addSale(Sale payload, _) async {
    if (_addUpdateSaleFormKey.currentState?.validate() == true) {
      setState(() {
        if (_sales != null) {
          _sales = [..._sales!, payload];
        } else {
          _sales = [payload];
        }
        Navigator.of(context).pop();
        resetSaleFormController();
      });
      calcCommonSalary();
      updateSalesKey();
      await accountingState.addAndSyncSale(payload);
    }
  }

  Future<void> addPrepayment(double value, DateTime date) async {
    if (_addUpdateTipsAndPrepaymentsFormKey.currentState?.validate() == true) {
      Prepayment payload = Prepayment(
        value: value,
        creationDate: date
      );
      setState(() {
        if (_prepayments != null) {
          _prepayments = [..._prepayments!, payload];
        } else {
          _prepayments = [payload];
        }
        Navigator.of(context).pop();
        resetDefaultControllers();
      });
      updatePrepaymentsKey();
      await accountingState.addAndSyncPrepayment(payload);
    }
  }

  Future<void> addTip(double value, DateTime date) async {
    if (_addUpdateTipsAndPrepaymentsFormKey.currentState?.validate() == true) {
      Tip payload = Tip(
        value: value,
        creationDate: date
      );
      setState(() {
        if (_tips != null) {
          _tips = [..._tips!, payload];
        } else {
          _tips = [payload];
        }
        Navigator.of(context).pop();
        resetDefaultControllers();
      });
      updateTipsKey();
      await accountingState.addAndSyncTip(payload);
    }
  }

  void updatePrepaymentsKey() {
    List<String> key = _prepaymentsKey.split('-');
    int keynum = int.parse(key[1]) + 1;
    setState(() {
      _prepaymentsKey = '${key[0]}-$keynum';
    });
  }

  void updateSalesKey() {
    List<String> key = _salesKey.split('-');
    int keynum = int.parse(key[1]) + 1;
    setState(() {
      _salesKey = '${key[0]}-$keynum';
    });
  }

  void updateTipsKey() {
    List<String> key = _tipsKey.split('-');
    int keynum = int.parse(key[1]) + 1;
    setState(() {
      _tipsKey = '${key[0]}-$keynum';
    });
  }

  void updateReportKey() {
    setState(() {
      _reportKey += 1;
    });
  }

  void toggleShowAddActions() {
    setState(() {
      _showAddActions = !_showAddActions;
    });
  }

  Future<void> setReportData() async {
    List<Sale>? salesResult = await accountingState.getSaleList();
    List<Prepayment>? prepaymentResult = await accountingState.getPrepaymentList();
    List<Tip>? tipResult = await accountingState.getTipList();
  
    setState(() {
      _sales = salesResult;
      _prepayments = prepaymentResult;
      _tips = tipResult;
    });

    calcCommonSalary();
    updateReportKey();
    updatePrepaymentsKey();
    updateSalesKey();
    updateTipsKey();
  }

  void calcCommonSalary() {
    List<PercentChangeRule>? percentChangeRules = userState.user?.percentChangeConditions?.map((item) {
      return PercentChangeRule(
        percentGoal: item.percentGoal, 
        percentChange: item.percentChange, 
        salaryBonus: item.salaryBonus ?? 0
      );
    }).toList();
    setState(() {
      _commonSalary = calcCore.calcCommonSalary(
        CalcCommonSalaryOptions(
          sales: _sales != null ? _sales!.map((item) => item.total).toList() : [], 
          salary: userState.user?.salaryInfo?.salary ?? 0, 
          percentFromSales: userState.user?.salaryInfo?.percentFromSales ?? 0,
          ignorePlan: userState.user?.salaryInfo?.ignorePlan ?? false, 
          isVariablePercent: userState.user?.percentChangeConditions != null, 
          plan: userState.user?.salaryInfo?.plan ?? 0, 
          percentChangeRules: percentChangeRules ?? []
        )
      );
    });
  }

  void navigateToDetailsScreenByType(DetailsScreenType type) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return Details(type: type);
      }
    )).then((value) {
      accountingState.updatedValuesCount.forEach((key, value) async {
        if (key == UpdatedValuesType.sale && value > 0) {
          List<Sale>? result = await accountingState.getSaleList();
          if (result != null) {
            setState(() {
              _sales = result;
              updateSalesKey();
            });
          }
        }

        if (key == UpdatedValuesType.prepayment && value > 0) {
          List<Prepayment>? result = await accountingState.getPrepaymentList();
          if (result != null) {
            setState(() {
              _prepayments = result;
              updatePrepaymentsKey();
            });
          }
        }

        if (key == UpdatedValuesType.tip && value > 0) {
          List<Tip>? result = await accountingState.getTipList();
          if (result != null) {
            setState(() {
              _tips = result;
              updateTipsKey();
            });
          }
        }
      });
    });
  }

  void navigateToArchive() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return const ArchiveData();
      }
    ));
  }

  void navigateToStatistics() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return const ReportStatistics();
      }
    ));
  }

  void showStartReportConditions() {
    appDialog.show(
      context,
      AppStrings.startNewReport,
      false,
      Form(
        key: _createNewReportFormKey,
        child: AppTextFormField(
          controller: reportCrationDateController,
          textInputAction: TextInputAction.next,
          labelText: AppStrings.creationDate,
          keyboardType: TextInputType.datetime,
          readOnly: true,
          onTap: () => {
            showDatePicker(
              context: context,
              locale: const Locale("ru", "RU"),
              initialDate: DateTime.parse(reportCrationDateController.text),
              firstDate: DateTime(2000), 
              lastDate: DateTime(2101),
            ).then((selecteDate) => {
              if (selecteDate != null) {
                reportCrationDateController.text = selecteDate.toString().split(' ')[0]
              }
            })
          },
        ),
      ),
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text(AppStrings.cancel)
        ),
        TextButton(
          onPressed: createReport,
          child: _addOrUpdateInProgress 
          ? 
          const CircularProgressIndicator(
            color: AppColors.primary,
          )
          :
          const Text(AppStrings.start)
        )
      ]
    );
  }

  void showArchivateReportDialog() {
    appDialog.show(
      context,
      AppStrings.areYouSureYouWantArhivateReport,
      false,
      null,
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text(AppStrings.no)
        ),
        TextButton(
          onPressed: archivateReportAction,
          child: const Text(AppStrings.yes)
        )
      ]
    );
  }

  Future<void> archivateReportAction() async {
    appToast.init(context);

    await accountingState.archivateCurrentReport();
    await setReportData();
    calcCommonSalary();
    setState(() {
      _isReportStarted = false;
      Navigator.of(context).pop();
    });
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    setReportData();
    calcPercentsByList();
    _isReportStarted = accountingState.currentAccountingCreationDate != null;
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: 
      _isReportStarted
      ?
      Stack(
        children: [
          AnimatedPositioned(
            // right: _showAddActions ? 65 : 0,
            right: _showAddActions ? 0 : 10,
            bottom: _showAddActions ? 65 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FloatingActionButton(
              heroTag: 'sales',
              elevation: 2,
              onPressed: addSaleAction, 
              backgroundColor: AppColors.primary500,
              mini: true,
              tooltip: AppStrings.sale,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.sell_rounded,
                color: Colors.white,
                size: 20,
              ),
            )
          ),
          AnimatedPositioned(
            right: _showAddActions ? 65 : 0,
            bottom: 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FloatingActionButton(
              heroTag: 'tips',
              elevation: 2,
              onPressed: addTipsAction, 
              backgroundColor: AppColors.primary500,
              mini: true,
              tooltip: AppStrings.tip,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.payments_outlined,
                color: Colors.white,
                size: 20,
              ),
            )
          ),
          AnimatedPositioned(
            right: _showAddActions ? 45 : 0,
            bottom: _showAddActions ? 45 : 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FloatingActionButton(
              heroTag: 'prepayment',
              elevation: 2,
              onPressed: addPrepaymentAction,
              backgroundColor: AppColors.primary500,
              mini: true,
              tooltip: AppStrings.prepayment,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.money_off_csred,
                color: Colors.white,
                size: 20,
              ),
            )
          ),
          Positioned(
            left: 32.5,
            bottom: 0,
            child: FloatingActionButton(
              heroTag: 'archivate',
              elevation: 2,
              onPressed: showArchivateReportDialog, 
              backgroundColor: AppColors.warn,
              tooltip: AppStrings.archivate,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.archive_outlined,
                color: Colors.white,
              ),
            )
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: FloatingActionButton(
              heroTag: 'add-toggle',
              onPressed: toggleShowAddActions, 
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      )
      : null,
      body: _isReportStarted
      ? 
      ListView(
        children: [
          CommonSalaryBox(
            key: Key(_commonSalary.toString()),
            commonSalary: _commonSalary
          ),
          Padding(
            key: ValueKey(_reportKey),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ButtonBox(
                          onPressed: navigateToArchive,
                          child: const Column(
                            children: [
                              Icon(Icons.archive_outlined, size: 30),
                              SizedBox(height: 10),
                              Text(AppStrings.archive)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ButtonBox(
                          onPressed: navigateToStatistics,
                          child: const Column(
                            children: [
                              Icon(Icons.donut_large_rounded, size: 30),
                              SizedBox(height: 10),
                              Text(AppStrings.statistics)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  key: ValueKey(_salesKey),
                  child: SalesBox(
                    sales: _sales ?? [],
                    onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.sales),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  key: ValueKey(_prepaymentsKey),
                  child: PrepaymentsBox(
                    key: ValueKey(_prepaymentsKey),
                    prepayments: _prepayments ?? [],
                    onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.prepayments),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  key: ValueKey(_tipsKey),
                  child: TipsBox(
                    key: ValueKey(_tipsKey),
                    tips: _tips ?? [],
                    onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.tips),
                  )
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 60, 0, 0))
              ],
            )
          ),
        ],
      )
      :
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ButtonBox(
            onPressed: showStartReportConditions,
            child: const Text(AppStrings.startNewReport),
          ),
        ),
      )
      ,
    );
  }
}