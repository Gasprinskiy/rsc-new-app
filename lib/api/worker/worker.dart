import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rsc/api/tools/error_handler.dart';
import 'package:rsc/storage/hive/token.dart';

TokenStorage tokenStorage = TokenStorage.getInstance();

Dio initDio() {
  Dio dio = Dio(BaseOptions(
    // baseUrl: 'http://retailer-salary-counter.uz',
    baseUrl: 'http://10.0.2.2:3000',
    // baseUrl: 'http://127.0.0.1:3000',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) => {
      tokenStorage.getToken().then((value) => {
        if (value != null) {
          options.headers['authorization'] = value,
        },
        handler.next(options)
      })
    },
    onError: (error, handler) => {
      handler.next(DioException(
        requestOptions: error.requestOptions,
        message: createErrorMessage(
          (error.response?.statusCode == 302 || error.response?.statusCode == null)
            ?
          'no-server-connection'
            :
          error.response!.data['message']
        )
      )
    )
    },
  ));
  return dio;
}


class ApiWorker {
  static ApiWorker? _instance;
  final _dio = initDio();
  final _reqOptions = Options(
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
    },
  );

  ApiWorker._();

  static ApiWorker getInstance() {
    _instance ??= ApiWorker._();
    return _instance!;
  }

  Future<Response> get(String path, Map<String, Object?>? payload, Map<String, Object>? query) async {
    return _dio.get(path, 
      queryParameters: query, 
      data: jsonEncode({'params': payload}),
      options: _reqOptions
    );
  }

  Future<Response> post(String path, Map<String, Object?> payload) async {
    return _dio.post(path,
      data: jsonEncode({'params': payload}),
      options: _reqOptions
    );
  }
}
