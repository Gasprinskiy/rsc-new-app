import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';

CurrencyTextFieldController getDefaultCurrencyTextFieldController(double? value) {
  CurrencyTextFieldController controller = CurrencyTextFieldController(
    currencySymbol: '',
    decimalSymbol: '',
    thousandSymbol: ' ',
    numberOfDecimals: 0,
  );
  if (value != null) {
    controller.value = TextEditingValue(text: value.toStringAsFixed(0));
  }
  return controller;
}

TextEditingController getDateTimeController(DateTime? date) {
  TextEditingController controller = TextEditingController();
  if (date != null) {
    String defaultValue = DateTime.now().toString().split(' ')[0];
    controller.text = defaultValue;
  }
  return controller;
}