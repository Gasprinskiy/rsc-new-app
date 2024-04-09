import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/widgets/button_box.dart';

class SalesList extends StatefulWidget {
  final List<Sale> sales;
  final bool? readOnly;
  final void Function(Sale sale)? onSaleClick;

  const SalesList({super.key, required this.sales, this.readOnly, this.onSaleClick});

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  final updateFormKey = GlobalKey<FormState>();

  late List<Sale> sales;
  late bool readOnly;
  late void Function(Sale sale)? onSaleClick;

  @override
  void initState() {
    super.initState();
    sales = widget.sales;
    readOnly = widget.readOnly ?? false;
    onSaleClick = widget.onSaleClick;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...sales.map((item) {
          return Column(children: [
            ButtonBox(
              onPressed: () => readOnly ? null : onSaleClick?.call(item),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('${AppStrings.cashTaxes}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(currencyFormat(item.cashTaxes), style: const TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('${AppStrings.nonCash}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(currencyFormat(item.nonCash), style: const TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('${AppStrings.amount}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(currencyFormat(item.total), style: const TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('${AppStrings.creationDate}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(monthDateYear(item.creationDate), style: const TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10)
          ]);
        })
      ],
    );
  }
}
