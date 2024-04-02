import 'package:flutter/material.dart';
import 'package:test_flutter/constants/app_collors.dart';

class DecorationBox extends StatelessWidget {
  const DecorationBox({
    required this.children,
    this.colors = AppColors.defaultGradient,
    this.padding = const EdgeInsets.all(20),
    this.top = 25,
    super.key,
  });

  final List<Color> colors;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final double? top;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: top,
              ),
              ...children,
            ],
          ),
        ));
  }
}
