import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test_flutter/helpers/toasts.dart';

Future<T?> handleRequestError<T>(
    Future<T> Function() func, FToast toast) async {
  try {
    return await func();
  } on DioException catch (err) {
    showErrorToast(toast, err.message.toString());
    return null;
  }
}
