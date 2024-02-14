import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/constants/app_theme.dart';
import 'package:test_flutter/utils/widgets/decoration_box.dart';

class SalaryInfoRoute extends StatefulWidget {
  const SalaryInfoRoute({super.key});

  @override
  State<SalaryInfoRoute> createState() => _SalaryInfoRouteState();
}

class _SalaryInfoRouteState extends State<SalaryInfoRoute> {
  String state = 'Some salary info';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(padding: EdgeInsets.zero, children: const [
      DecorationBox(
        children: [
          Text(AppStrings.typeYourSalaryInfo, style: AppTheme.titleLarge),
          SizedBox(height: 10),
        ],
      ),
    ]));
  }
}
