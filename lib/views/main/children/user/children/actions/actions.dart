
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/views/main/children/user/children/actions/children/change_password.dart';
import 'package:rsc/views/main/children/user/children/actions/children/change_salary_info.dart';
import 'package:rsc/views/main/entity/entity.dart';

class UsetActions extends StatefulWidget {
  final UsetActionsScreenType type;
  const UsetActions({super.key, required this.type});

  @override
  State<UsetActions> createState() => _UsetActionsState();
}

class _UsetActionsState extends State<UsetActions> {
  late UsetActionsScreenType type;

  static const Map<UsetActionsScreenType, Widget> viewsMap = {
    UsetActionsScreenType.changePassword: ChangePasswordScreen(),
    UsetActionsScreenType.salaryInfo: ChangeUserSalaryInfoScreen()
  };

  static const Map<UsetActionsScreenType, String> topTitleMap = {
    UsetActionsScreenType.changePassword: AppStrings.changePassword,
    UsetActionsScreenType.salaryInfo: AppStrings.salaryInfo
  };
  
  void navigateBack() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              children: [
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: navigateBack,
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded, 
                            color: Colors.white
                          )
                        ),
                        Text(
                          topTitleMap[type] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500
                          ),
                        )
                      ],
                    )
                  ]
                )    
              ],
            ),
          ),
      ),
      body: viewsMap[type],
    );
  }
}