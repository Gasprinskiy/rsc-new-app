// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:rsc/api/entity/user.dart';
import 'package:rsc/api/worker/worker.dart';
import 'package:rsc/storage/hive/token.dart';

class UserApi {
  static UserApi? _instance;
  final _tokenStorage = TokenStorage.getInstance();
  final _worker = ApiWorker.getInstance();

  UserApi._();

  static UserApi getInstance() {
    _instance ??= UserApi._();
    return _instance!;
  }

  Future<SignUpResult> signup(SignUpParams params) async {
    Response<dynamic> response = await _worker.post('/user/sign_up', {
      'name': params.name,
      'email': params.email,
      'password': params.password
    });

    return SignUpResult(
        userId: response.data['id'],
        date: DateTime.parse(response.data['date']));
  }

  Future<SignInResult> signin(SignInParams params) async {
    Response<dynamic> response = await _worker.post(
        '/user/sign_in', {'email': params.email, 'password': params.password});
    await _tokenStorage.setToken(response.data['access_token']);
    return signInResultFromJson(response.data);
  }

  Future<SignUpResult> requestNewEmailVerificationCode(String email) async {
    Response<dynamic> response = await _worker
        .post('/user/send_email_verification_code', {'email': email});
    return SignUpResult(
        userId: response.data['id'],
        date: DateTime.parse(response.data['date']));
  }

  Future<void> confirmEmail(int userId, String code) async {
    Response<dynamic> response = await _worker.post(
        '/user/confirm_email', {'user_id': userId, 'verification_code': code});
    await _tokenStorage.setToken(response.data['access_token']);
  }

  Future<void> createSalaryInfo(CreateSalaryInfoPayload payload) async {
    Map<String, Object?> jsonPayload = payload.toJson();
    await _worker.post('/user/create_salary_info', jsonPayload);
  }

  Future<void> updateUserSalaryInfo(UpdateUserSalaryInfoParams params) {
    return _worker.post('/user/update_salary_info', params.apiParams);
  }
}
