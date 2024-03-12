import 'package:currency_textfield/currency_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/helpers/toasts.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';
import 'package:test_flutter/storage/hive/worker/adapters/adapters.dart';

class SalaryInfoRoute extends StatefulWidget {
  final UserState userState;
  const SalaryInfoRoute({super.key, required this.userState});

  @override
  State<SalaryInfoRoute> createState() => _SalaryInfoRouteState();
}

class _SalaryInfoRouteState extends State<SalaryInfoRoute> {
  late UserState userState;

  final _formKey = GlobalKey<FormState>();
  final _percentChangeConditionsFormKey = GlobalKey<FormState>();
  bool _isVariablePercent = false;
  bool _ignorePlan = false;
  bool _isLoading = false;

  FToast fToast = FToast();

  late final CurrencyTextFieldController salaryController;
  late final CurrencyTextFieldController percentFromSalesController;
  late final CurrencyTextFieldController planController;

  late final CurrencyTextFieldController planGoalController;
  late final CurrencyTextFieldController percentChangeController;
  late final CurrencyTextFieldController bountyController;

  final List<PercentChangeConditions> _addedConditions = [];

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

  void onIgnorePlanToggle(bool? value) {
    setState(() {
      _ignorePlan = value!;
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
      Navigator.pop(context);
    }
  }

  void showPercentChangeConditionsModal() {
    showDialog(
        context: context,
        builder: (BuildContext builder) {
          return AlertDialog(
            scrollable: true,
            title: const Text(
              AppStrings.addConditionds,
            ),
            content: Column(
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
                                onPressed: addConditions,
                                child: const Text(AppStrings.add))
                          ],
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
  }

  void showDescriptionModal(String title, String subtitle) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subtitle),
          );
        });
  }

  Future<void> saveSalaryInfo() async {
    fToast.init(context);
    if (_formKey.currentState?.validate() == true && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      User? user = userState.getUserInstanse();
      if (user != null) {
        bool hasPercentConditions = _addedConditions.isNotEmpty;

        user.salaryInfo = SalaryInfo(
            salary: salaryController.doubleValue,
            percentFromSales: percentChangeController.text.isNotEmpty
                ? percentChangeController.doubleValue
                : 0,
            plan: hasPercentConditions ? planController.doubleValue : null);

        if (hasPercentConditions && _isVariablePercent) {
          user.percentChangeConditions = _addedConditions;
        }
        if (_isVariablePercent && !hasPercentConditions) {
          showErrorToast(fToast, AppStrings.percentChangeConditionsEmpty);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        try {
          await userState.updateUserState(user);
        } on HiveError catch (err) {
          print('err: $err');
          showErrorToast(fToast, ErrorStrings.errOnWritingData);
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (!user.personalInfo.isEmailConfirmSciped) {
          CreateSalaryInfoPayload payload = CreateSalaryInfoPayload(
              salaryInfo: UserSalaryInfo(
            salary: salaryController.doubleValue,
            percentFromSales: percentChangeController.text.isNotEmpty
                ? percentChangeController.doubleValue
                : 0,
            plan: hasPercentConditions ? planController.doubleValue : null,
            ignorePlan: _ignorePlan,
          ));

          if (hasPercentConditions) {
            List<UserPercentChangeConditions> conditions = [];
            for (var item in _addedConditions) {
              conditions.add(UserPercentChangeConditions(
                percentChange: item.percentChange,
                percentGoal: item.percentGoal,
                salaryBonus: item.salaryBonus,
              ));
            }
            payload.percentChangeConditions = conditions;
          }

          try {
            await UserApi().createSalaryInfo(payload);
          } on DioException catch (err) {
            showErrorToast(fToast, err.message.toString());
            setState(() {
              _isLoading = false;
            });
            return;
          }
        }
        navigateToCreateLocalAuthRoute();
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToCreateLocalAuthRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/create_local_auth', (Route<dynamic> route) => false);
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
    userState = widget.userState;
  }

  @override
  void dispose() {
    disposeControllers();
    disposePercentChangeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
      const DecorationBox(
        children: [
          Text(AppStrings.typeYourSalaryInfo, style: AppTheme.titleLarge),
          SizedBox(height: 10),
        ],
      ),
      Form(
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
                        onPressed: () => {
                              showDescriptionModal(AppStrings.variablePercent,
                                  AppStrings.variablePercentDescription)
                            },
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
                                            AppStrings.ignorePlanDescription)
                                      },
                                  child: const Icon(Icons.info)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ..._addedConditions.map((item) {
                                int index = _addedConditions.indexOf(item) + 1;
                                return Card(
                                    margin: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 5,
                                            bottom: 5),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${AppStrings.condition} #$index',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Text(
                                                  '${AppStrings.planGoal}: ',
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  '${item.percentGoal};',
                                                  style: const TextStyle(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Text(
                                                  '${AppStrings.percentChangeOnGoalReached}: ',
                                                  textAlign: TextAlign.left,
                                                ),
                                                Text(
                                                  '${item.percentChange};',
                                                  style: const TextStyle(
                                                      color: AppColors.primary,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ],
                                        )));
                              }).toList(),
                            ],
                          ),
                          TextButton(
                              onPressed: showPercentChangeConditionsModal,
                              child: const Text(AppStrings.addConditionds)),
                          const SizedBox(height: 20)
                        ],
                      )
                    : const SizedBox(height: 20),
                FilledButton(
                  onPressed: saveSalaryInfo,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(AppStrings.save),
                )
              ],
            ),
          )),
      // _isVariablePercent
      //     ? Form(
      //         key: _percentChangeConditionsFormKey,
      //         child: Column(children: [
      //           const SizedBox(height: 15),
      //           DecoratedBox(
      //             decoration: const BoxDecoration(color: AppColors.primary),
      //             child: Column(
      //               children: [
      //                 Padding(
      //                   padding: const EdgeInsets.only(
      //                       left: 20, right: 20, bottom: 5, top: 5),
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     mainAxisSize: MainAxisSize.max,
      //                     children: [
      //                       const Text(
      //                         AppStrings.addConditionds,
      //                         style: TextStyle(
      //                             fontWeight: FontWeight.w500,
      //                             fontSize: 16,
      //                             color: Colors.white),
      //                       ),
      //                       FilledButton(
      //                           onPressed: () => {},
      //                           style: ButtonStyle(
      //                               backgroundColor:
      //                                   MaterialStateProperty.all<Color>(
      //                                       Colors.white)),
      //                           child: const Icon(
      //                             Icons.add,
      //                             color: AppColors.primary,
      //                           ))
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           )
      //         ]),
      //       )
      //     : const Padding(padding: EdgeInsets.all(0))
    ]));
  }
}
