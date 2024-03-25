import 'package:test/test.dart';
import 'package:test_flutter/core/accounting_calculations.dart';
import 'package:test_flutter/core/entity.dart';

void main() {
  // test only complex core methods
  AccointingCalculations core = AccointingCalculations.getInstance();

  group('Test calcCommonSalary', () {
    test('without sales', () {
      double expectResult = 2000000;
      CalcCommonSalaryOptions options = CalcCommonSalaryOptions(
        sales: [],
        salary: 2000000,
        percentFromSales: 2,
        ignorePlan: false,
        isVariablePercent: false,
        plan: 0,
        percentChangeRules: []
      );
      expect(core.calcCommonSalary(options), expectResult);
    });
    test('without virable percent', () {
      double expectResult = 3600000;
      CalcCommonSalaryOptions options = CalcCommonSalaryOptions(
        sales: [80000000],
        salary: 2000000,
        percentFromSales: 2,
        ignorePlan: false,
        isVariablePercent: false,
        plan: 0,
        percentChangeRules: []
      );
      expect(core.calcCommonSalary(options), expectResult);
    });

    test('with virable percent not igoring plan', () {
      double expectResult = 4550000;
      List<PercentChangeRule> rules = [
        PercentChangeRule(
          percentChange: 2.5,
          percentGoal: 90,
          salaryBonus: 50000
        ),
        PercentChangeRule(
          percentChange: 3,
          percentGoal: 100,
          salaryBonus: 100000
        ),
      ];
      CalcCommonSalaryOptions options = CalcCommonSalaryOptions(
        sales: [80000000],
        salary: 2000000,
        percentFromSales: 2,
        ignorePlan: false,
        isVariablePercent: true,
        plan: 80000000,
        percentChangeRules: rules
      );
      expect(core.calcCommonSalary(options), expectResult);
    });

    test('with virable percent igoring plan', () {
      double expectResult = 2750000;
      List<PercentChangeRule> rules = [
        PercentChangeRule(
          percentChange: 2.5,
          percentGoal: 90,
          salaryBonus: 50000
        ),
        PercentChangeRule(
          percentChange: 3,
          percentGoal: 100,
          salaryBonus: 100000
        ),
      ];
      CalcCommonSalaryOptions options = CalcCommonSalaryOptions(
        sales: [80000000, 20000000],
        salary: 2000000,
        percentFromSales: 2,
        ignorePlan: true,
        isVariablePercent: true,
        plan: 80000000,
        percentChangeRules: rules
      );
      expect(core.calcCommonSalary(options), expectResult);
    });
  });

  group('Test calcFinalSalary', () {
    test('final salary with prepayment', () {
      double expectResult = 2600000;
      List<PercentChangeRule> rules = [
        PercentChangeRule(
          percentChange: 2.5,
          percentGoal: 90,
          salaryBonus: 50000
        ),
        PercentChangeRule(
          percentChange: 3,
          percentGoal: 100,
          salaryBonus: 100000
        ),
      ];
      CalcFinalSalaryOptions options = CalcFinalSalaryOptions(
        sales: [80000000],
        salary: 2000000,
        percentFromSales: 2,
        ignorePlan: false,
        isVariablePercent: false,
        prepayments: [1000000],
        plan: 0,
        percentChangeRules: rules
      );
      expect(core.calcFinalSalary(options), expectResult);
    });
  });

  group('Test calcPlanProgress', () {
    test('progress less then 100%', () {
      double expectResult = 62.5;
      List<double> sales = [30000000, 20000000];
      double plan = 80000000;
      expect(core.calcPlanProgress(sales, plan), expectResult);
    });

    test('progress more or equal to 100%', () {
      double expectResult = 100;
      List<double> sales = [30000000, 60000000];
      double plan = 80000000;
      expect(core.calcPlanProgress(sales, plan), expectResult);
    });
  });

  group('Test findReachedConditions', () {
    test('found conditions with 1 bonus', () {
      ReachedConditionResult expectResult = ReachedConditionResult(
        changedPercent: 3, 
        bonuses: [100000]
      );
      FindReachedConditionsOptions options = FindReachedConditionsOptions(
        sales: [30000000, 60000000], 
        plan: 80000000, 
        rules: [
          PercentChangeRule(
            percentChange: 2.5,
            percentGoal: 90,
            salaryBonus: 0
          ),
          PercentChangeRule(
            percentChange: 3,
            percentGoal: 100,
            salaryBonus: 100000
          ),
        ]
      );
      ReachedConditionResult? result = core.findReachedConditions(options);
      expect(result!.changedPercent, expectResult.changedPercent);
      expect(result.bonuses, expectResult.bonuses);
    });

    test('found conditions with 2 bonuses', () {
      ReachedConditionResult expectResult = ReachedConditionResult(
        changedPercent: 3, 
        bonuses: [50000, 100000]
      );
      FindReachedConditionsOptions options = FindReachedConditionsOptions(
        sales: [30000000, 60000000], 
        plan: 80000000, 
        rules: [
          PercentChangeRule(
            percentChange: 2.5,
            percentGoal: 90,
            salaryBonus: 50000
          ),
          PercentChangeRule(
            percentChange: 3,
            percentGoal: 100,
            salaryBonus: 100000
          ),
        ]
      );
      ReachedConditionResult? result = core.findReachedConditions(options);
      expect(result!.changedPercent, expectResult.changedPercent);
      expect(result.bonuses, expectResult.bonuses);
    });

    test('found conditions without rules and plan', () {
      FindReachedConditionsOptions options = FindReachedConditionsOptions(
        sales: [30000000, 60000000], 
        plan: 0, 
        rules: []
      );
      ReachedConditionResult? result = core.findReachedConditions(options);
      expect(result, null);
      
    });

    test('conditions not found', () {
      FindReachedConditionsOptions options = FindReachedConditionsOptions(
        sales: [30000000], 
        plan: 80000000, 
        rules: [
          PercentChangeRule(
            percentChange: 2.5,
            percentGoal: 90,
            salaryBonus: 50000
          ),
          PercentChangeRule(
            percentChange: 3,
            percentGoal: 100,
            salaryBonus: 100000
          ),
        ]
      );
      ReachedConditionResult? result = core.findReachedConditions(options);
      expect(result, null);
    });
  });
}
