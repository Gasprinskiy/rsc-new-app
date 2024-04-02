import 'package:currency_textfield/currency_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/view-widgets/salary_info.dart';
import 'package:test_flutter/widgets/app_text_form_field.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/helpers/toasts.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/widgets/decoration_box.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/widgets/dialog.dart';

class SalaryInfoRoute extends StatefulWidget {
  
  const SalaryInfoRoute({super.key});

  @override
  State<SalaryInfoRoute> createState() => _SalaryInfoRouteState();
}

class _SalaryInfoRouteState extends State<SalaryInfoRoute> {

  final userState = UserState.getInstance();
  final userApi = UserApi.getInstance();
  final appDialog = AppDialog.getInstance();
  
  FToast fToast = FToast();

  Future<void> saveSalaryInfo(SalaryInfo salaryInfo, List<PercentChangeConditions>? conditions) async {
    fToast.init(context);
    await userState.setAndSyncSalaryInfo(salaryInfo, conditions);
    navigateToCreateLocalAuthRoute();
  }

  void navigateToCreateLocalAuthRoute() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/create_local_auth', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
      const DecorationBox(
        children: [
          Text(AppStrings.typeYourSalaryInfo, style: AppTheme.titleLarge),
          SizedBox(height: 10),
        ],
      ),
      SalaryInfoWidget(
        userData: userState.user,
        onSave: saveSalaryInfo,
      )
      // Form(
      //     key: _formKey,
      //     child: Padding(
      //       padding: const EdgeInsets.all(20),
      //       child: Column(
      //         mainAxisSize: MainAxisSize.max,
      //         crossAxisAlignment: CrossAxisAlignment.end,
      //         children: [
      //           AppTextFormField(
      //             controller: salaryController,
      //             labelText: AppStrings.salary,
      //             keyboardType: TextInputType.number,
      //             textInputAction: TextInputAction.next,
      //             validator: (value) {
      //               return value!.isEmpty
      //                   ? AppStrings.fieldCannotBeEmpty
      //                   : null;
      //             },
      //           ),
      //           AppTextFormField(
      //             controller: percentFromSalesController,
      //             labelText: AppStrings.percentFromSales,
      //             keyboardType: TextInputType.number,
      //             textInputAction: TextInputAction.next,
      //             validator: (value) {
      //               if (_isVariablePercent) {
      //                 return null;
      //               }
      //               return value!.isEmpty
      //                   ? AppStrings.fieldCannotBeEmpty
      //                   : null;
      //             },
      //           ),
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Row(
      //                 children: [
      //                   Checkbox(
      //                       // contentPadding: const EdgeInsets.all(5),
      //                       value: _isVariablePercent,
      //                       checkColor: Colors.white,
      //                       activeColor: AppColors.primary,
      //                       onChanged: onVariablePercentToggle),
      //                   const Text(
      //                     AppStrings.variablePercent,
      //                     style: TextStyle(fontSize: 15.0),
      //                   ),
      //                 ],
      //               ),
      //               TextButton(
      //                   onPressed: () => showDescriptionModal(AppStrings.variablePercent, AppStrings.variablePercentDescription),
      //                   child: const Icon(Icons.info)),
      //             ],
      //           ),
      //           _isVariablePercent
      //               ? Column(
      //                   children: [
      //                     AppTextFormField(
      //                       controller: planController,
      //                       labelText: AppStrings.plan,
      //                       keyboardType: TextInputType.number,
      //                       textInputAction: TextInputAction.next,
      //                       validator: (value) {
      //                         return value!.isEmpty
      //                             ? AppStrings.fieldCannotBeEmpty
      //                             : null;
      //                       },
      //                     ),
      //                     Row(
      //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                       children: [
      //                         Row(
      //                           children: [
      //                             Checkbox(
      //                                 // contentPadding: const EdgeInsets.all(5),
      //                                 value: _ignorePlan,
      //                                 checkColor: Colors.white,
      //                                 activeColor: AppColors.primary,
      //                                 onChanged: onIgnorePlanToggle),
      //                             const Text(
      //                               AppStrings.ignorePlan,
      //                               style: TextStyle(fontSize: 15.0),
      //                             ),
      //                           ],
      //                         ),
      //                         TextButton(
      //                             onPressed: () => {
      //                                   showDescriptionModal(
      //                                       AppStrings.ignorePlan,
      //                                       AppStrings.ignorePlanDescription)
      //                                 },
      //                             child: const Icon(Icons.info)),
      //                       ],
      //                     ),
      //                     Column(
      //                       mainAxisSize: MainAxisSize.max,
      //                       // crossAxisAlignment: CrossAxisAlignment.center,
      //                       mainAxisAlignment: MainAxisAlignment.center,
      //                       children: [
      //                         ..._addedConditions.map((item) {
      //                           int index = _addedConditions.indexOf(item) + 1;
      //                           return Card(
      //                               margin: const EdgeInsets.only(
      //                                   top: 10, bottom: 10),
      //                               child: Padding(
      //                                   padding: const EdgeInsets.only(
      //                                       left: 10,
      //                                       right: 10,
      //                                       top: 5,
      //                                       bottom: 5),
      //                                   child: Column(
      //                                     mainAxisSize: MainAxisSize.max,
      //                                     crossAxisAlignment:
      //                                         CrossAxisAlignment.start,
      //                                     children: [
      //                                       Text(
      //                                         '${AppStrings.condition} #$index',
      //                                         style: const TextStyle(
      //                                             fontSize: 16,
      //                                             fontWeight: FontWeight.w500),
      //                                       ),
      //                                       const SizedBox(height: 5),
      //                                       Row(
      //                                         children: [
      //                                           const Text(
      //                                             '${AppStrings.planGoal}: ',
      //                                             textAlign: TextAlign.left,
      //                                           ),
      //                                           Text(
      //                                             '${item.percentGoal};',
      //                                             style: const TextStyle(
      //                                                 color: AppColors.primary,
      //                                                 fontWeight:
      //                                                     FontWeight.w500),
      //                                           )
      //                                         ],
      //                                       ),
      //                                       Row(
      //                                         children: [
      //                                           const Text(
      //                                             '${AppStrings.percentChangeOnGoalReached}: ',
      //                                             textAlign: TextAlign.left,
      //                                           ),
      //                                           Text(
      //                                             '${item.percentChange};',
      //                                             style: const TextStyle(
      //                                                 color: AppColors.primary,
      //                                                 fontWeight:
      //                                                     FontWeight.w500),
      //                                           )
      //                                         ],
      //                                       ),
      //                                     ],
      //                                   )));
      //                         }).toList(),
      //                       ],
      //                     ),
      //                     TextButton(
      //                         onPressed: showPercentChangeConditionsModal,
      //                         child: const Text(AppStrings.addConditionds)),
      //                     const SizedBox(height: 20)
      //                   ],
      //                 )
      //               : const SizedBox(height: 20),
      //           FilledButton(
      //             onPressed: saveSalaryInfo,
      //             child: _isLoading
      //                 ? const CircularProgressIndicator(
      //                     color: Colors.white,
      //                   )
      //                 : const Text(AppStrings.save),
      //           )
      //         ],
      //       ),
      //     )),
    ]));
  }
}
