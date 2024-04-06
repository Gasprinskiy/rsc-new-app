import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:rsc/api/acounting.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/core/accounting_calculations.dart';
import 'package:rsc/core/entity.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/entity/entity.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/tools/datetime.dart';
import 'package:rsc/tools/extensions.dart';
import 'package:rsc/tools/number.dart';
import 'package:rsc/widgets/decoration_box.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final calcCore = AccountingCalculations.getInstance();
  final userState = UserState.getInstance();
  final accountingState = AccountingState.getInstance();
  final accountingApi = AccountingApi.getInstance();

  double _finalSalary = 0;
  double? _planProgress;
  List<RecentAction>? _recentActionsList;

  final Map<RecentActionsValueType, IconData> _recentActionsIconsMap = {
    RecentActionsValueType.percentFromSale: Icons.percent_rounded,
    RecentActionsValueType.tip: Icons.payments_outlined,
    RecentActionsValueType.prepayment: Icons.money_off_csred
  };

  @override
  void initState() {
    super.initState();
    setCalcResults();
    setRecentActions();
  }

  Future<void> setCalcResults() async {
    List<Sale> sales = await accountingState.getSaleList() ?? [];
    List<Prepayment> prepayments = await accountingState.getPrepaymentList() ?? [];
    User? userData = userState.user;
    List<PercentChangeRule>? percentChangeRules = userData?.percentChangeConditions?.map((item) {
      return PercentChangeRule(
        percentGoal: item.percentGoal, 
        percentChange: item.percentChange, 
        salaryBonus: item.salaryBonus ?? 0
      );
    }).toList();
    List<double> salesTotal = sales.map((item) => item.total).toList();

    setState(() {
      _finalSalary = calcCore.calcFinalSalary(
        CalcFinalSalaryOptions(
          sales: salesTotal, 
          salary: userData?.salaryInfo?.salary ?? 0, 
          percentFromSales: userData?.salaryInfo?.percentFromSales ?? 0, 
          ignorePlan: userData?.salaryInfo?.ignorePlan ?? false, 
          isVariablePercent: userData?.percentChangeConditions != null, 
          plan: userData?.salaryInfo?.plan ?? 0, 
          percentChangeRules: percentChangeRules ?? [], 
          prepayments: prepayments.map((item) => item.value).toList()
        )
      );
      if (userState.user?.salaryInfo?.plan != null && salesTotal.isNotEmpty) {
        _planProgress = calcCore.calcPlanProgress(salesTotal, userState.user!.salaryInfo!.plan!);
      }
    });
  }

  Future<void> setRecentActions() async {
    List<RecentAction>? actions = await accountingState.getRecentActions();
    if (actions != null) {
      setState(()  {
        _recentActionsList = actions;
      });
    }
  }

  Text recentActionValueFormat(RecentAction action) {
    if (action.type == RecentActionsType.expense) {
      return Text(
        '-${currencyFormat(action.amount)}',
        style: const TextStyle(
          color: AppColors.error,
          fontSize: 16,
        ),
        textAlign: TextAlign.right,
      );
    }
    return Text(
      '+${currencyFormat(action.amount)}',
      style: const TextStyle(
        color: AppColors.success,
        fontSize: 16
      ),
      textAlign: TextAlign.right,
    );
  }

  List<Column> recentActionsItems() {
    if (_recentActionsList != null) {
      return _recentActionsList!.map((item) {
        return Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: AppColors.primaryTransparent,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            _recentActionsIconsMap[item.valueType], 
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          recentActionValueFormat(item),
                          const SizedBox(height: 10),
                          Text(monthDateYear(item.creationDate))
                        ],
                      )
                    ],
                  ),
                ),
              )
            )
          ],
        );
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          DecorationBox(
            top: 0,
            children: [
              const Text(
                AppStrings.finalSalary,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              AnimatedDigitWidget(
                value: _finalSalary,
                enableSeparator: true,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                ),
                duration: const Duration(milliseconds: 500),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: 
            accountingState.currentAccountingCreationDate != null 
            ? 
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '${AppStrings.curreReportData}:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.end,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTransparent,
                      borderRadius: BorderRadius.all(Radius.circular(5))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('${AppStrings.started}:'),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.primary
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    monthAndYear(accountingState.currentAccountingCreationDate!).capitalize(),
                                    style: const TextStyle(color: Colors.white),
                                  )
                                    ,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: _planProgress != null ? 10 : 0),
                          _planProgress != null
                          ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('${AppStrings.planProgress}:'),
                              DecoratedBox(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: AppColors.primary
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    '${_planProgress?.toStringAsFixed(2)}%',
                                    style: const TextStyle(color: Colors.white),
                                  )
                                    ,
                                ),
                              )
                            ],
                          )
                          :
                          const SizedBox(width: 0),
                        ]
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _recentActionsList != null && _recentActionsList!.isNotEmpty ? 
                const Text(
                  '${AppStrings.recentActions}:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                  ),
                  textAlign: TextAlign.end,
                )
                :
                const SizedBox(height: 0),
                Column(
                  children: [
                    ...recentActionsItems()
                  ],
                )
              ],
            )
            :
            const SizedBox(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Icon(
                      Icons.not_interested_rounded,
                      size: 35,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 10),
                    Text(
                      AppStrings.noDataReportFound,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          )
        ]
      )
    );
  }
}