import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:test_flutter/constants/app_strings.dart';
import 'package:test_flutter/utils/widgets/toast.dart';

Future<T?> handleRequestError<T>(Future<T?> Function() func) async {
  bool hasConnection = await InternetConnectionChecker().hasConnection;
  AppToast toast = AppToast.getInstance();
  if (hasConnection) {
    try {
      return await func();
    } on DioException catch (err) {
      toast.showErrorToast(err.message.toString());
      return null;
    }
  } else {
    toast.showErrorToast(AppStrings.noInternetConnection);
    return null;
  }
}

