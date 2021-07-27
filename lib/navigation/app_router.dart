import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Auth_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/managers/cities_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';
import 'package:attendance/managers/year_manager.dart';
import 'package:attendance/models/student.dart';
import 'package:attendance/screens/Add_academic_year/Academic_year.dart';
import 'package:attendance/screens/Add_group/Add_group_Screen.dart';
import 'package:attendance/screens/Add_subject/Academic_subject.dart';
import 'package:attendance/screens/Add_teacher/Add_Teacher_Screen.dart';
import 'package:attendance/screens/Admin_Login/Admin_login_screen.dart';
import 'package:attendance/screens/Filter_screen.dart/Fliter_Screen_6.dart';
import 'package:attendance/screens/Home/Home_Screen.dart';
import 'package:attendance/screens/Single_Student.dart/Single_Student_Screen.dart';
import 'package:attendance/screens/Student_register/Student_register_screen.dart';
import 'package:attendance/screens/Students/Students_screen.dart';
import 'package:attendance/screens/modify_lessons/modify_lessons_screen.dart';
import 'package:attendance/screens/single_student_attendance/Single_Student_atten.dart';
import 'package:flutter/material.dart';
import 'screens.dart';

class AppRouter extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final AppStateManager appStateManager;
  final CitiesManager citiesManager;
  final SubjectManager subjectManager;
  final TeacherManager teachermanager;
  final YearManager yearManager;
  final GroupManager groupManager;
  final Auth_manager authmanager;
  final StudentManager studentManager;

  AppRouter({
    required this.studentManager,
    required this.citiesManager,
    required this.subjectManager,
    required this.teachermanager,
    required this.yearManager,
    required this.groupManager,
    required this.appStateManager,
    required this.authmanager,
  }) : navigatorKey = GlobalKey<NavigatorState>() {
    appStateManager.addListener(notifyListeners);
    authmanager.addListener(notifyListeners);
    // studentManager.addListener(notifyListeners);
  }

  @override
  void dispose() {
    appStateManager.removeListener(notifyListeners);
    authmanager.removeListener(notifyListeners);
    // studentManager.removeListener(notifyListeners);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _handlePopPage,
      pages: [
        if (!authmanager.isLoggedIn) Admin_logIn.page(),
        if (authmanager.isLoggedIn) Home_Screen.page(),
        if (authmanager.isLoggedIn && appStateManager.studentRegister)
          Student_Register_Screen.page(
              editStudent: StudentModel(), edit: false),
        if (authmanager.isLoggedIn && appStateManager.teacherRegister)
          Add_Teacher_Screeen.page(),
        if (authmanager.isLoggedIn && appStateManager.groupRegister)
          Add_group_screen.page(),
        if (authmanager.isLoggedIn && appStateManager.communicateStudents)
          Students_Screen.page(group_id: appStateManager.groupIdSelected),
        if (authmanager.isLoggedIn && appStateManager.dataStudents)
          Filter_Screen_6.page(),
        if (authmanager.isLoggedIn && appStateManager.lessonModify)
          Modify_Lessons_screen.page(),
        if (authmanager.isLoggedIn && appStateManager.subjectsModify)
          Add_academic_subject.page(),
        if (authmanager.isLoggedIn && appStateManager.yearsAdd)
          Add_academic_year.page(),
        if (authmanager.isLoggedIn &&
            appStateManager.communicateStudents &&
            appStateManager.singleStudent)
          Single_Student_Screen.page(
              studentid: appStateManager.studentIdSelected),
        if (authmanager.isLoggedIn &&
            // appStateManager.communicateStudents &&
            appStateManager.singleStudentFromHome)
          Single_Student_Screen.page(
              studentid: appStateManager.studentIdSelected),
        if (authmanager.isLoggedIn &&
            appStateManager.singleStudent &&
            appStateManager.singleStudentAttend)
          Single_Student_attend.page(),
        if (authmanager.isLoggedIn && appStateManager.geteditstudent)
          Student_Register_Screen.page(
              editStudent: appStateManager.getstudent, edit: true),
      ],
    );
  }

  bool _handlePopPage(Route<dynamic> route, result) {
    if (!route.didPop(result)) {
      return false;
    }

    // if (route.settings.name == Attendance_Screens.lesson_modify ||
    //     (route.settings.name == Attendance_Screens.single_student &&
    //         appStateManager.singleStudentFromHome == true)) {
    //   teachermanager.resetlist();

    //   // appStateManager.setHomeOptions(false);
    //   yearManager.getMoreData();
    //   appStateManager.go_to_Home();
    // }

    if (route.settings.name == Attendance_Screens.student_registerpath &&
        appStateManager.geteditstudent == true &&
        appStateManager.communicateStudents == true) {
      appStateManager.studentTapped('', false);
      // appStateManager.goToSingleStudent(false, StudentModel(), '');
    }
    if (route.settings.name == Attendance_Screens.student_registerpath &&
        appStateManager.geteditstudent == true) {
      appStateManager.studentTapped('', false);
    }
    if (route.settings.name == Attendance_Screens.single_student) {
      appStateManager.goToSingleStudentfromHome(false, '');
    }
    if (route.settings.name == Attendance_Screens.data_students) {
      appStateManager.studentsCommunicate(false);
    }
    if (route.settings.name == Attendance_Screens.data_students) {
      appStateManager.studentsData(false);
    }
    if (route.settings.name == Attendance_Screens.years_add) {
      appStateManager.addYears(false);
    }
    if (route.settings.name == Attendance_Screens.subjects_add) {
      yearManager.resetlist();
      appStateManager.modifySubjects(false);
    }
    if (route.settings.name == Attendance_Screens.group_registerpath) {
      yearManager.resetlist();
      subjectManager.resetlist();
      teachermanager.resetlist();
      appStateManager.registerGroup(false);
    }
    if (route.settings.name == Attendance_Screens.teacher_registerpath) {
      subjectManager.resetlist();
      yearManager.resetlist();
      yearManager.getMoreData();
      appStateManager.registerTeacher(false);
    }
    if (route.settings.name == Attendance_Screens.student_registerpath) {
      groupManager.resetlist();
      appStateManager.registerStudent(false);
    }
    if (route.settings.name == Attendance_Screens.single_student &&
        appStateManager.singleStudentFromHome == false) {
      appStateManager.goToSingleStudent(false, StudentModel(), '');
    }
    if (route.settings.name == Attendance_Screens.single_student_attend) {
      appStateManager.goToSingleStudentAttend(false);
    }

    return true;
  }

  @override
  Future<void> setNewRoutePath(configuration) async => null;
}
