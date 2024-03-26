import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/helpers/request_handler.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/storage/hive/entity/adapters.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';
import 'package:test_flutter/utils/widgets/toast.dart';

class ConfirmEmailRoute extends StatefulWidget {
  
  const ConfirmEmailRoute({super.key});

  @override
  State<ConfirmEmailRoute> createState() => _ConfirmEmailRouteeState();
}

class _ConfirmEmailRouteeState extends State<ConfirmEmailRoute> {
  final _formKey = GlobalKey<FormState>();
  final toast = AppToast.getInstance();
  final userState = UserState.getInstance();
  final userApi = UserApi.getInstance();
  final bool _isLoading = false;

  num _minuterLeft = 0;
  num _secondsLeft = 0;
  bool _isVerificationCodeExpited = false;
  bool _timerStarted = false;
  bool _isNewVerificationCodeRequested = false;
  int _userId = 0;

  late final TextEditingController confirmCodeController;

  void initializeControllers() {
    confirmCodeController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    confirmCodeController.dispose();
  }

  void controllerListener() {
    final confirmCode = confirmCodeController.text;

    if (confirmCode.isEmpty) return;
  }

  @override
  initState() {
    super.initState();
    setVerificationInfo();
    initializeControllers();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> confirmEmail() async {
    try {
      await userApi.confirmEmail(_userId, confirmCodeController.text);
      await userState.removeEmailConfirmationInfo();
      User? user = userState.getUserInstanse();
      if (user != null) {
        user.personalInfo.isEmailConfirmed = true;
        await userState.updateUserState(user);
      }
      nivagateToSalaryInfo();
    } on DioException catch (err) {
      toast.showErrorToast(err.message.toString());
    }
  }

  void nivagateToSalaryInfo() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/register/salary-info', (Route<dynamic> route) => false);
  }

  void requestNewCode() {
    setState(() {
      _isNewVerificationCodeRequested = true;
    });
    String email = userState.user!.personalInfo.email;
    handleRequestError(
            () => userApi.requestNewEmailVerificationCode(email))
        .then((SignUpResult? value) async => {
              if (value != null)
                {
                  await userState.setEmailConfirmationInfo(EmailConfirmation(
                      userId: value.userId, date: value.date)),
                  startActivationTimer(value.date).then((_) => {
                        setState(() {
                          Future.delayed(const Duration(seconds: 1))
                              .then((_) => {
                                    setState(() {
                                      _userId = value.userId;
                                      _isVerificationCodeExpited = false;
                                      _isNewVerificationCodeRequested = false;
                                    })
                                  });
                        })
                      })
                }
              else
                {
                  setState(() {
                    _isNewVerificationCodeRequested = false;
                  }),
                }
            });
  }

  void setVerificationInfo() {
    EmailConfirmation? info = userState.verificationInfo;
    if (info != null) {
      _userId = info.userId;
      startActivationTimer(info.date).then((_) => {_timerStarted = true});
    } else {
      String email = userState.user!.personalInfo.email;
      handleRequestError(
              () => userApi.requestNewEmailVerificationCode(email))
          .then((value) async => {
                if (value != null)
                  {
                    await userState.setEmailConfirmationInfo(EmailConfirmation(
                        userId: value.userId, date: value.date)),
                    startActivationTimer(value.date).then((_) => {
                          setState(() {
                            Future.delayed(const Duration(seconds: 2))
                                .then((_) => {
                                      setState(() {
                                        _userId = value.userId;
                                        _timerStarted = true;
                                      })
                                    });
                          })
                        })
                  }
              });
    }
  }

  Future<void> startActivationTimer(DateTime creationDate) async {
    DateTime expirationDate = creationDate.add(const Duration(minutes: 10));
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      Duration remainingTime = expirationDate.difference(DateTime.now());
      setState(() {
        _minuterLeft = remainingTime.inMinutes.remainder(60);
        _secondsLeft = remainingTime.inSeconds.remainder(60);
      });
      if (remainingTime.inSeconds <= 0) {
        setState(() {
          _isVerificationCodeExpited = true;
        });
        userState.removeEmailConfirmationInfo();
        t.cancel();
      }
    });
  }

  String get _secondsLeftFormat {
    if (_secondsLeft < 10) {
      return '0$_secondsLeft';
    }
    return '$_secondsLeft';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _timerStarted
          ? ListView(padding: EdgeInsets.zero, children: [
              const DecorationBox(
                children: [
                  Text(AppStrings.confirmYourEmail,
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 10),
                  Text(AppStrings.confirmationCodeWasSentToYourEmail,
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: Colors.orange,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Flexible(
                          child: Text(AppStrings.confirmationCodeCouldBeInSpam,
                              style: TextStyle(
                                color: Colors.orange,
                              )))
                    ],
                  )
                ],
              ),
              Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        AppTextFormField(
                          controller: confirmCodeController,
                          labelText: AppStrings.verificationCode,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return value!.isEmpty
                                ? AppStrings.pleaseEnterConfirmationCode
                                : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isVerificationCodeExpited
                            ? TextButton(
                                onPressed: () => {
                                  if (_isNewVerificationCodeRequested == false) {
                                    toast.init(context), 
                                    requestNewCode()
                                  }
                                },
                                child: _isNewVerificationCodeRequested
                                    ? const CircularProgressIndicator(
                                        color: AppColors.primary,
                                      )
                                    : const Text(
                                        AppStrings.requestNewCode,
                                        style:
                                            TextStyle(color: AppColors.primary),
                                      ))
                            : Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    AppStrings.confirmationCodeExpiresIn,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    '$_minuterLeft:$_secondsLeftFormat',
                                    textWidthBasis: TextWidthBasis.longestLine,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        color: AppColors.primary),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 20),
                        FilledButton(
                          onPressed: () => {
                            if (_formKey.currentState?.validate() == true && !_isLoading){
                              toast.init(context), 
                              confirmEmail()
                            }
                          },
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(AppStrings.confirm),
                        )
                      ],
                    ),
                  ))
            ])
          : const Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.primary,
                color: Colors.white,
              ),
            ),
    );
  }
}
