
import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/widgets/app_text_form_field.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/tools/datetime.dart';
import 'package:test_flutter/widgets/dialog.dart';
import 'package:test_flutter/views/main/entity/entity.dart';

void showSalesDialog(ShowSalesDialogParams params) {
  final appDialog = AppDialog.getInstance();
  bool isLoading = false;

  appDialog.show(
      params.context,
      params.title,
      false,
      Form(
        key: params.formKey,
        child: Column(
          children: [
            AppTextFormField(
              controller: params.totalSalesController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              labelText: AppStrings.total,
              validator: (value) {
                return value != null && params.totalSalesController.doubleValue > 0
                ?
                null
                :
                AppStrings.fieldCannotBeEmpty;
              },
            ),
            AppTextFormField(
              controller: params.cashTaxesController,
              textInputAction: TextInputAction.next,
              labelText: AppStrings.cashTaxes,
              keyboardType: TextInputType.number,
            ),
            AppTextFormField(
              controller: params.nonCashController,
              textInputAction: TextInputAction.next,
              labelText: AppStrings.nonCash,
              keyboardType: TextInputType.number,
            ),
            AppTextFormField(
              controller: params.dateController,
              textInputAction: TextInputAction.next,
              labelText: AppStrings.creationDate,
              keyboardType: TextInputType.number,
              readOnly: true,
              onTap: () => {
                showDatePicker(
                  context: params.context,
                  // locale: const Locale("ru", "RU"),
                  initialDate: DateTime.parse(params.dateController.text),
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2101),
                ).then((selecteDate) => {
                  if (selecteDate != null) {
                    params.dateController.text = selecteDate.toString().split(' ')[0]
                  }
                })
              },
            ),
          ],
        ),
      ),
      [
        TextButton(
          onPressed: () => {
            Navigator.of(params.context).pop()
          },
          child: const Text(AppStrings.cancel)
        ),
        TextButton(
          onPressed: () async => {
            if (!isLoading) {
              isLoading = true,
              await params.onSave?.call(
                Sale(
                  total: params.totalSalesController.doubleValue, 
                  nonCash: params.nonCashController.doubleValue, 
                  cashTaxes: params.cashTaxesController.doubleValue, 
                  creationDate: DateTime.parse(params.dateController.text).add(getCurrentTimeDuration())
              )
              ),
              isLoading = false,
            }
          },
          child: const Text(AppStrings.save)
        )
      ]
  );
}

void showDefaultDialog(ShowDefaultDialogParams params) {
  final appDialog = AppDialog.getInstance();
  bool isLoading = false;

  appDialog.show(
      params.context, 
      params.title, 
      false,
      Form(
        key: params.formKey,
        child: Column(
          children: [
            AppTextFormField(
              controller: params.valueController,
              textInputAction: TextInputAction.next,
              labelText: AppStrings.amount,
              keyboardType: TextInputType.number,
              validator: (value) {
                return value != null && params.valueController.doubleValue > 0
                ?
                null
                :
                AppStrings.fieldCannotBeEmpty;
              },
            ),
            AppTextFormField(
              controller: params.dateController,
              textInputAction: TextInputAction.next,
              labelText: AppStrings.creationDate,
              keyboardType: TextInputType.number,
              readOnly: true,
              onTap: () => {
                showDatePicker(
                  context: params.context,
                  locale: const Locale("ru", "RU"),
                  initialDate: DateTime.parse(params.dateController.text),
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2101),
                ).then((selecteDate) => {
                  if (selecteDate != null) {
                    params.dateController.text = selecteDate.toString().split(' ')[0]
                  }
                })
              },
            ),
          ],
        )
      ), 
      [
        TextButton(
          onPressed: () => Navigator.of(params.context).pop(),
          child: const Text(AppStrings.cancel)
        ),
        TextButton(
          onPressed: () async => {
            if (!isLoading) {
              isLoading = true,
              await params.onSave?.call(
                params.valueController.doubleValue,
                DateTime.parse(params.dateController.text).add(getCurrentTimeDuration())
              ),
              isLoading = false,
            }
          },
          child: const Text(AppStrings.save)
        )
      ]
  );
}