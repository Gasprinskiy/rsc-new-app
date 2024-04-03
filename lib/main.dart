import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/state/user.dart';
import 'package:rsc/views/auth/auth.dart';
import 'package:rsc/views/auth/children/confirm_email.dart';
import 'package:rsc/views/auth/children/register.dart';
import 'package:rsc/views/auth/children/salary_info.dart';
import 'package:rsc/views/local_auth/create.dart';
import 'package:rsc/views/local_auth/enter.dart';
import 'package:rsc/views/main/main.dart';
import 'package:rsc/views/splash_screen.dart';
import 'package:rsc/storage/hive/entity/init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageInitializer storageInitializer = StorageInitializer();
  await storageInitializer.initStorage();

  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final userState = UserState.getInstance();

  bool _isPaused = false;
  int _updateKey = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        _isPaused = true;
      });
    } 
    if (_isPaused && state == AppLifecycleState.resumed) {
      setState(() {
        if (userState.user?.salaryInfo != null) {
          _updateKey += 1;
        }
        _isPaused = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(_updateKey),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
         GlobalMaterialLocalizations.delegate
       ],
      supportedLocales: const [
        Locale("en", "EN"),
        Locale("RU"),
      ],
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