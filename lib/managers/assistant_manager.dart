import 'dart:convert';
import 'package:attendance/helper/httpexception.dart';

import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/models/assistant.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class AssistantManager extends ChangeNotifier {
  void receiveToken(Auth_manager auth, List<AssistantModel> assistants) {
    _authToken = auth.token;
    _assistants = assistants;
  }

  String? _authToken;
  List<AssistantModel> _assistants = [];
  List<AssistantModel> get assistants => _assistants;

  Future<void> add_assistant(
    String? name,
    String? phone,
    String? email,
    String? password,
    String? passwordConfirmation,
    String? note,
    String? teacherId,
    int? level,
  ) async {
    try {
      Dio dio = Dio();
      String urld = 'https://development.mrsaidmostafa.com/api/assistants';
      var params = {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'note': note,
        'teacher_id': teacherId,
        'premier': level,
      };
      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';

      var response = await dio.post(urld, data: jsonEncode(params));

      final responseData = response.data;
      print(responseData);
    } on DioError catch (e) {
      if (e.response!.data['errors'] != null) {
        print(e.response!.data);
        List<String> errors = [];
        for (var value in e.response!.data['errors'].values)
          errors.add(value[0]);
        throw HttpException(errors.join('  '));
      }
    } catch (e) {
      throw (e);
    }

    notifyListeners();
  }
}
