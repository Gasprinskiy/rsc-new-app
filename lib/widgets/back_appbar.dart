
import 'package:flutter/material.dart';
import 'package:rsc/constants/app_collors.dart';

class BackAppBar extends StatelessWidget {
  final Widget? title;
  
  const BackAppBar({
    super.key,
    required this.title
  });

  void navigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.primary),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => navigateBack(context),
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded, 
                          color: Colors.white
                        )
                      ),
                      title ?? const SizedBox()
                    ],
                  )
                ]
              )    
            ],
          ),
        );
  }
}