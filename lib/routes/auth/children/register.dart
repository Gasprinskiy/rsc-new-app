import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/user.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_constants.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_text_form_field.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/helpers/request_handler.dart';
import 'package:test_flutter/storage/user.dart';
import 'package:test_flutter/storage/worker/adapters/user_adapter.dart';
import 'package:test_flutter/storage/worker/worker.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';

class RegisterRoute extends StatefulWidget {
  const RegisterRoute({super.key});

  @override
  State<RegisterRoute> createState() => _RegisterRouteState();
}

class _RegisterRouteState extends State<RegisterRoute> {
  final _formKey = GlobalKey<FormState>();
  FToast fToast = FToast();
  bool _isLoading = false;
  bool _skipEmailConfrimation = false;

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

    // open storage
    Box<dynamic> box = await Hive.openBox(StorageKeys.appStorageKey);
    Storage appStorage = Storage(storageInstance: box);
    UserStorage userStorage = UserStorage(storage: appStorage);
    //

    if (_skipEmailConfrimation == false) {
      // // check connection
      // ConnectivityResult connectivityResult =
      //     await (Connectivity().checkConnectivity());
      // if (connectivityResult == ConnectivityResult.none) {
      //   showErrorStoast(fToast, AppStrings.noInternetConnection);
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   return;
      // }
      // //

      // make sign in request
      SignUpParams signUpParams = SignUpParams(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text);
      SignUpResult? signUpResult = await handleRequestError(
          () => UserApi().signup(signUpParams), fToast);
      //

      if (signUpResult != null) {
        try {
          // write email confirmation info
          await userStorage.setEmailConfirmation(EmailConfirmation(
              userId: signUpResult.userId, date: signUpResult.date));
          //
          try {
            await userStorage.putUserInfo(User(
                personalInfo: PersonalInfo(
                    name: nameController.text,
                    email: emailController.text,
                    isEmailConfirmSciped: _skipEmailConfrimation,
                    isEmailConfirmed: false)));
            navigateToConfirmEmail();
          } on HiveError catch (_) {
            showErrorStoast(fToast, ErrorStrings.errOnWritingData);
            setState(() {
              _isLoading = false;
            });
            return;
          }
        } on HiveError catch (_) {
          showErrorStoast(fToast, ErrorStrings.errOnWritingData);
          setState(() {
            _isLoading = false;
          });
          return;
        }
      }
    } else {
      try {
        await userStorage.putUserInfo(User(
            personalInfo: PersonalInfo(
                name: nameController.text,
                email: emailController.text,
                isEmailConfirmSciped: _skipEmailConfrimation,
                isEmailConfirmed: false)));
        navigateToSalaryInfo();
      } on HiveError catch (_) {
        showErrorStoast(fToast, ErrorStrings.errOnWritingData);
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
    Navigator.pushNamed(context, '/auth/register/confirm-email');
  }

  void navigateToSalaryInfo() {
    Navigator.pushNamed(context, '/auth/register/salary-info');
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

  AlertDialog confirmEmailSkipDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(CommonStrings.areYouSure),
      content:
          const Text(AuthAndRegisterPageStrings.emailConfirmSkipDescription),
      actions: [
        TextButton(
          onPressed: () => {Navigator.of(context).pop()},
          child: const Text(CommonStrings.cancel),
        ),
        TextButton(
          onPressed: () =>
              {_skipEmailConfrimation = true, Navigator.of(context).pop()},
          child: const Text(CommonStrings.cancel),
        ),
      ],
    );
  }

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
              CheckboxListTile(
                  contentPadding: const EdgeInsets.all(5),
                  value: _skipEmailConfrimation,
                  title: const Text(
                    AppStrings.skipEmailConfrimation,
                    style: TextStyle(fontSize: 15.0),
                  ),
                  checkColor: Colors.white,
                  activeColor: AppColors.primary,
                  onChanged: (_) => {
                        if (_skipEmailConfrimation == false)
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(CommonStrings.areYouSure),
                                    content: const Text(
                                        AppStrings.emailConfirmSkipDescription),
                                    actions: [
                                      TextButton(
                                        onPressed: () => {
                                          Navigator.of(context).pop(),
                                          setState(() {
                                            _skipEmailConfrimation = false;
                                          })
                                        },
                                        child: const Text(CommonStrings.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () => {
                                          Navigator.of(context).pop(),
                                          setState(() {
                                            _skipEmailConfrimation = true;
                                          })
                                        },
                                        child:
                                            const Text(CommonStrings.confirm),
                                      ),
                                    ],
                                  );
                                }),
                          }
                        else
                          {
                            setState(() {
                              _skipEmailConfrimation = false;
                            })
                          }
                      }),
              const SizedBox(height: 20),
              ValueListenableBuilder(
                valueListenable: fieldValidNotifier,
                builder: (_, isValid, __) {
                  return FilledButton(
                    onPressed: () => {
                      if (_formKey.currentState?.validate() == true &&
                          !_isLoading)
                        {fToast.init(context), signUp()}
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
