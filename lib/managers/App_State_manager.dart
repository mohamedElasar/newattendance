import 'dart:async';
import 'package:attendance/models/group.dart';
import 'package:attendance/models/student.dart';
import 'package:flutter/material.dart';

class AppStateManager extends ChangeNotifier {
  // home screen state.. start
  bool _home_options = false;
  bool _student_register = false;
  bool _teacher_register = false;
  bool _group_register = false;
  bool _communicate_students = false;
  bool _data_students = false;
  bool _lesson_modify = false;
  bool _subjects_modify = false;
  bool _years_add = false;

  bool _singleStudentfromHome = false;
  // home screen state.. end

  // students page .. start
  bool _single_student = false;
  // students page .. end

  // students page .. start
  bool _single_student_attend = false;
  // students page .. end

  // home screen state.. start
  bool get homeOptions => _home_options;
  bool get studentRegister => _student_register;
  bool get teacherRegister => _teacher_register;
  bool get groupRegister => _group_register;
  bool get communicateStudents => _communicate_students;
  bool get dataStudents => _data_students;
  bool get lessonModify => _lesson_modify;
  bool get subjectsModify => _subjects_modify;
  bool get yearsAdd => _years_add;
  bool get singleStudentFromHome => _singleStudentfromHome;
  // home screen end

  // students page .. start
  bool get singleStudent => _single_student;
  // students page .. end

  // students page .. start
  bool get singleStudentAttend => _single_student_attend;
  // students page .. end

  String _group_id_selected = '';
  GroupModel _groupselected = GroupModel();
  String get groupIdSelected => _group_id_selected;
  GroupModel get getGroupSelected => _groupselected;
  String _student_id_selected = '';
  String get studentIdSelected => _student_id_selected;

  String _editStudentid = '';
  String get geteditStudentID => _editStudentid;
  bool _editStudent = false;
  bool get geteditstudent => _editStudent;
  StudentModel _student = StudentModel();
  StudentModel get getstudent => _student;

  void setstudent(StudentModel st) {
    _student = st;
  }

  void setgroupID(String value, GroupModel group) {
    _group_id_selected = value;
    _groupselected = group;
    notifyListeners();
  }

  void setStudentID(String value) {
    _student_id_selected = value;
    notifyListeners();
  }

  void setHomeOptions(bool value) {
    _home_options = value;
    notifyListeners();
  }

  void registerStudent(bool value) {
    _student_register = value;
    notifyListeners();
  }

  void registerTeacher(bool value) {
    _teacher_register = value;
    notifyListeners();
  }

  void registerGroup(bool value) {
    _group_register = value;
    notifyListeners();
  }

  void studentsCommunicate(bool value) {
    _communicate_students = value;
    notifyListeners();
  }

  void studentsData(bool value) {
    _data_students = value;
    notifyListeners();
  }

  void modifyLesson() {
    _lesson_modify = true;
    notifyListeners();
  }

  void modifySubjects(bool value) {
    _subjects_modify = value;
    notifyListeners();
  }

  void addYears(bool value) {
    _years_add = value;
    notifyListeners();
  }

  void goToSingleStudent(bool value, StudentModel st, String id) {
    _single_student = value;
    _student = st;
    _student_id_selected = id;
    notifyListeners();
  }

  void goToSingleStudentAttend(bool value) {
    _single_student_attend = value;
    notifyListeners();
  }

  void goToSingleStudentfromHome(bool value, String id) {
    _singleStudentfromHome = value;
    _student_id_selected = id;
    print(id);

    notifyListeners();
  }

  // void go_to_Home() {
  //   _student_register = false;
  //   _teacher_register = false;
  //   _group_register = false;
  //   _communicate_students = false;
  //   _data_students = false;
  //   _lesson_modify = false;
  //   _subjects_modify = false;
  //   _years_add = false;
  //   _singleStudentfromHome = false;
  //   /////////////////////////
  //   _editStudent = false;
  //   notifyListeners();
  // }

  void studentTapped(String id, bool value, StudentModel stu) {
    _editStudentid = id;
    _editStudent = value;
    _student = stu;
    notifyListeners();
  }
}
