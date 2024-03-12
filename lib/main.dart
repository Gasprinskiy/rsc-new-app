import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/views/auth/auth.dart';
import 'package:test_flutter/views/auth/children/confirm_email.dart';
import 'package:test_flutter/views/auth/children/register.dart';
import 'package:test_flutter/views/auth/children/salary_info.dart';
import 'package:test_flutter/views/local_auth/create.dart';
import 'package:test_flutter/views/local_auth/enter.dart';
import 'package:test_flutter/views/main/main.dart';
import 'package:test_flutter/views/splash_screen.dart';
import 'package:test_flutter/state/user.dart';
import 'package:test_flutter/storage/hive/worker/init.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageInitializer storageInitializer = StorageInitializer();
  await storageInitializer.initStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    UserState userState = UserState();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => SplashScreen(userState: userState),
        '/auth': (context) => AuthRoute(userState: userState),
        '/auth/register': (context) => RegisterRoute(userState: userState),
        '/auth/register/confirm-email': (context) =>
            ConfirmEmailRoute(userState: userState),
        '/auth/register/salary-info': (context) =>
            SalaryInfoRoute(userState: userState),
        '/create_local_auth': (context) =>
            CreateLocalAuthRoute(userState: userState),
        '/local_auth': (context) => LocalAuthRoute(userState: userState),
        '/main': (context) => MainRoute(userState: userState),
      },
    );
  }
}
