import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_strings.dart';
import 'package:rsc/widgets/decoration_box.dart';

class CommonSalaryBox extends StatelessWidget {
  final double commonSalary;

  const CommonSalaryBox({super.key, required this.commonSalary});

  @override
  Widget build(BuildContext context) {
    return DecorationBox(
      top: 0,
      children: [
        const Text(
          AppStrings.commonSalary,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        AnimatedDigitWidget(
          key: key,
          value: commonSalary,
          enableSeparator: true,
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 38,
          ),
          duration: const Duration(milliseconds: 500),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
