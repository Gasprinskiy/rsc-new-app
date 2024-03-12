class CalcCommonSalaryOptions {
  List<double> sales;
  double salary;
  double percentFromSales;
  bool ignorePlan;
  bool isVariablePercent;
  double plan;
  List<PercentChangeRule> percentChangeRules;

  CalcCommonSalaryOptions({
    required this.sales,
    required this.salary,
    required this.percentFromSales,
    required this.ignorePlan,
    required this.isVariablePercent,
    required this.plan,
    required this.percentChangeRules
  });
}

class CalcFinalSalaryOptions extends CalcCommonSalaryOptions {
  List<double> prepayments;
  CalcFinalSalaryOptions(
      {required super.sales,
      required super.salary,
      required super.percentFromSales,
      required super.ignorePlan,
      required super.isVariablePercent,
      required super.plan,
      required super.percentChangeRules,
      required this.prepayments});
}

class FindReachedConditionsOptions {
  List<double> sales;
  double plan;
  List<PercentChangeRule> rules;

  FindReachedConditionsOptions({
    required this.sales, 
    required this.plan, 
    required this.rules
  });
}

class ReachedConditionResult {
  double changedPercent;
  List<double> bonuses;

  ReachedConditionResult({required this.changedPercent, required this.bonuses});
}

class PercentChangeRule {
  double percentGoal;
  double percentChange;
  double salaryBonus;

  PercentChangeRule(
      {required this.percentGoal,
      required this.percentChange,
      required this.salaryBonus});
}
