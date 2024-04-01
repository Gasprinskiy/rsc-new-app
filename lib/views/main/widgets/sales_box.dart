import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/tools/number.dart';

class _SalesTotalValues {
  List<double> sales;
  List<double> cashTaxes;
  List<double> nonCash;

  _SalesTotalValues({
    required this.sales,
    required this.cashTaxes,
    required this.nonCash
  });
}


class SalesBox extends StatelessWidget {
  final List<Sale> sales;
  final void Function()? onBoxClick;

  SalesBox({
    super.key,
    required this.sales,
    this.onBoxClick
  });

  final calcCore = AccountingCalculations.getInstance();

  Column salesItem(BuildContext context) {
    if (sales.isNotEmpty) {
      double commonSales = 0; 
      double commonCashTaxes = 0; 
      double commonNonCash = 0; 
      if (sales.isNotEmpty) {
        _SalesTotalValues totalValues = _SalesTotalValues(
          sales: [],
          cashTaxes: [],
          nonCash: []
        );
        for (var element in sales) {
          totalValues.sales.add(element.total);
          totalValues.cashTaxes.add(element.cashTaxes);
          totalValues.nonCash.add(element.nonCash);
        }
        commonSales = calcCore.calcTotal(totalValues.sales);
        commonCashTaxes = calcCore.calcTotal(totalValues.cashTaxes);
        commonNonCash = calcCore.calcTotal(totalValues.nonCash);
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.sales,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.primaryTransparent,
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: TextButton(
                onPressed: () => onBoxClick?.call(),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )
                  )
                ),
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
                          child: Text(currencyFormat(commonCashTaxes), style: const TextStyle(
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
                          child: Text(currencyFormat(commonNonCash), style: const TextStyle(
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
                          child: Text(currencyFormat(commonSales), style: const TextStyle(
                            color: Colors.white
                          )),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ),
        ),
      ]);
    }
    return const Column();
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      key: super.key,
      child: salesItem(context),
    );
  }
}