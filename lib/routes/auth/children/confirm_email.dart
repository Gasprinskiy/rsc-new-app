import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/helpers/request_handler.dart';
import 'package:test_flutter/storage/user.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';

class ConfirmEmailRoute extends StatefulWidget {
  const ConfirmEmailRoute({super.key});

  @override
  State<ConfirmEmailRoute> createState() => _ConfirmEmailRouteeState();
}

class _ConfirmEmailRouteeState extends State<ConfirmEmailRoute> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast = FToast();
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
      await UserApi().confirmEmail(_userId, confirmCodeController.text);
      nivagateToMainPage();
    } on DioException catch (err) {
      showErrorStoast(fToast, err.message.toString());
    }
  }

  void nivagateToMainPage() {
    Navigator.pushNamed(context, '/main');
  }

  void reqeustNewCode() {
    setState(() {
      _isNewVerificationCodeRequested = true;
    });

    handleRequestError(
            () => UserApi().requestNewEmailVerificationCode(_userId), fToast)
        .then((SignUpResult? value) => {
              if (value != null)
                {
                  startActivationTimer(value.date).then((_) => {
                        setState(() {
                          Future.delayed(const Duration(seconds: 1))
                              .then((_) => {
                                    setState(() {
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
    getVerificationInfo().then((EmailConfirmation? value) => {
          if (value != null)
            {
              _userId = value.userId,
              startActivationTimer(value.date)
                  .then((_) => {_timerStarted = true})
            }
        });
  }

  Future<EmailConfirmation?> getVerificationInfo() async {
    Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);

    Storage appStorage = Storage(storageInstance: box);
    UserStorage userStorage = UserStorage(storage: appStorage);

    EmailConfirmation? data = await userStorage.getEmailConfirmationData();
    return data;
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
        t.cancel();
      }
    });
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
                      style: TextStyle(fontSize: 15, color: Colors.white))
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
                                      if (_isNewVerificationCodeRequested ==
                                          false)
                                        {fToast.init(context), reqeustNewCode()}
                                    }, // TO:DO make new code request
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
                                    '$_minuterLeft:$_secondsLeft',
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
                            if (_formKey.currentState?.validate() == true &&
                                !_isLoading)
                              {fToast.init(context), confirmEmail()}
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
