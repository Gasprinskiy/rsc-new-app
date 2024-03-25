import 'package:test_flutter/core/entity.dart';

class AccointingCalculations {
  static AccointingCalculations? _instance;
  AccointingCalculations._();

  static AccointingCalculations getInstance() {
    _instance ??= AccointingCalculations._();
    return _instance!;
  }

  double calcTotal(List<double> list) {
    return list.reduce((total, item) => total + item);
  }

  double calcCommonSalary(CalcCommonSalaryOptions options) {
    double sales = 0;

    if (options.sales.isNotEmpty) {
      sales = calcTotal(options.sales);
    }
    if (!options.isVariablePercent) {
      return options.salary + calcPercent(sales, options.percentFromSales);
    }

    ReachedConditionResult? reachedConditions = findReachedConditions(
      FindReachedConditionsOptions(
        sales: options.sales, 
        plan: options.plan, 
        rules: options.percentChangeRules
      )
    );

    if (options.ignorePlan) {
      if (reachedConditions == null) {
        return options.salary;
      }
      
      double totalBonuses = calcTotal(reachedConditions.bonuses);
      double percentFromSales = calcPercent(sales - options.plan, reachedConditions.changedPercent);
      return (options.salary + totalBonuses) + percentFromSales;
    } else {
      if (reachedConditions == null) {
        double percentFromSales = calcPercent(sales, options.percentFromSales);
        return options.salary + percentFromSales;
      }
      
      double percentFromSales = calcPercent(sales, reachedConditions.changedPercent);
      double totalBonuses = calcTotal(reachedConditions.bonuses);
      return (options.salary + totalBonuses) + percentFromSales;
    }
  }

  double calcFinalSalary(CalcFinalSalaryOptions options) {
    double totalPrepayments = calcTotal(options.prepayments);
    double commonSalary = calcCommonSalary(
      CalcCommonSalaryOptions(
        sales: options.sales,
        salary: options.salary,
        percentFromSales: options.percentFromSales,
        ignorePlan: options.ignorePlan,
        isVariablePercent: options.isVariablePercent,
        plan: options.plan,
        percentChangeRules: options.percentChangeRules
      )
    );
    return commonSalary - totalPrepayments;
  }

  ReachedConditionResult? findReachedConditions(FindReachedConditionsOptions options) {
    double planProgress = calcPlanProgress(options.sales, options.plan);
    List<PercentChangeRule> filteredRules = options.rules.where((item) => planProgress >= item.percentGoal).toList();

    if (filteredRules.isNotEmpty) {
      List<double> bonuses = filteredRules.map((item) => item.salaryBonus).where((item) => item > 0).toList();
      return ReachedConditionResult(
        bonuses: bonuses,
        changedPercent: filteredRules[filteredRules.length - 1].percentChange
      );
    }
    return null;
  }

  double calcPlanProgress(List<double> sales, double plan) {
    double totalSales = calcTotal(sales);
    double result = (totalSales / plan) * 100;
    return result >= 100 ? 100 : result;
  }

  double calcPercent(double total, double percent) {
    return total / 100 * percent;
  }

  bool isPlanReached(List<double> sales, double plan) {
    return calcPlanProgress(sales, plan) >= 100;
  }
}
