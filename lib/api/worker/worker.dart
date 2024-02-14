import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_flutter/api/helpers/error_handler.dart';

Dio initDio() {
  Dio dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3000'));
  dio.interceptors.add(InterceptorsWrapper(
    onResponse: (response, handler) => {handler.next(response)},
    onError: (error, handler) => {
      if (error.response?.statusCode == 302)
        {
          throw DioException(
              requestOptions: error.requestOptions,
              message: createErrorMessage('no-server-connection'))
        },
      handler.next(DioException(
          requestOptions: error.requestOptions,
          message: createErrorMessage(error.response!.data['message'])))
    },
  ));
  return dio;
}

class ApiWorker {
  final _dio = initDio();

  Future<Response> get(String path, Map<String, Object>? params) async {
    return _dio.get('/$path', queryParameters: params);
  }

  Future<Response> post(String path, Map<String, Object?> payload) async {
    return _dio.post(path,
        data: jsonEncode({'params': payload}),
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }));
  }
}
