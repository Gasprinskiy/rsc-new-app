import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/core/accounting_calculations.dart';
import 'package:rsc/core/entity.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/widgets/button_box.dart';

class _SalesTotalValues {
  List<double> sales;
  List<double> cashTaxes;
  List<double> nonCash;

  _SalesTotalValues({required this.sales, required this.cashTaxes, required this.nonCash});
}

class SalesBox extends StatefulWidget {
  final List<Sale> sales;
  final void Function()? onBoxClick;

  const SalesBox({super.key, required this.sales, this.onBoxClick});

  @override
  State<SalesBox> createState() => _SalesBoxState();
}

class _SalesBoxState extends State<SalesBox> {
  late List<Sale> sales;
  late void Function()? onBoxClick;

  final calcCore = AccountingCalculations.getInstance();
  final userState = UserState.getInstance();

  double _commonSales = 0;
  double _commonCashTaxes = 0;
  double _commonNonCash = 0;
  double _percentFromSales = 0;

  void calcValues() {
    if (sales.isNotEmpty) {
      List<double> reachecSales = [];
      double totalAmount = 0;
      double? percentFromSales = userState.user?.salaryInfo?.percentFromSales;

      _SalesTotalValues totalValues = _SalesTotalValues(sales: [], cashTaxes: [], nonCash: []);
      for (var element in sales) {
        totalValues.sales.add(element.total);
        totalValues.cashTaxes.add(element.cashTaxes);
        totalValues.nonCash.add(element.nonCash);

        if (userState.user?.percentChangeConditions != null && userState.user?.salaryInfo?.plan != null) {
          reachecSales.add(element.total);
          ReachedConditionResult? reachedConditions = calcCore.findReachedConditions(
            FindReachedConditionsOptions(
              sales: reachecSales, 
              plan: userState.user!.salaryInfo!.plan!, 
              rules: userState.user!.percentChangeConditions!.map((item) {
                return PercentChangeRule(
                  percentGoal: item.percentGoal, 
                  percentChange: item.percentChange, 
                  salaryBonus: item.salaryBonus != null ? item.salaryBonus! : 0
                );
              }).toList()
            )
          );
          if (reachedConditions != null) {
            percentFromSales = reachedConditions.changedPercent;
            totalAmount = calcCore.calcTotal(reachecSales);
            if (userState.user?.salaryInfo?.ignorePlan == true) {
              totalAmount -= (userState.user?.salaryInfo?.plan ?? 0);
            }
          }
        }
        setState(() {
          _commonSales = calcCore.calcTotal(totalValues.sales);
          _commonCashTaxes = calcCore.calcTotal(totalValues.cashTaxes);
          _commonNonCash = calcCore.calcTotal(totalValues.nonCash);
          if (percentFromSales != null) {
            _percentFromSales = calcCore.calcPercent(totalAmount, percentFromSales);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sales = widget.sales;
    onBoxClick = widget.onBoxClick;
    calcValues();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.key,
      child: Column(key: widget.key, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(
          children: [
            Icon(
              Icons.sell_rounded,
              color: AppColors.primary500,
              size: 20,
            ),
            SizedBox(width: 5),
            Text(
              AppStrings.sales,
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
          onPressed: () => onBoxClick?.call(),
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
                      child: Text(currencyFormat(_commonCashTaxes), style: const TextStyle(color: Colors.white)),
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
                      child: Text(currencyFormat(_commonNonCash), style: const TextStyle(color: Colors.white)),
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
                      child: Text(currencyFormat(_commonSales), style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('${AppStrings.percentFromSales}:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  DecoratedBox(
                    decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(3))),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Text(currencyFormat(_percentFromSales), style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }
}
