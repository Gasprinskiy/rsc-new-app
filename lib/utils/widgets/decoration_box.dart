import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';

class DecorationBox extends StatelessWidget {
  const DecorationBox({
    required this.children,
    this.colors = AppColors.defaultGradient,
    super.key,
  });

  final List<Color> colors;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 25,
              ),
              ...children,
            ],
          ),
        ));
  }
}
