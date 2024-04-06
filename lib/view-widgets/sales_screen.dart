
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

class SalesScreen extends StatefulWidget {
  final List<Sale> sales;
  final Future<void> Function(Sale sale)? onRedact;
  const SalesScreen({
    super.key,
    required this.sales,
    this.onRedact
  });

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  late List<Sale> sales;
  late Future<void> Function(Sale sale)? onRedact;
  final updateFormKey = GlobalKey<FormState>();

  List<Sale> innerList = [];
  int updateKey = 1;

  late DateTime dateFrom;
  late DateTime dateTo;

  late final TextEditingController creationDateController;
  late final CurrencyTextFieldController totalSalesController;
  late final CurrencyTextFieldController cashTaxesController;
  late final CurrencyTextFieldController nonCashController;

  void initInnerListState() {
    if (sales.isNotEmpty) {
      setState(() {
        dateFrom = sales.reduce((current, next) => current.creationDate.isBefore(next.creationDate) ? current : next).creationDate;
        dateTo = sales.reduce((current, next) => current.creationDate.isAfter(next.creationDate) ? current : next).creationDate;
        innerList = sales.toList();
        innerList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      });
    }
  }

  void initializeControllers() {
    creationDateController = TextEditingController();
    totalSalesController = getDefaultCurrencyTextFieldController(null);
    cashTaxesController = getDefaultCurrencyTextFieldController(null);
    nonCashController = getDefaultCurrencyTextFieldController(null);
  }

  void disposeControllers() {
    creationDateController.dispose();
    totalSalesController.dispose();
    cashTaxesController.dispose();
    nonCashController.dispose();
  }

  void filterListByDateRange(DateTime from, DateTime to) {
    bool fromIsSame = getDurationIgnoredDate(from).isAtSameMomentAs(getDurationIgnoredDate(dateFrom));
    bool toIsSame =  getDurationIgnoredDate(to).isAtSameMomentAs(getDurationIgnoredDate(dateTo));
    if (!fromIsSame || !toIsSame) { 
      setState(() {
        innerList = sales.where((element) => (element.creationDate.isAfter(from) && element.creationDate.isBefore(to))).toList();
        innerList.sort((a, b) => b.creationDate.compareTo(a.creationDate));
      });
    }
  }

  void onSaleRedact(Sale sale) {
    creationDateController.text = sale.creationDate.toString().split(' ')[0];
    totalSalesController.value = TextEditingValue(text: sale.total.toStringAsFixed(0));
    cashTaxesController.value = TextEditingValue(text: sale.cashTaxes.toStringAsFixed(0));
    nonCashController.value = TextEditingValue(text: sale.nonCash.toStringAsFixed(0));

    showSalesDialog(
      ShowSalesDialogParams(
        context: context, 
        formKey: updateFormKey, 
        title: '${AppStrings.redact} ${AppStrings.saleAddRedact}', 
        totalSalesController: totalSalesController, 
        cashTaxesController: cashTaxesController, 
        nonCashController: nonCashController, 
        dateController: creationDateController,
        redactingSale: sale,
        onSave: onSaleRedactSave
      )
    );
  }

  Future<void> onSaleRedactSave(Sale? sale, String? id) async {    
    if (sale != null && id != null) {
      int updatedIndex = innerList.indexWhere((item) => item.id == id);
      if (updatedIndex >= 0 && !innerList[updatedIndex].isEqual(sale)) {
        setState(() {
          innerList[updatedIndex].total = sale.total;
          innerList[updatedIndex].cashTaxes = sale.cashTaxes;
          innerList[updatedIndex].nonCash = sale.nonCash;
          innerList[updatedIndex].creationDate = sale.creationDate;
          updateKey += 1;
          Navigator.of(context).pop();
        });
        await onRedact?.call(innerList[updatedIndex]);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sales = widget.sales;
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
      sales.isNotEmpty
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
                      onPressed: onRedact != null ? () => onSaleRedact(item) : null,
                      child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('${AppStrings.cashTaxes}:', style: TextStyle(
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
                                    child: Text(currencyFormat(item.cashTaxes), style: const TextStyle(
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
                                const Text('${AppStrings.nonCash}:', style: TextStyle(
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
                                    child: Text(currencyFormat(item.nonCash), style: const TextStyle(
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
                                    child: Text(currencyFormat(item.total), style: const TextStyle(
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
              child: Text(AppStrings.salesNotFound, style: TextStyle(fontSize: 20))
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