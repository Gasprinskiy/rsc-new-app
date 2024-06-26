import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';

enum DetailsScreenType {
  sales,
  prepayments,
  tips
}

enum UsetActionsScreenType {
  changePassword,
  salaryInfo
}

class ShowDialogParams {
  BuildContext context;
  GlobalKey<FormState> formKey;
  String title;

  ShowDialogParams({
    required this.context, 
    required this.formKey,
    required this.title
  });
}

class ShowDefaultDialogParams extends ShowDialogParams {
  CurrencyTextFieldController valueController;
  TextEditingController dateController;
  Future<void> Function(double value, DateTime date)? onSave;

  ShowDefaultDialogParams({
    required super.context,
    required super.formKey,
    required super.title,
    required this.valueController,
    required this.dateController,
    this.onSave
  });
}

class ShowSalesDialogParams extends ShowDialogParams {
  CurrencyTextFieldController totalSalesController;
  CurrencyTextFieldController cashTaxesController;
  CurrencyTextFieldController nonCashController;
  TextEditingController dateController;
  Sale? redactingSale;
  Future<void> Function(Sale payload, String? id)? onSave;

  ShowSalesDialogParams({
    required super.context,
    required super.formKey,
    required super.title,
    required this.totalSalesController,
    required this.cashTaxesController,
    required this.nonCashController,
    required this.dateController,
    this.redactingSale,
    this.onSave
  });
}

class DatedValue {
  int? id;
  DateTime date;
  double value;
  double? additionalValue; 

  DatedValue({
    this.id,
    required this.date,
    required this.value,
    this.additionalValue,
  });
}