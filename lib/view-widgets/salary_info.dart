
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/tools/number.dart';
import 'package:test_flutter/widgets/app_text_form_field.dart';
import 'package:test_flutter/widgets/button_box.dart';
import 'package:test_flutter/widgets/dialog.dart';

class SalaryInfoWidget extends StatefulWidget {
  final User? userData;
  final Future<void> Function(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions)? onSave;

  const SalaryInfoWidget({
    super.key,
    this.userData,
    this.onSave
  });

  @override
  State<SalaryInfoWidget> createState() => _SalaryInfoState();
}

class _SalaryInfoState extends State<SalaryInfoWidget> {
  late User? userData;
  late Future<void> Function(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions)? onSave;

  final _formKey = GlobalKey<FormState>();
  final _percentChangeConditionsFormKey = GlobalKey<FormState>();

  final appDialog = AppDialog.getInstance();

  late final CurrencyTextFieldController salaryController;
  late final CurrencyTextFieldController percentFromSalesController;
  late final CurrencyTextFieldController planController;

  late final CurrencyTextFieldController planGoalController;
  late final CurrencyTextFieldController percentChangeController;
  late final CurrencyTextFieldController bountyController;

  final List<PercentChangeConditions> _addedConditions = [];
  bool _isVariablePercent = false;
  bool _ignorePlan = false;
  bool _isLoading = false;
  int conditionsKey = 1;

  void disposeControllers() {
    salaryController.dispose();
    percentFromSalesController.dispose();
    planController.dispose();

    planGoalController.dispose();
    percentChangeController.dispose();
    bountyController.dispose();
  }

  void disposePercentChangeControllers() {
    planController.dispose();
  }

  void initializeControllers() {
    salaryController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '',
        thousandSymbol: ' ',
        numberOfDecimals: 0)
      ..addListener(controllerListener);
    percentFromSalesController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '.',
        thousandSymbol: ' ',
        numberOfDecimals: 1)
      ..addListener(controllerListener);
    planController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '',
        thousandSymbol: ' ',
        numberOfDecimals: 0)
      ..addListener(controllerListener);

    planGoalController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '.',
        thousandSymbol: ' ',
        numberOfDecimals: 1)
      ..addListener(percentChangeConditionsLister);
    percentChangeController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '.',
        thousandSymbol: ' ',
        numberOfDecimals: 1)
      ..addListener(percentChangeConditionsLister);
    bountyController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '',
        thousandSymbol: ' ',
        numberOfDecimals: 0)
      ..addListener(percentChangeConditionsLister);
  }

  void initUserData() {    
    String salary = userData?.salaryInfo?.salary != null ? userData!.salaryInfo!.salary.toStringAsFixed(0) : '0';
    String percentFromSales = userData?.salaryInfo?.percentFromSales != null ? userData!.salaryInfo!.percentFromSales.toStringAsFixed(0) : '0';
    String plan = userData?.salaryInfo?.plan != null ? userData!.salaryInfo!.plan!.toStringAsFixed(0) : '0';

    setState(() {
      _isVariablePercent = userData?.percentChangeConditions != null && userData!.percentChangeConditions!.isNotEmpty;
      _ignorePlan = userData?.salaryInfo?.ignorePlan ?? false;
    });

    salaryController.value = TextEditingValue(text: salary);
    percentFromSalesController.value = TextEditingValue(text: percentFromSales);
    planController.value = TextEditingValue(text: plan);

    if (_isVariablePercent) {
      for (var element in userData!.percentChangeConditions!) {
        setState(() {
          _addedConditions.add(element);
        });
      }
    }
  }

  void controllerListener() {
    final salary = salaryController.text;
    final percentFromSales = percentFromSalesController.text;
    final plan = planController.text;

    if (_isVariablePercent) {
      if (salary.isEmpty && plan.isEmpty) {
        return;
      }
    } else {
      if (salary.isEmpty && percentFromSales.isEmpty) {
        return;
      }
    }
  }

  void percentChangeConditionsLister() {
    final planGoal = planGoalController.text;
    final percentChange = percentChangeController.text;
    final bounty = bountyController.text;

    if (planGoal.isEmpty && (percentChange.isEmpty || bounty.isEmpty)) {
      return;
    }
  }

  void onVariablePercentToggle(bool? value) {
    _formKey.currentState?.reset();
    setState(() {
      _isVariablePercent = value!;
    });
  }

  void addConditions() {
    if (_percentChangeConditionsFormKey.currentState?.validate() == true) {
      PercentChangeConditions value = PercentChangeConditions(
          percentGoal: planGoalController.doubleValue,
          percentChange: percentChangeController.doubleValue);
      if (bountyController.text.isNotEmpty) {
        value.salaryBonus = bountyController.doubleValue;
      }
      setState(() {
        _addedConditions.add(value);
      });
      _percentChangeConditionsFormKey.currentState?.reset();
      Navigator.of(context).pop();
    }
  }

  void redactCondition(int index) {
    setState(() {
      _addedConditions[index].percentGoal = planGoalController.doubleValue;
      _addedConditions[index].percentChange = percentChangeController.doubleValue;
      _addedConditions[index].salaryBonus = bountyController.text.isNotEmpty ? bountyController.doubleValue : null;
      Navigator.of(context).pop();
    });
  }

  Future<void> onSaveAction() async {
    if (_formKey.currentState?.validate() == true && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 300));
      await onSave?.call(
        SalaryInfo(
          salary: salaryController.doubleValue, 
          percentFromSales: percentFromSalesController.doubleValue,
          plan: planController.text.isNotEmpty ? planController.doubleValue : null,
          ignorePlan: _ignorePlan
        ),
        _addedConditions.isNotEmpty ? _addedConditions : null
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showDescriptionModal(String title, String subtitle) {
    appDialog.show(
      context,
      title,
      true,
      Text(subtitle),
      null
    );
  }

  void showPercentChangeConditionsModal(PercentChangeConditions? condition, int? conditionIndex) {
    bool redactMode = false;
    if (condition != null) {
      redactMode = true;
      planGoalController.value = TextEditingValue(text: condition.percentGoal.toStringAsFixed(1));
      percentChangeController.value = TextEditingValue(text: condition.percentChange.toStringAsFixed(1));
      if (condition.salaryBonus != null) {
        bountyController.value = TextEditingValue(text: condition.salaryBonus!.toStringAsFixed(0));
      }
    }
    appDialog.show(
        context,
        AppStrings.addConditionds,
        true,
        Column(
              children: [
                Form(
                    key: _percentChangeConditionsFormKey,
                    child: Column(
                      children: [
                        AppTextFormField(
                          controller: planGoalController,
                          labelText: AppStrings.planGoal,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return value!.isEmpty
                                ? AppStrings.fieldCannotBeEmpty
                                : null;
                          },
                        ),
                        AppTextFormField(
                          controller: percentChangeController,
                          labelText: AppStrings.percentChangeOnGoalReached,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return value!.isEmpty
                                ? AppStrings.fieldCannotBeEmpty
                                : null;
                          },
                        ),
                        AppTextFormField(
                          controller: bountyController,
                          labelText: AppStrings.bountyOnGoalReached,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty &&
                                percentChangeController.text.isEmpty) {
                              return AppStrings.fieldCannotBeEmpty;
                            }
                            return null;
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FilledButton(
                              onPressed: () {
                                if (redactMode) {
                                  redactCondition(conditionIndex!);
                                } else {
                                  addConditions();
                                }
                              },
                              child: Text(redactMode ? AppStrings.save : AppStrings.add)
                            )
                          ],
                        ),
                      ],
                    ))
              ],
            ),
            null,
    );
  }

  void onIgnorePlanToggle(bool? value) {
    setState(() {
      _ignorePlan = value!;
    });
  }

  @override
  void initState() {
    super.initState();
    userData = widget.userData;
    onSave = widget.onSave;
    initializeControllers();
    initUserData();
  }

  @override
  void dispose() {
    disposeControllers();
    disposePercentChangeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppTextFormField(
              controller: salaryController,
              labelText: AppStrings.salary,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              validator: (value) {
                    return value!.isEmpty
                        ? AppStrings.fieldCannotBeEmpty
                        : null;
                  },
                ),
                AppTextFormField(
                  controller: percentFromSalesController,
                  labelText: AppStrings.percentFromSales,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (_isVariablePercent) {
                      return null;
                    }
                    return value!.isEmpty
                        ? AppStrings.fieldCannotBeEmpty
                        : null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            // contentPadding: const EdgeInsets.all(5),
                            value: _isVariablePercent,
                            checkColor: Colors.white,
                            activeColor: AppColors.primary,
                            onChanged: onVariablePercentToggle),
                        const Text(
                          AppStrings.variablePercent,
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ],
                    ),
                    TextButton(
                        onPressed: () => showDescriptionModal(AppStrings.variablePercent, AppStrings.variablePercentDescription),
                        child: const Icon(Icons.info)),
                  ],
                ),
                _isVariablePercent
                    ? Column(
                        children: [
                          AppTextFormField(
                            controller: planController,
                            labelText: AppStrings.plan,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return value!.isEmpty
                                  ? AppStrings.fieldCannotBeEmpty
                                  : null;
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                      // contentPadding: const EdgeInsets.all(5),
                                      value: _ignorePlan,
                                      checkColor: Colors.white,
                                      activeColor: AppColors.primary,
                                      onChanged: onIgnorePlanToggle),
                                  const Text(
                                    AppStrings.ignorePlan,
                                    style: TextStyle(fontSize: 15.0),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () => {
                                        showDescriptionModal(
                                          AppStrings.ignorePlan,
                                          AppStrings.ignorePlanDescription
                                        )
                                      },
                                  child: const Icon(Icons.info)),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ..._addedConditions.map((item) {
                                int index = _addedConditions.indexOf(item) + 1;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      '${AppStrings.condition} #$index',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 10),
                                    ButtonBox(
                                      onPressed: () => showPercentChangeConditionsModal(item, index-1),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '${AppStrings.planGoal}: ',
                                                textAlign: TextAlign.left,
                                              ),
                                              DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.all(Radius.circular(3))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text('${item.percentGoal}%', style: const TextStyle(
                                                    color: Colors.white
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '${AppStrings.percentChangeOnGoalReached}: ',
                                                textAlign: TextAlign.left,
                                              ),
                                              DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.all(Radius.circular(3))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text('${item.percentChange}%', style: const TextStyle(
                                                    color: Colors.white
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                '${AppStrings.bountyOnGoalReached}: ',
                                                textAlign: TextAlign.left,
                                              ),
                                              DecoratedBox(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius: BorderRadius.all(Radius.circular(3))
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Text(currencyFormat(item.salaryBonus ?? 0), style: const TextStyle(
                                                    color: Colors.white
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    )
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                          TextButton(
                              onPressed: () => showPercentChangeConditionsModal(null, null),
                              child: const Text(AppStrings.addConditionds)),
                          const SizedBox(height: 20)
                        ],
                      )
                    : const SizedBox(height: 20),
                FilledButton(
                  onPressed: onSaveAction,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(AppStrings.save),
                )
              ],
            ),
    ));
  }
}