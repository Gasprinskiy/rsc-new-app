import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rsc/api/entity/user.dart';
import 'package:rsc/api/user.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_constants.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/widgets/app_text_form_field.dart';
import 'package:rsc/constants/app_theme.dart';
import 'package:rsc/helpers/request_handler.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/storage/hive/entity/adapters.dart';
import 'package:rsc/widgets/decoration_box.dart';
import 'package:rsc/widgets/toast.dart';

class RegisterRoute extends StatefulWidget {
  
  const RegisterRoute({super.key});

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _formKey = GlobalKey<FormState>();
  final toast = AppToast.getInstance();
  final userState = UserState.getInstance();
  final userApi = UserApi.getInstance();
  bool _isLoading = false;
  final bool _skipEmailConfrimation = false;

  final ValueNotifier<bool> passwordNotifier = ValueNotifier(true);
  final ValueNotifier<bool> fieldValidNotifier = ValueNotifier(false);
  final ValueNotifier<bool> confirmPasswordNotifier = ValueNotifier(true);

  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  void initializeControllers() {
    emailController = TextEditingController()..addListener(controllerListener);
    passwordController = TextEditingController()
      ..addListener(controllerListener);
    confirmPasswordController = TextEditingController()
      ..addListener(controllerListener);
    nameController = TextEditingController()..addListener(controllerListener);
  }

  void disposeControllers() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  void controllerListener() {
    final email = emailController.text;
    final password = passwordController.text;
    final cofirmPassword = confirmPasswordController.text;
    final name = nameController.text;

    if (email.isEmpty &&
        password.isEmpty &&
        name.isEmpty &&
        (password != cofirmPassword)) return;

    if (AppConstants.emailRegex.hasMatch(email)) {
      fieldValidNotifier.value = true;
    } else {
      fieldValidNotifier.value = false;
    }
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

  Future<void> signUp() async {
    setState(() {
      _isLoading = true;
    });

    if (_skipEmailConfrimation == false) {
      // make sign in request
      SignUpParams signUpParams = SignUpParams(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text
      );
      SignUpResult? signUpResult = await handleRequestError(
        () => userApi.signup(signUpParams)
      );
      //
      if (signUpResult != null) {
        try {
          // write email confirmation info
          await userState.setEmailConfirmationInfo(EmailConfirmation(
              userId: signUpResult.userId, date: signUpResult.date));
          //
          try {
            await userState.updateUserState(User(
                personalInfo: PersonalInfo(
                    name: nameController.text,
                    email: emailController.text,
                    isEmailConfirmSciped: _skipEmailConfrimation,
                    isEmailConfirmed: false)));
            navigateToConfirmEmail();
          } on HiveError catch (_) {
            toast.showErrorToast(ErrorStrings.errOnWritingData);
            setState(() {
              _isLoading = false;
            });
            return;
          }
        } on HiveError catch (_) {
          toast.showErrorToast(ErrorStrings.errOnWritingData);
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
    } else {
      try {
        await userState.updateUserState(User(
            personalInfo: PersonalInfo(
                name: nameController.text,
                email: emailController.text,
                isEmailConfirmSciped: _skipEmailConfrimation,
                isEmailConfirmed: false)));
        navigateToSalaryInfo();
      } on HiveError catch (_) {
        toast.showErrorToast(ErrorStrings.errOnWritingData);
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void navigateToConfirmEmail() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/register/confirm-email', (Route<dynamic> route) => false);
  }

  void navigateToSalaryInfo() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/auth/register/salary-info', (Route<dynamic> route) => false);
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return AppColors.primary;
    }
    return Colors.grey;
  }

  // AlertDialog confirmEmailSkipDialog(BuildContext context) {
  //   return AlertDialog(
  //     title: const Text(CommonStrings.areYouSure),
  //     content:
  //         const Text(AuthAndRegisterPageStrings.emailConfirmSkipDescription),
  //     actions: [
  //       TextButton(
  //         onPressed: () => {Navigator.of(context).pop()},
  //         child: const Text(CommonStrings.cancel),
  //       ),
  //       TextButton(
  //         onPressed: () =>
  //             {_skipEmailConfrimation = true, Navigator.of(context).pop()},
  //         child: const Text(CommonStrings.cancel),
  //       ),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: [
      const DecorationBox(
        children: [
          Text(AuthAndRegisterPageStrings.registration,
              style: AppTheme.titleLarge),
          SizedBox(height: 10),
          Text(
            AuthAndRegisterPageStrings.createAccount,
            style: AppTheme.bodySmall,
          ),
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
                controller: nameController,
                labelText: AuthAndRegisterPageStrings.name,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return value!.isEmpty
                      ? CommonStrings.fieldCannotBeEmpty
                      : null;
                },
              ),
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
                          ? CommonStrings.fieldCannotBeEmpty
                          : value != confirmPasswordController.text
                              ? AppStrings.passwordDoesNotMatch
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
              ValueListenableBuilder(
                valueListenable: confirmPasswordNotifier,
                builder: (_, passwordObscure, __) {
                  return AppTextFormField(
                    obscureText: passwordObscure,
                    controller: confirmPasswordController,
                    labelText: AppStrings.confirmPasswor,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      return value!.isEmpty
                          ? AppStrings.pleaseConfirmPasswor
                          : value != passwordController.text
                              ? AppStrings.passwordDoesNotMatch
                              : null;
                    },
                    suffixIcon: IconButton(
                      onPressed: () =>
                          confirmPasswordNotifier.value = !passwordObscure,
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
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: fieldValidNotifier,
                builder: (_, isValid, __) {
                  return FilledButton(
                    onPressed: () => {
                      if (_formKey.currentState?.validate() == true && !_isLoading){
                        toast.init(context), 
                        signUp()
                      }
                    },
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(AppStrings.regiserMe),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ]));
  }
}
