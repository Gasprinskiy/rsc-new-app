import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';

class SalaryInfoRoute extends StatefulWidget {
  const SalaryInfoRoute({super.key});

  @override
  State<SalaryInfoRoute> createState() => _SalaryInfoRouteState();
}

class _SalaryInfoRouteState extends State<SalaryInfoRoute> {
  final _formKey = GlobalKey<FormState>();

  late final CurrencyTextFieldController salaryController;
  late final CurrencyTextFieldController percentFromSalesController;

  void disposeControllers() {
    salaryController.dispose();
    percentFromSalesController.dispose();
  }

  void initializeControllers() {
    salaryController = CurrencyTextFieldController(
        currencySymbol: '',
        decimalSymbol: '',
        thousandSymbol: ' ',
        numberOfDecimals: 0)
      ..addListener(controllerListener);
    percentFromSalesController = CurrencyTextFieldController()
      ..addListener(controllerListener);
  }

  void controllerListener() {
    final salary = salaryController.text;
    final percentFromSales = percentFromSalesController.text;

    if (salary.isEmpty && percentFromSales.isEmpty) {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void dispose() {
    disposeControllers();
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
                        ? AppStrings.pleaseEnterYourName
                        : null;
                  },
                ),
              ],
            ),
          ))
    ]));
  }
}
