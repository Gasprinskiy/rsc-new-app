import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/routes/auth/auth.dart';
import 'package:test_flutter/routes/auth/children/confirm_email.dart';
import 'package:test_flutter/routes/auth/children/register.dart';
import 'package:test_flutter/routes/auth/children/salary_info.dart';
import 'package:test_flutter/routes/main/main.dart';
import 'package:test_flutter/routes/splash_screen.dart';
import 'package:test_flutter/storage/worker/init.dart';

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
        '/main': (context) => const MainRoute(),
        '/auth': (context) => const AuthRoute(),
        '/auth/register': (context) => const RegisterRoute(),
        '/auth/register/confirm-email': (context) => const ConfirmEmailRoute(),
        '/auth/register/salary-info': (context) => const SalaryInfoRoute()
      },
    );
  }
}
