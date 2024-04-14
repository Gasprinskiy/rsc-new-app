
import 'package:flutter/material.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/view-widgets/salary_info.dart';
import 'package:rsc/widgets/toast.dart';

class ChangeUserSalaryInfoScreen extends StatefulWidget {
  const ChangeUserSalaryInfoScreen({super.key});

  @override
  State<ChangeUserSalaryInfoScreen> createState() => _ChangeUserSalaryInfoScreenState();
}

class _ChangeUserSalaryInfoScreenState extends State<ChangeUserSalaryInfoScreen> {
  final userState = UserState.getInstance();
  final appToast = AppToast.getInstance();

  Future<void> updateSalaryInfoAction(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions) async {
    bool isSalaryInfoEqual = userState.user?.salaryInfo?.isEqual(salaryInfo) ?? true;
    bool isConditionsEqual = true;
    if (conditions != null && userState.user?.percentChangeConditions != null) {
      for (var element in conditions) {
        int index = conditions.indexOf(element);
        if (element.isEqual(userState.user!.percentChangeConditions![index]) == false) {
          isConditionsEqual = false;
          break;
        }
      }
    }

    if (!isSalaryInfoEqual || !isConditionsEqual) {
      appToast.init(context);
      await userState.updateSalaryInfo(salaryInfo, !isConditionsEqual ? conditions : null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SalaryInfoWidget(
            userData: userState.user,
            onSave: updateSalaryInfoAction,
          )
        ],
      )
    );
  }
}