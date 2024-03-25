// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/worker/worker.dart';
import 'package:test_flutter/storage/hive/token.dart';

class UserApi {
  TokenStorage tokenStorage = TokenStorage();
  final worker = ApiWorker.getInstance();

  Future<SignUpResult> signup(SignUpParams params) async {
    Response<dynamic> response = await worker.post('/user/sign_up', {
      'name': params.name,
      'email': params.email,
      'password': params.password
    });

    return SignUpResult(
        userId: response.data['id'],
        date: DateTime.parse(response.data['date']));
  }

  Future<SignInResult> signin(SignInParams params) async {
    Response<dynamic> response = await worker.post(
        '/user/sign_in', {'email': params.email, 'password': params.password});
    await tokenStorage.setToken(response.data['access_token']);
    return signInResultFromJson(response.data);
  }

  Future<SignUpResult> requestNewEmailVerificationCode(String email) async {
    Response<dynamic> response = await worker
        .post('/user/send_email_verification_code', {'email': email});
    return SignUpResult(
        userId: response.data['id'],
        date: DateTime.parse(response.data['date']));
  }

  Future<void> confirmEmail(int userId, String code) async {
    Response<dynamic> response = await worker.post(
        '/user/confirm_email', {'user_id': userId, 'verification_code': code});
    await tokenStorage.setToken(response.data['access_token']);
  }

  Future<void> createSalaryInfo(CreateSalaryInfoPayload payload) async {
    Map<String, Object?> jsonPayload = payload.toJson();
    await worker.post('/user/create_salary_info', jsonPayload);
  }
}
