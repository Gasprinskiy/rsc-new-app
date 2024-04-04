
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';

class ButtonBox extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  final MaterialStateProperty<EdgeInsetsGeometry?>? padding;
  final Color? color;

  const ButtonBox({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.color
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? AppColors.primaryTransparent,
          borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child: TextButton(
          onPressed: () => onPressed?.call(),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )
            ),
            padding: padding
          ),
          child: child,
        ),
      ),
    );
  }
}

