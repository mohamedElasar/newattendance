import 'dart:convert';
import 'dart:io';
import 'package:attendance/helper/httpexception.dart';

import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/models/StudentModelSimple.dart';
import 'package:attendance/models/appointment.dart';
// ignore: unused_import
import 'package:attendance/models/stage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppointmentManager extends ChangeNotifier {
  void receiveToken(Auth_manager auth, List<AppointmentModel> appointments) {
    authToken = auth.token;
    _appointments = appointments;
  }

  String? authToken;
  List<AppointmentModel> _appointments = [];
  List<AppointmentModel> _appointmentsshow = [];
  AppointmentModel? _currentApp = AppointmentModel();
  List<StudentModelSimple> _students_attend = [];
  List<StudentModelSimple> get student_attend => _students_attend;

  List<AppointmentModel>? get appointments => _appointments;
  List<AppointmentModel>? get appointmentsshow => _appointmentsshow;
  AppointmentModel? get currentapp => _currentApp;
  // get hasmore => _hasMore;
  // get pageNumber => _pageNumber;
  get error => _error;
  get loading => _loading;

  // bool _hasMore = false;
  // int _pageNumber = 1;
  bool _error = false;
  bool _loading = true;

  // final int _defaultPerPageCount = 15;

  Future<void> get_appointments(String groupid) async {
    var url =
        Uri.https('development.mrsaidmostafa.com', '/api/groups/$groupid');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $authToken'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData['data']['appointments'][0]);
      print(url);
      // print(responseData['data']['appointments']);
      List appointments = responseData['data']['appointments'];
      print(appointments);
      List<AppointmentModel> list =
          appointments.map((data) => AppointmentModel.fromJson(data)).toList();
      _appointments = list;
      _loading = false;

      // add exception

    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  Future<void> get_appointmentsshow(String groupid) async {
    var url =
        Uri.https('development.mrsaidmostafa.com', '/api/groups/$groupid');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $authToken'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData['data']['appointments']);
      List<dynamic> appointments = responseData['data']['appointments'];
      List<AppointmentModel> list =
          appointments.map((data) => AppointmentModel.fromJson(data)).toList();
      _appointmentsshow = list;
      _loading = false;
      print(_appointmentsshow);

      // add exception

    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  Future<void> get_students_attending_lesson(
      String groupid, String lessonid) async {
    var url =
        Uri.https('development.mrsaidmostafa.com', '/api/groups/$groupid');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $authToken'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData['data']['appointments']);
      List<dynamic> appointments = responseData['data']['appointments'];
      List<AppointmentModel> list =
          appointments.map((data) => AppointmentModel.fromJson(data)).toList();

      AppointmentModel ourApp =
          list.firstWhere((element) => element.id.toString() == lessonid);

      List<StudentModelSimple>? studentsattend = ourApp.students;
      _students_attend = studentsattend!;
      _loading = false;
      print(_students_attend);

      // add exception

    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  Future<void> add_appointment(String groupid, String time, String date) async {
    var url = Uri.https('development.mrsaidmostafa.com', '/api/appointments');
    try {
      var response = await http.post(url, headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $authToken'
      }, body: {
        'group_id': groupid,
        'time': time,
        'date': date
      });
      final responseData = json.decode(response.body);
      AppointmentModel appo = AppointmentModel.fromJson(responseData['data']);
      _currentApp = appo;
      // final responseData = json.decode(response.body);
      // print(responseData['data']['appointments']);
      // List<dynamic> appointments = responseData['data']['appointments'];
      // List<AppointmentModel> list =
      //     appointments.map((data) => AppointmentModel.fromJson(data)).toList();
      // _appointments = list;
      // _loading = false;
      print(response.body);

      // add exception

    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  Future<dynamic> attendlesson(String code, String lessonid) async {
    var url = Uri.https(
        'development.mrsaidmostafa.com', '/api/attend/appointments/$lessonid');
    // print(url);
    // print(code);
    // print(lessonid);
    // print(groupid);
    try {
      var response = await http.post(url, headers: {
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $authToken'
      }, body: {
        'code': code,
      });
      final responseData = json.decode(response.body);
      // print(code);
      // print(code);
      // print(code);
      print(code);
      print(lessonid);

      if (responseData['errors'] != null) {
        // print(responseData['errors']);
        List<String> errors = [];
        for (var value in responseData['errors'].values) errors.add(value[0]);
        throw HttpException(errors.join('  '));
      }
      return responseData;
      // return (responseData);

      // add exception

    } catch (error) {
      throw (error);
    }

    notifyListeners();
  }

  // Future<void> getMoreData() async {
  //   try {
  //     var url = Uri.https('development.mrsaidmostafa.com', '/api/stages',
  //         {"page": _pageNumber.toString()});
  //     var response = await http.get(
  //       url,
  //       headers: {
  //         'Accept': 'application/json',
  //         HttpHeaders.authorizationHeader: 'Bearer $authToken'
  //       },
  //     );

  //     final responseData = json.decode(response.body);

  //     List<dynamic> yearsList = responseData['data'];
  //     var fetchedStages =
  //         yearsList.map((data) => Stage.fromJson(data)).toList();
  //     _hasMore = fetchedStages.length == _defaultPerPageCount;
  //     _loading = false;
  //     _pageNumber = _pageNumber + 1;

  //     _stages.addAll(fetchedStages);
  //   } catch (e) {
  //     _loading = false;
  //     _error = true;
  //     notifyListeners();
  //   }

  //   notifyListeners();
  // }

  // void resetlist() {
  //   _stages = [];
  //   _loading = true;
  //   _pageNumber = 1;
  //   _error = false;
  //   _loading = true;
  //   notifyListeners();
  // }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void seterror(bool value) {
    _error = value;
    notifyListeners();
  }
}
