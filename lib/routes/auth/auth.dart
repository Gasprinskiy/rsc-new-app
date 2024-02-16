import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_constants.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/helpers/request_handler.dart';
import 'package:test_flutter/storage/user.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';

class AuthRoute extends StatefulWidget {
  const AuthRoute({super.key});

  @override
  State<AuthRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<AuthRoute> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast = FToast();
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

    // check connection
    // ConnectivityResult connectivityResult =
    //     await (Connectivity().checkConnectivity());
    // if (connectivityResult == ConnectivityResult.none) {
    //   showErrorStoast(fToast, AppStrings.noInternetConnection);
    //   return;
    // }
    //

    // make sign in request
    SignInParams signInParams = SignInParams(
        email: emailController.text, password: passwordController.text);
    SignInResult? signInResult =
        await handleRequestError(() => UserApi().signin(signInParams), fToast);
    //

    if (signInResult != null) {
      try {
        // open storage
        Box<dynamic> box = await Hive.openBox(AppStrings.appStorageKey);
        Storage appStorage = Storage(storageInstance: box);
        UserStorage userStorage = UserStorage(storage: appStorage);
        //

        // put user data into storage
        PersonalInfo personalInfo = PersonalInfo(
            name: signInResult.personalInfo.name,
            email: signInResult.personalInfo.email,
            isEmailConfirmed: true,
            isEmailConfirmSciped: false);

        User user = User(
          personalInfo: personalInfo,
        );

        if (signInResult.salaryInfo != null) {
          user.salaryInfo = SalaryInfo(
              salary: signInResult.salaryInfo!.salary,
              percentFromSales: signInResult.salaryInfo!.percentFromSales,
              plan: signInResult.salaryInfo!.plan,
              ignorePlan: signInResult.salaryInfo!.ignorePlan);
        }

        List<PercentChangeConditions> percentChangeConditions = [];
        if (signInResult.percentChangeConditions != null) {
          for (var element in signInResult.percentChangeConditions!) {
            percentChangeConditions.add(PercentChangeConditions(
                percentGoal: element.percentGoal,
                percentChange: element.percentChange,
                salaryBonus: element.salaryBonus));
          }
        }

        if (percentChangeConditions.isNotEmpty) {
          user.percentChangeConditions = percentChangeConditions;
        }

        await userStorage.putUserInfo(user);
        await box.close();
        //

        // nagigate to home page
        navigateToSplashScreen();
        //
      } on HiveError catch (_) {
        showErrorStoast(fToast, AppStrings.errOnWritingData);
      }
    }

    setState(() {
      _isLoading = false;
    });
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
                      if (_formKey.currentState?.validate() == true &&
                          !_isLoading)
                        {fToast.init(context), signIn()}
                    },
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
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/auth/register')},
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
