import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Student_manager.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/Admin_Login/components/Login_Form.dart';
import 'package:attendance/screens/Admin_Login/components/Page_Title.dart';
import 'package:attendance/screens/Students/components/Students_Top_Page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';

import 'components/student_details.dart';
import 'components/student_pic_name.dart';

class Single_Student_Screen extends StatefulWidget {
  final String? student_id;
  static MaterialPage page({required String studentid}) {
    return MaterialPage(
      name: Attendance_Screens.single_student,
      key: ValueKey(Attendance_Screens.single_student),
      child: Single_Student_Screen(student_id: studentid),
    );
  }

  const Single_Student_Screen({Key? key, this.student_id}) : super(key: key);

  @override
  _Single_Student_ScreenState createState() => _Single_Student_ScreenState();
}

class _Single_Student_ScreenState extends State<Single_Student_Screen> {
  bool _isLoading = true;

  @override
  void initState() {
    // print('asdasdasd');
    super.initState();
    Future.delayed(Duration.zero, () async {
      await Provider.of<StudentManager>(context, listen: false)
          .getMoreDatafilteredId(widget.student_id.toString())
          // .then((value) => Provider.of<AppStateManager>(context, listen: false)
          //     .goToSingleStudent(
          //         false,
          //         Provider.of<StudentManager>(context, listen: false)
          //             .singleStudent!,
          //         widget.student_id!))
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(
    // Provider.of<StudentManager>(context, listen: true).singleStudent[0].id);
    // print(widget.student_id);
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kbackgroundColor2,
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // InkWell(
                        //   onTap: () {
                        //     // Provider.of<Auth_manager>(context, listen: false).logout();
                        //     // _scaffoldKey.currentState!.openDrawer();
                        //   },
                        //   child: Icon(
                        //     Icons.menu,
                        //     size: 30,
                        //   ),
                        // ),
                        // Spacer(),
                        Container(),
                        // InkWell(
                        //   onTap: () async {
                        //     // showSearch(context: context, delegate: StudentSearch());
                        //   },
                        //   child: Container(
                        //     padding: EdgeInsets.all(8),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           'بحث',
                        //           style: TextStyle(
                        //               fontFamily: 'GE-medium',
                        //               color: Colors.black87),
                        //         ),
                        //         Icon(
                        //           Icons.search,
                        //           size: 30,
                        //           color: Colors.black87,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Text(
                          'صفحه طالب ',
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'AraHamah1964B-Bold'),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Student_pic_name(stu_id: widget.student_id),
                  SizedBox(height: 5),
                  Student_details(stu_id: widget.student_id, size: size)
                ],
              ),
      ),
    );
  }
}
