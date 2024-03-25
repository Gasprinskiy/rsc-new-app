import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/constants/app_collors.dart';
import 'package:test_flutter/constants/app_theme.dart';

void showErrorToast(FToast toast, String msg) {
  toast.showToast(
    toastDuration: AppTheme.toastDuration,
    child: toastChild(AppColors.error, Icons.error, msg),
  );
}

void showWarnToast(FToast toast, String msg) {
  toast.showToast(
    toastDuration: AppTheme.toastDuration,
    child: toastChild(AppColors.warn, Icons.warning_amber_rounded, msg),
  );
}

void showCustomToast(
  FToast toast, 
  Color color, 
  IconData icon, 
  String msg
) {
  toast.showToast(
    toastDuration: AppTheme.toastDuration,
    child: toastChild(color, icon, msg),
  );
}

Material toastChild(Color color, IconData icon, String msg) {
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
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 18.0, 
                    height: 1.3, 
                    fontWeight: FontWeight.w400
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
      ) 
  );
}