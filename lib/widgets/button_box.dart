
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';

class ButtonBox extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;

  const ButtonBox({
    super.key,
    required this.child,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.primaryTransparent,
          borderRadius: BorderRadius.all(Radius.circular(5))
        ),
        child: TextButton(
          onPressed: () => onPressed?.call(),
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )
            )
          ),
          child: child,
        ),
      ),
    );
  }
}

