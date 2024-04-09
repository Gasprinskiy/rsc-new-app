
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/widgets/app_text_form_field.dart';
import 'package:rsc/widgets/button_box.dart';

class DateRangeFilter extends StatefulWidget {
  final DateTime? from;
  final DateTime? to;
  final void Function(DateTime from, DateTime to) onSubmit;
  final void Function()? onReset;

  const DateRangeFilter({
    super.key,
    this.from,
    this.to,
    required this.onSubmit,
    this.onReset
  });

  @override
  State<DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  late DateTime? from;
  late DateTime? to;
  late void Function(DateTime from, DateTime to) onSubmit;
  late void Function()? onReset;

  DateTime? selectedFrom;
  DateTime? selectedTo;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController fromController;
  late TextEditingController toController;

  void initControllers() {
    fromController = TextEditingController();
    toController = TextEditingController();
    if (from != null) {
      fromController.text = from.toString().split(' ')[0];
      selectedFrom = from;
    }
    if (to != null) {
      toController.text = to.toString().split(' ')[0];
      selectedTo = to;
    }
  }

  void disposeControllers() {
    fromController.dispose();
    toController.dispose();
  }

  void onSubmitAction() {
    if (_formKey.currentState?.validate() == true) {
      onSubmit.call(
        DateTime.parse(fromController.text),
        DateTime.parse(toController.text)
      );
    }
  }

  void onResetAction() {
    _formKey.currentState?.reset();
    if (from != null) {
      fromController.text = from.toString().split(' ')[0];
      selectedFrom = from;
    } else {
      fromController.value = const TextEditingValue(text: '');
      selectedFrom = null;
    }
    if (to != null) {
      toController.text = to.toString().split(' ')[0];
      selectedTo = to;
    } else {
      toController.value = const TextEditingValue(text: '');
      selectedTo = null;
    }
    onReset?.call();
  }

  @override
  void initState() {
    super.initState();
    onSubmit = widget.onSubmit;
    onReset = widget.onReset;
    from = widget.from;
    to = widget.to;
    initControllers();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2 - 20,
                child: AppTextFormField(
                  controller: fromController,
                  textInputAction: TextInputAction.next,
                  labelText: AppStrings.from,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    return value != null && fromController.text.isNotEmpty
                    ?
                    null
                    :
                    AppStrings.fieldCannotBeEmpty;
                  },
                  readOnly: true,
                  onTap: () => {
                    showDatePicker(
                      context: context,
                      locale: const Locale("ru", "RU"),
                      initialDate: selectedFrom,
                      firstDate: DateTime(2000), 
                      lastDate:  DateTime(2101),
                    ).then((selecteDate) => {
                      if (selecteDate != null) {
                        fromController.text = selecteDate.toString().split(' ')[0],
                        selectedFrom = selecteDate
                      }
                    })
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2 - 20,
                child: AppTextFormField(
                  controller: toController,
                  textInputAction: TextInputAction.next,
                  labelText: AppStrings.to,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  validator: (value) {
                    return value != null && toController.text.isNotEmpty
                    ?
                    null
                    :
                    AppStrings.fieldCannotBeEmpty;
                  },
                  onTap: () => {
                    showDatePicker(
                      context: context,
                      locale: const Locale("ru", "RU"),
                      initialDate: selectedTo,
                      firstDate: DateTime(2000), 
                      lastDate: DateTime(2101),
                    ).then((selecteDate) => {
                      if (selecteDate != null) {
                        toController.text = selecteDate.toString().split(' ')[0],
                        selectedTo = selecteDate
                      }
                    })
                  },
                ),
              ),
            ],
          ),
          SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: onSubmitAction,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )
                        ),
                        backgroundColor: MaterialStateProperty.all(AppColors.primaryTransparent)
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.apply, 
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center
                          ),
                          // Icon(Icons.arrow_forward_ios),
                        ],
                      )
                    ),
                    TextButton(
                      onPressed: onResetAction,
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          )
                        ),
                        // backgroundColor: MaterialStateProperty.all(AppColors.warnTransparent),
                        overlayColor: MaterialStateProperty.all(AppColors.warnTransparent)
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.reset, style: TextStyle(fontSize: 18, color: AppColors.warn)),
                          // Icon(Icons.settings_backup_restore_rounded, color: AppColors.warn),
                        ],
                      )
                    ),
                  ],
                )
              ),
        ],
      ) 
    );
  }
}