import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/tools/number.dart';


class PrepaymentsBox extends StatelessWidget {
  final List<Prepayment> prepayments;
  final void Function()? onBoxClick;

  PrepaymentsBox({
    super.key,
    required this.prepayments,
    this.onBoxClick
  });

  final calcCore = AccountingCalculations.getInstance();

  Column prepaymentsItem(BuildContext context) {
   
    double commonAmount = 0;
    if (prepayments.isNotEmpty) {
      commonAmount = calcCore.calcTotal(prepayments.map((item) => item.value).toList());
    } 
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.money_off_csred,
                color: AppColors.primary500,
                size: 20,
              ),
              SizedBox(width: 5),
              Text(
                AppStrings.prepayment,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.start,
              ),
            ],
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
                          child: Text(currencyFormat(commonAmount), style: const TextStyle(
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

  @override 
  Widget build(BuildContext context) {
    return Container(
      key: super.key,
      child: prepaymentsItem(context),
    );
  }
}