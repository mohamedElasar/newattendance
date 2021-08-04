import 'dart:convert';
import 'dart:io';
import 'package:attendance/helper/httpexception.dart';
import 'package:attendance/models/degreemodelsimple.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:dio/dio.dart';

import 'package:attendance/managers/Auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DegreeManager extends ChangeNotifier {
  void receiveToken(Auth_manager auth
       , List<DegreeSimpleModel> groups
      ) {
    _authToken = auth.token;
    // _groups = groups;
  }

  String? _authToken;
  List<DegreeSimpleModel> _groups = [];
  List<DegreeSimpleModel> get groups => _groups;
  get hasmore => _hasMore;
  get pageNumber => _pageNumber;
  get error => _error;
  get loading => _loading;

  bool _hasMore = false;
  int _pageNumber = 1;
  bool _error = false;
  bool _loading = true;
  final int _defaultGroupsPerPageCount = 15;

  Future<void> addgroup(
    String? degree,
    String? student_id,
  ) async {
    try {
      Dio dio = Dio();
      String urld =
          'https://development.mrsaidmostafa.com/api/degree/appointments/36';
      print(urld);
      var params = {
        'degree': degree,
        'student_id': student_id,
      };

      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';

      var response = await dio.post(urld, data: jsonEncode(params));
      print("responnnnse");
      print(response);

      final responseData = response.data;
      print("responnnnse");
      
      print(responseData);

      //   if (responseData['errors'] != null) {
      //     print(responseData['errors']);
      //     List<String> errors = [];
      //     for (var value in responseData['errors'].values) errors.add(value[0]);
      //     throw HttpException(errors.join('  '));
      //   }
    } catch (error) {
      print(error);
      throw (error);
    }

    notifyListeners();
  }

//   Future<void> get_groups() async {
//     var url = Uri.https('development.mrsaidmostafa.com', '/api/groups');
//     try {
//       var response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           HttpHeaders.authorizationHeader: 'Bearer $_authToken'
//         },
//       );
//       final responseData = json.decode(response.body);

//       List<dynamic> stagesList = responseData['data'];
//       var list =
//           stagesList.map((data) => GroupModelSimple.fromJson(data)).toList();
//       _groups = list;
//       // _loading = false;
//       // add exception

//     } catch (error) {
//       print(error);
//     }

//     notifyListeners();
//   }

//   Future<void> getMoreData() async {
//     try {
//       var url = Uri.https('development.mrsaidmostafa.com', '/api/groups',
//           {"page": _pageNumber.toString()});
//       var response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           HttpHeaders.authorizationHeader: 'Bearer $_authToken'
//         },
//       );

//       final responseData = json.decode(response.body);

//       List<dynamic> yearsList = responseData['data'];
//       var fetchedGroups =
//           yearsList.map((data) => GroupModelSimple.fromJson(data)).toList();
//       _hasMore = fetchedGroups.length == _defaultGroupsPerPageCount;
//       _loading = false;
//       _pageNumber = _pageNumber + 1;

//       _groups.addAll(fetchedGroups);
//     } catch (e) {
//       _loading = false;
//       _error = true;
//       notifyListeners();
//     }

//     notifyListeners();
//   }

//   Future<void> getMoreDatafiltered(
//       String filter1, String filter2, String filter3) async {
//     // print(_pageNumber);
//     try {
//       var url = Uri.https('development.mrsaidmostafa.com', '/api/groups', {
//         "year_id": filter1,
//         "subject_id": filter2,
//         "teacher_id": filter3,
//         "page": _pageNumber.toString(),
//       });
//       print(url);
//       print(_pageNumber);
//       //
//       print(url);
//       var response = await http.get(
//         url,
//         headers: {
//           'Accept': 'application/json',
//           HttpHeaders.authorizationHeader: 'Bearer $_authToken'
//         },
//       );

//       final responseData = json.decode(response.body);

//       List<dynamic> groupsList = responseData['data'];
//       var fetchedgroups =
//           groupsList.map((data) => GroupModelSimple.fromJson(data)).toList();
//       _hasMore = fetchedgroups.length == _defaultGroupsPerPageCount;
//       _loading = false;
//       _pageNumber = _pageNumber + 1;

//       _groups.addAll(fetchedgroups);
//     } catch (e) {
//       _loading = false;
//       _error = true;
//       notifyListeners();
//     }

//     notifyListeners();
//   }

//   void resetlist() {
//     _groups = [];
//     _loading = true;
//     _pageNumber = 1;
//     _error = false;
//     _loading = true;
//     notifyListeners();
//   }

//   void setloading(bool value) {
//     _loading = value;
//     notifyListeners();
//   }

//   void seterror(bool value) {
//     _error = value;
//     notifyListeners();
//   }
}
