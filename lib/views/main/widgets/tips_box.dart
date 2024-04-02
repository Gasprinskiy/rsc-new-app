import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/tools/number.dart';
import 'package:test_flutter/widgets/button_box.dart';


class TipsBox extends StatelessWidget {
  final List<Tip> tips;
  final void Function()? onBoxClick;

  TipsBox({
    super.key,
    required this.tips,
    this.onBoxClick
  });

  final calcCore = AccountingCalculations.getInstance();

  Column tipsItem(BuildContext context) {
    
      double commonAmount = 0;
      if (tips.isNotEmpty) {
        commonAmount =  calcCore.calcTotal(tips.map((item) => item.value).toList());
      }
      return Column(
          key: key,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
            children: [
                Icon(
                  Icons.payments_outlined,
                  color: AppColors.primary500,
                  size: 20,
                ),
                SizedBox(width: 5),
                Text(
                  AppStrings.tips,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 10),
            ButtonBox(
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
            ),
          ],
        );
  }

  @override 
  Widget build(BuildContext context) {
    return Container(
      key: super.key,
      child: tipsItem(context),
    );
  }
}