import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_theme.dart';

void showErrorToast(FToast toast, String msg) {
  toast.showToast(
      toastDuration: AppTheme.toastDuration,
      child: Material(
        borderRadius: AppTheme.toastBorderRadius,
        color: AppColors.error,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(width: 10),
            const Icon(
              Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                msg,
                style: const TextStyle(
                    color: Colors.white, fontSize: 16.0, height: 1.3),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ));
}
