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
import 'package:test_flutter/storage/hive/entity/init.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthRoute(),
        '/auth/register': (context) => const RegisterRoute(),
        '/auth/register/confirm-email': (context) => const ConfirmEmailRoute(),
        '/auth/register/salary-info': (context) => const SalaryInfoRoute(),
        '/create_local_auth': (context) => const CreateLocalAuthRoute(),
        '/local_auth': (context) => const LocalAuthRoute(),
        '/main': (context) => const MainRoute(),
      },
    );
  }
}
