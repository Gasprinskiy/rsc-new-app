import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rsc/api/accounting.dart';
import 'package:rsc/api/entity/accounting.dart';
import 'package:rsc/api/entity/user.dart';
import 'package:rsc/api/tools/error_handler.dart';
import 'package:rsc/api/user.dart';
import 'package:rsc/constants/app_constants.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/widgets/app_text_form_field.dart';
import 'package:rsc/constants/app_theme.dart';
import 'package:rsc/helpers/request_handler.dart';
import 'package:rsc/state/accounting.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/widgets/decoration_box.dart';
import 'package:rsc/widgets/toast.dart';

class AuthRoute extends StatefulWidget {
  
  const AuthRoute({super.key});

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  final _formKey = GlobalKey<FormState>();
  final toast = AppToast.getInstance();
  final userState = UserState.getInstance();
  final accountingState = AccountingState.getInstance();
  final userApi = UserApi.getInstance();
  final accountingApi = AccountingApi.getInstance();
  bool _isLoading = false;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);

  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
  }

  void disposeControllers() {
    emailController.dispose();
    passwordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;

    if (email.isEmpty && password.isEmpty) return;

    fieldValidNotifier.value = AppConstants.emailRegex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  Future<void> signIn() async {
    setState(() {
      _isLoading = true;
    });

    // make sign in request
    SignInParams signInParams = SignInParams(
      email: emailController.text, 
      password: passwordController.text
    );
    SignInResult? signInResult = await handleRequestError(() => userApi.signin(signInParams));
    //

    if (signInResult != null) {
      try {
        // save user data
        await userState.initUserStateFromSignInResult(signInResult);
        //
        // get current report
        try {
          ApiReport? currentReport = await accountingApi.getCurrentReport();
          if (currentReport != null) {
            await accountingState.initAccountingStateFromApiResult(currentReport);
          }
          setState(() {
            _isLoading = false;
          });
          // nagigate to home page
          navigateToSplashScreen();
          //
        } on DioException catch(err) {
          if (err.message.toString() != errMap['no-content'] && err.message != null) {
            toast.showErrorToast(err.message.toString());
          } else {
            setState(() {
              _isLoading = false;
            });
            // nagigate to home page
            navigateToSplashScreen();
            //
          }
        }
      } on HiveError catch (_) {
        setState(() {
          _isLoading = false;
        });
        toast.showErrorToast(AppStrings.errOnWritingData);
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      return;
    }
  }

  void navigateToSplashScreen() {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
      const DecorationBox(
        children: [
          Text(AppStrings.wellcome, style: AppTheme.titleLarge),
          SizedBox(height: 10),
          Text(AppStrings.loginToYouAccount, style: AppTheme.bodySmall),
        ],
      ),
      Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppTextFormField(
                controller: emailController,
                labelText: AppStrings.email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return value!.isEmpty
                      ? AppStrings.pleaseEnterEmailAddress
                      : AppConstants.emailRegex.hasMatch(value)
                          ? null
                          : AppStrings.invalidEmailAddress;
                },
              ),
              ValueListenableBuilder(
                valueListenable: passwordNotifier,
                builder: (_, passwordObscure, __) {
                  return AppTextFormField(
                    obscureText: passwordObscure,
                    controller: passwordController,
                    labelText: AppStrings.password,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseEnterPassword
                          : null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () =>
                          passwordNotifier.value = !passwordObscure,
                      style: IconButton.styleFrom(
                        minimumSize: const Size.square(48),
                      ),
                      icon: Icon(
                        passwordObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 20,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
              const TextButton(
                onPressed: null,
                child: Text(AppStrings.forgotPassword),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: fieldValidNotifier,
                builder: (_, isValid, __) {
                  return FilledButton(
                    onPressed: () => {
                      if (_formKey.currentState?.validate() == true && !_isLoading){
                        toast.init(context), 
                        signIn()
                      }
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        AppTheme.buttonBorderRadius
                      )
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(AppStrings.login),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      AppStrings.or,
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade200)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/auth/register');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        AppTheme.buttonBorderRadius
                      )
                    ),
                    child: const Text(AppStrings.register),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
