import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/widgets/button_box.dart';

class SalesList extends StatefulWidget {
  final List<Prepayment> prepayments;
  final bool? readOnly;
  final void Function(Prepayment sale)? onSaleClick;

  const SalesList({super.key, required this.prepayments, this.readOnly, this.onSaleClick});

  @override
  State<SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<SalesList> {
  final updateFormKey = GlobalKey<FormState>();

  late List<Prepayment> prepayments;
  late bool readOnly;
  late void Function(Prepayment sale)? onSaleClick;

  @override
  void initState() {
    super.initState();
    prepayments = widget.prepayments;
    readOnly = widget.readOnly ?? false;
    onSaleClick = widget.onSaleClick;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...prepayments.map((item) {
          return Column(children: [
            ButtonBox(
              onPressed: () => readOnly ? null : onSaleClick?.call(item),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('${AppStrings.amount}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      DecoratedBox(
                        decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Text(currencyFormat(item.value), style: const TextStyle(color: Colors.white)),
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
