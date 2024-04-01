import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/core/entity.dart';
import 'package:test_flutter/state/accounting.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/utils/widgets/dialog.dart';
import 'package:test_flutter/utils/widgets/toast.dart';
import 'package:test_flutter/views/main/children/accounting/children/details/details.dart';
import 'package:test_flutter/views/main/entity/entity.dart';
import 'package:test_flutter/views/main/helpers/dialog.dart';
import 'package:test_flutter/views/main/helpers/input_controllers.dart';
import 'package:test_flutter/views/main/widgets/prepayments_box.dart';
import 'package:test_flutter/views/main/widgets/sales_box.dart';
import 'package:test_flutter/views/main/widgets/tips_box.dart';
import 'package:test_flutter/views/main/widgets/common_salary_box.dart';

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
  String _prepaymentsKey = 'prepayments';
  String _salesKey = 'sales';
  String _tipsKey = 'tips';


  void initializeControllers() {
    String defaultValue = DateTime.now().toString().split(' ')[0];
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
    String defaultValue = DateTime.now().toString().split(' ')[0];
    reportCrationDateController.value = TextEditingValue(text: defaultValue);;
    defaultCurrencyController.value = const TextEditingValue(text: '0');
  }

  void resetSaleFormController() {
    String defaultValue = DateTime.now().toString().split(' ')[0];
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

  Future<void> addSale(Sale payload) async {
    if (_addUpdateSaleFormKey.currentState?.validate() == true) {
      await accountingState.addAndSyncSale(payload);
      setState(() {
        _sales?.add(payload);
        updateSalesKey(payload.id);
        Navigator.of(context).pop();
        resetSaleFormController();
      });
      calcCommonSalary();
    }
  }

  Future<void> addPrepayment(double value, DateTime date) async {
    if (_addUpdateTipsAndPrepaymentsFormKey.currentState?.validate() == true) {
      Prepayment payload = Prepayment(
        value: value,
        creationDate: date
      );
      await accountingState.addAndSyncPrepayment(payload);
      setState(() {
        _prepayments?.add(payload);
        updatePrepaymentsKey(payload.id);
        Navigator.of(context).pop();
        resetDefaultControllers();
      });
    }
  }

  Future<void> addTip(double value, DateTime date) async {
    if (_addUpdateTipsAndPrepaymentsFormKey.currentState?.validate() == true) {
      Tip payload = Tip(
        value: value,
        creationDate: date
      );
      await accountingState.addAndSyncTip(payload);
      setState(() {
        _tips?.add(payload);
        updateTipsKey(payload.id);
        Navigator.of(context).pop();
        resetDefaultControllers();
      });
    }
  }

  void updatePrepaymentsKey(String? uniqValue) {
    setState(() {
      _prepaymentsKey += _prepayments != null ? '${_prepayments!.length}${uniqValue ?? 0}' : '${uniqValue ?? 0}';
    });
  }

  void updateSalesKey(String? uniqValue) {
    setState(() {
      _salesKey += _sales != null ? '${_sales!.length}${uniqValue ?? 0}' : '${uniqValue ?? 0}';
    });
  }

  void updateTipsKey(String? uniqValue) {
    setState(() {
      _tipsKey += _tips != null ? '${_tips!.length}${uniqValue ?? 0}' : '${uniqValue ?? 0}';
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
    updatePrepaymentsKey(null);
    updateSalesKey(null);
    updateTipsKey(null);
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

  @override
  void initState() {
    super.initState();
    initializeControllers();
    setReportData();
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
            right: _showAddActions ? 65 : 0,
            bottom: 0,
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
            right: _showAddActions ? 45 : 0,
            bottom: _showAddActions ? 45 : 0,
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
            right: _showAddActions ? 0 : 10,
            bottom: _showAddActions ? 65 : 0,
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
          )
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
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SalesBox(
                  key: ValueKey(_salesKey),
                  sales: _sales ?? [],
                  onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.sales),
                ),
                const SizedBox(height: 20),
                PrepaymentsBox(
                  key: ValueKey(_prepaymentsKey),
                  prepayments: _prepayments ?? [],
                  onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.prepayments),
                ),
                const SizedBox(height: 20),
                TipsBox(
                  key: ValueKey(_tipsKey),
                  tips: _tips ?? [],
                  onBoxClick: () => navigateToDetailsScreenByType(DetailsScreenType.tips),
                )
              ],
            )
          ),
        ],
      )
      :
      Center(
        child: FilledButton(
          onPressed: showStartReportConditions,
          child: const Text(AppStrings.startNewReport),
        ),
      )
      ,
    );
  }
}