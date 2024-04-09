import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rsc/constants/app_collors.dart';
import 'package:rsc/constants/app_theme.dart';

class AppToast {
  static AppToast? _instance;
  FToast toast = FToast();

  AppToast._();

  static AppToast getInstance() {
    _instance ??= AppToast._();
    return _instance!;
  }

  init(BuildContext context) {
    toast.init(context);
  }

  void showErrorToast(String msg) {
    toast.showToast(
      toastDuration: AppTheme.toastDuration,
      child: _toastChild(AppColors.error, Icons.error, msg),
    );
  }

  void showWarnToast(String msg) {
    toast.showToast(
      toastDuration: AppTheme.toastDuration,
      child: _toastChild(AppColors.warn, Icons.warning_amber_rounded, msg),
    );
  }

  void showSuccessToast(String msg) {
    toast.showToast(
      toastDuration: AppTheme.toastDuration,
      child: _toastChild(AppColors.success, Icons.done, msg),
    );
  }

  void showCustomToast(Color color, IconData icon, String msg) {
    toast.showToast(
      toastDuration: AppTheme.toastDuration,
      child: _toastChild(color, icon, msg),
    );
  }

  Material _toastChild(Color color, IconData icon, String msg) {
    return Material(
        borderRadius: AppTheme.toastBorderRadius,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(width: 10),
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  msg,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0, height: 1.3, fontWeight: FontWeight.w400),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ));
  }
}
