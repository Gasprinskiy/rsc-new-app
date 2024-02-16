// import 'dart:html';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/api/entity/user.dart';
import 'package:test_flutter/api/token_worker/token_worker.dart';
import 'package:test_flutter/api/worker/worker.dart';

class UserApi {
  ApiWorker worker = ApiWorker();

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
    await TokenWorker().setToken(response.data['access_token']);
    return signInResultFromJson(response.data);
  }

  Future<SignUpResult> requestNewEmailVerificationCode(int id) async {
    Response<dynamic> response =
        await worker.post('/user/send_email_verification_code', {'id': id});
    return SignUpResult(
        userId: response.data['id'],
        date: DateTime.parse(response.data['date']));
  }

  Future<void> confirmEmail(int userId, String code) async {
    Response<dynamic> response = await worker.post(
        '/user/confirm_email', {'user_id': userId, 'verification_code': code});
    await TokenWorker().setToken(response.data['access_token']);
  }
}
