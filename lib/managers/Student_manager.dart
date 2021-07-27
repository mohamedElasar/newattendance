import 'dart:convert';
import 'dart:io';
import 'package:attendance/helper/httpexception.dart';
import 'package:dio/dio.dart';

import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/models/student.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentManager extends ChangeNotifier {
  void receiveToken(Auth_manager auth, List<StudentModel> students) {
    _authToken = auth.token;
    __students = students;
  }

  String? _authToken;
  List<StudentModel> __students = [];
  StudentModel _singleStudent = StudentModel();
  List<StudentModel> get students => __students;
  StudentModel? get singleStudent => _singleStudent;

  get hasmore => _hasMore;
  get pageNumber => _pageNumber;
  get error => _error;
  get loading => _loading;

  bool _hasMore = false;
  int _pageNumber = 1;
  bool _error = false;
  bool _loading = true;

  final int _defaultPerPageCount = 15;

  Future<void> add_student(
    String? name,
    String? email,
    String? phone,
    String? school,
    String? note,
    String? city,
    List<String>? groups,
    String? parent,
    String? relationType,
    String? parentPhone,
    String? parentWhatsapp,
    String? gender,
    String? studyType,
    String? secondLanguage,
    String? discount,
    String? code,
    String? password,
    String? passwordconfirmation,
  ) async {
    try {
      Dio dio = Dio();
      String urld = 'https://development.mrsaidmostafa.com/api/students';

      var params = {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordconfirmation,
        'school': school,
        // 'subject_id': subject,
        'groups': groups,
        'city_id': city,
        'parent': parent,
        'relation_type': relationType,
        'parent_phone': parentPhone,
        'parent_whatsapp': parentWhatsapp,
        'gender': gender,
        'study_type': studyType,
        'discount': discount,
        'code': code,
        'second_language': secondLanguage,
      };
      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';
      var response = await dio.post(urld, data: jsonEncode(params));

      final responseData = response.data;
      print(responseData);
      // if (responseData['errors'] != null) {
      //   print('here');
      //   List<String> errors = [];
      //   for (var value in responseData['errors'].values) errors.add(value[0]);
      //   throw HttpException(errors.join('  '));
    } on DioError catch (e) {
      if (e.response!.data['errors'] != null) {
        print(e.response!.data);
        List<String> errors = [];
        for (var value in e.response!.data['errors'].values)
          errors.add(value[0]);
        throw HttpException(errors.join('  '));
      } else {
        throw (error);
      }
    }

    notifyListeners();
  }

  Future<void> get_students() async {
    var url = Uri.https('development.mrsaidmostafa.com', '/api/students');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      List<dynamic> yearsList = responseData['data'];
      var list = yearsList.map((data) => StudentModel.fromJson(data)).toList();
      __students = list;
      print(responseData);
      // add exception

    } catch (error) {
      print('students');
      print(error);
    }

    notifyListeners();
  }

  Future<void> getMoreDatafiltered(String filter1) async {
    // print(_pageNumber);
    try {
      var url = Uri.https('development.mrsaidmostafa.com', '/api/students', {
        "group_id": filter1,
        "page": _pageNumber.toString(),
      });
      // print(url);
      // print(_pageNumber);
      //
      print(url);
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );

      final responseData = json.decode(response.body);

      List<dynamic> studentsList = responseData['data'];
      var fetchedstudents =
          studentsList.map((data) => StudentModel.fromJson(data)).toList();
      _hasMore = fetchedstudents.length == _defaultPerPageCount;
      _loading = false;
      _pageNumber = _pageNumber + 1;

      __students.addAll(fetchedstudents);
    } catch (e) {
      _loading = false;
      _error = true;
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> getMoreDatafilteredId(String filter1) async {
    // print(_pageNumber);
    try {
      var url = Uri.https('development.mrsaidmostafa.com', '/api/students', {
        "id": filter1,
      });
      // print(url);
      // print(_pageNumber);
      //
      print(url);
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );

      final responseData = json.decode(response.body);

      List<dynamic> studentsList = responseData['data'];
      // var fetchedstudents =
      //     studentsList.map((data) => StudentModel.fromJson(data)).toList();
      var fetchedstudent = StudentModel.fromJson(studentsList[0]);

      // _hasMore = fetchedstudents.length == _defaultPerPageCount;
      // _loading = false;
      // _pageNumber = _pageNumber + 1;

      _singleStudent = fetchedstudent;
      print(fetchedstudent.groups);
    } catch (e) {
      _loading = false;
      _error = true;
      notifyListeners();
    }

    notifyListeners();
  }

  void resetlist() {
    print('object');
    __students = [];
    _loading = true;
    _pageNumber = 1;
    _error = false;
    _loading = true;
    notifyListeners();
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void seterror(bool value) {
    _error = value;
    notifyListeners();
  }

  Future<List<StudentModel>> searchStudent(String filter1) async {
    // print(_pageNumber);
    // try {
    var url = Uri.https('development.mrsaidmostafa.com', '/api/students', {
      "name": filter1,
    });
    // print(_pageNumber);
    //
    print(url);
    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $_authToken'
      },
    );

    final responseData = json.decode(response.body);
    // print(responseData);
    List<dynamic> studentsList = responseData['data'];
    // print(studentsList);
    List<StudentModel> list =
        studentsList.map((data) => StudentModel.fromJson(data)).toList();
    print(list);
    return list;
    // } catch (e) {
    //   throw (error);
    // }
  }

  void setSingleStudent(StudentModel st) {
    _singleStudent = st;
    notifyListeners();
  }
}
