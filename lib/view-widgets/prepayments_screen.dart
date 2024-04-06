
import 'package:currency_textfield/currency_textfield.dart';
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/views/main/entity/entity.dart';
import 'package:rsc/views/main/helpers/dialog.dart';
import 'package:rsc/views/main/helpers/input_controllers.dart';
import 'package:rsc/widgets/button_box.dart';
import 'package:rsc/widgets/date_range_filter.dart';

class PrepaymentsScreen extends StatefulWidget {
  final List<Prepayment> prepayments;
  final Future<void> Function(Prepayment prepayment)? onRedact;
  const PrepaymentsScreen({
    super.key,
    required this.prepayments,
    this.onRedact
  });

  @override
  State<PrepaymentsScreen> createState() => _PrepaymentsScreenState();
}

class _PrepaymentsScreenState extends State<PrepaymentsScreen> {
  late List<Prepayment> prepayments;
  late Future<void> Function(Prepayment prepayment)? onRedact;
  final updateFormKey = GlobalKey<FormState>();

  List<Prepayment> innerList = [];
  int updateKey = 1;

  late DateTime dateFrom;
  late DateTime dateTo;

  late final TextEditingController creationDateController;
  late final CurrencyTextFieldController amountController;

  void initInnerListState() {
    if (prepayments.isNotEmpty) {
      setState(() {
        dateFrom = prepayments.reduce((current, next) => current.creationDate.isBefore(next.creationDate) ? current : next).creationDate;
        dateTo = prepayments.reduce((current, next) => current.creationDate.isAfter(next.creationDate) ? current : next).creationDate;
        innerList = prepayments.toList();
        innerList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      });
    }
  }

  void initializeControllers() {
    creationDateController = TextEditingController();
    amountController = getDefaultCurrencyTextFieldController(null);
  }

  void disposeControllers() {
    creationDateController.dispose();
    amountController.dispose();
  }

  void filterListByDateRange(DateTime from, DateTime to) {
    bool fromIsSame = getDurationIgnoredDate(from).isAtSameMomentAs(getDurationIgnoredDate(dateFrom));
    bool toIsSame =  getDurationIgnoredDate(to).isAtSameMomentAs(getDurationIgnoredDate(dateTo));
    if (!fromIsSame || !toIsSame) { 
      setState(() {
        innerList = prepayments.where((element) => (element.creationDate.isAfter(from) && element.creationDate.isBefore(to))).toList();
        innerList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      });
    }
  }

  void onRedactAction(Prepayment prepayment) {
    creationDateController.text = prepayment.creationDate.toString().split(' ')[0];
    amountController.value = TextEditingValue(text: prepayment.value.toStringAsFixed(0));

    showDefaultDialog(
      ShowDefaultDialogParams(
        context: context, 
        formKey: updateFormKey, 
        title: '${AppStrings.redact} ${AppStrings.prepaymentAddRedact}', 
        valueController: amountController,
        dateController: creationDateController,
        onSave: (value, date) => onRedactSave(value, date, prepayment)
      )
    );
  }

  Future<void> onRedactSave(double value, DateTime date, Prepayment source) async {    
      Prepayment newValue = Prepayment(
        value: value, 
        creationDate: date,
        cloudId: source.cloudId
      );
      int updatedIndex = innerList.indexWhere((item) => item.id == source.id);
      if (updatedIndex >= 0 && !innerList[updatedIndex].isEqual(newValue)) {
        setState(() {
          innerList[updatedIndex].value = newValue.value;
          innerList[updatedIndex].creationDate = newValue.creationDate;
          updateKey += 1;
          Navigator.of(context).pop();
        });
        await onRedact?.call(innerList[updatedIndex]);
      }
  }

  @override
  void initState() {
    super.initState();
    prepayments = widget.prepayments;
    onRedact = widget.onRedact;
    initInnerListState();
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
      key: widget.key,
      body:
      prepayments.isNotEmpty
      ?
      ListView(
        key: ValueKey(updateKey),
        padding: const EdgeInsets.all(20),
        children: [
          DateRangeFilter(
            from: dateFrom,
            to: dateTo,
            onSubmit: filterListByDateRange,
            onReset: initInnerListState,
          ),
          const Divider(height: 20),
          innerList.isNotEmpty
          ?
          Column(
            children: [
              ...innerList.map((item) {
                return Column(
                  children: [
                    ButtonBox(
                      onPressed: onRedact != null ? () => onRedactAction(item) : null,
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
                                    child: Text(currencyFormat(item.value), style: const TextStyle(
                                      color: Colors.white
                                    )),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('${AppStrings.creationDate}:', style: TextStyle(
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
                                    child: Text(monthDateYear(item.creationDate), style: const TextStyle(
                                      color: Colors.white
                                    )),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 10)
                  ]
                );
              })
            ],
          )
          :
          SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: const Center(
              child: Text(AppStrings.prepaymentsNotFound, style: TextStyle(fontSize: 20))
            ),
          )
        ]
      )
      :
      const Center(
        child: Text(AppStrings.noData, style: TextStyle(fontSize: 20))
      )
    );
  }
}