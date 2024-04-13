import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/views/main/children/user/children/actions/actions.dart';
import 'package:rsc/views/main/entity/entity.dart';
import 'package:rsc/widgets/button_box.dart';
import 'package:rsc/widgets/decoration_box.dart';
import 'package:rsc/widgets/dialog.dart';
import 'package:rsc/widgets/toast.dart';

class UserRoute extends StatefulWidget {
  const UserRoute({super.key});

  @override
  State<UserRoute> createState() => _UserState();
}

class _UserState extends State<UserRoute> {
  final userState = UserState.getInstance();
  final appToast = AppToast.getInstance();
  final appDialog = AppDialog.getInstance();

  bool _logOutInProgress = false;

  void onLogoutClick() {
    appDialog.show(
      context, 
      AppStrings.areYouSure, 
      false, 
      const Text(AppStrings.allUnsycDataWillBeRemoved), 
      [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text(AppStrings.no)
        ),
        TextButton(
          onPressed: logoutAction,
          child: const Text(AppStrings.yes)
          
        )
      ]
    );
  }

  Future<void> logoutAction() async {
    setState(() {
      Navigator.of(context).pop();
      _logOutInProgress = true;
    });
    await userState.logout();
    setState(() {
      _logOutInProgress = false;
      Navigator.of(context).pushNamed('/');
    });
  }

  void navigateToDetailsScreenByType(UsetActionsScreenType type) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) {
        return UsetActions(type: type);
      }
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _logOutInProgress
      ?
      const Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
      )
      :
      ListView(
        padding: EdgeInsets.zero,
        children: [
          DecorationBox(
            children: [
              Column(
                children: [
                  const SizedBox(
                    width: 100,
                    height: 100,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(100))
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.person_outline_sharp,
                          color: AppColors.primary,
                          size: 50,
                        ),
                      )
                    )
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userState.user?.personalInfo.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userState.user?.personalInfo.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18
                    ),
                  )
                ],
              )
            ]
          ),
          Column(
            children: [
              const Divider(
                height: 5,
                color: Colors.white,
              ),
              ButtonBox(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(20, 15, 20, 15)
                ),
                onPressed: () => navigateToDetailsScreenByType(UsetActionsScreenType.salaryInfo),
                child: const Row(
                  children: [
                    Icon(
                      Icons.attach_money_rounded,
                      size: 40,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 20),
                    Text(
                      AppStrings.salaryInfo,
                      style: TextStyle(
                        fontSize: 15
                      ),
                    )
                  ],
                )
              ),
              const Divider(
                height: 5,
                color: Colors.white,
              ),
              // ButtonBox(
              //   padding: MaterialStateProperty.all<EdgeInsets>(
              //     const EdgeInsets.fromLTRB(20, 15, 20, 15)
              //   ),
              //   onPressed: null,
              //   child: const Row(
              //     children: [
              //       Icon(
              //         Icons.password_rounded,
              //         size: 40,
              //         color: AppColors.primary,
              //       ),
              //       SizedBox(width: 20),
              //       Text(
              //         AppStrings.changePassword,
              //         style: TextStyle(
              //           fontSize: 15
              //         ),
              //       )
              //     ],
              //   )
              // ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              children: [
                TextButton(
                  onPressed: onLogoutClick,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(AppColors.errorTransparent),
                    overlayColor: MaterialStateProperty.all(AppColors.errorTransparent),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.logout,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 20
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
          )
        ],
      )
    );
  }
}
