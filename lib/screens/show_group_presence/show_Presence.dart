import 'dart:ui';

import 'package:attendance/constants.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/models/appointment.dart';
import 'package:attendance/models/group.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/show_group_presence/components/Presence_top_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Show_Group_Presence extends StatefulWidget {
  final String? group_id;
  final GroupModelSimple? mygroup;
  final String? mylessonid;
  final AppointmentModel? mylesson;
  // final String? lessonid;
  static MaterialPage page(
      {required String groupid,
      required GroupModelSimple group,
      required String lessonid,
      required AppointmentModel lesson}) {
    return MaterialPage(
      name: Attendance_Screens.classattend,
      key: ValueKey(Attendance_Screens.classattend),
      child: Show_Group_Presence(
        group_id: groupid,
        mygroup: group,
        mylessonid: lessonid,
        mylesson: lesson,
      ),
    );
  }

  Show_Group_Presence({
    Key? key,
    this.group_id,
    this.mygroup,
    this.mylessonid,
    this.mylesson,
  }) : super(key: key);

  @override
  _Show_Group_PresenceState createState() => _Show_Group_PresenceState();
}

class _Show_Group_PresenceState extends State<Show_Group_Presence> {
  List<String> items = [
    'محمد أحمد',
    'أحمد الكاشف',
    'ايه محمد',
    'عمرو الشرقاوي',
    'محمد أحمد',
    'أحمد الكاشف',
    'ايه محمد',
    'عمرو الشرقاوي'
  ];
  var colors = [
    kbuttonColor3.withOpacity(.8),
    kbuttonColor3.withOpacity(.6),
  ];
  var text_colors = [Colors.black, Colors.black];
  String text = '';

  Map<String, dynamic> _add_data = {
    'year': null,
  };

  var yearController = TextEditingController();

  String text_value = '';

  bool _isloading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      // Provider.of<AppointmentManager>(context, listen: false).resetlist();
      try {
        await Provider.of<AppointmentManager>(context, listen: false)
            .get_students_attending_lesson(widget.group_id!, widget.mylessonid!)
            .then((_) {
          setState(() {
            _isloading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;

      // _sc.addListener(() {
      //   if (_sc.position.pixels == _sc.position.maxScrollExtent) {
      //     Provider.of<AppointmentManager>(context, listen: false).getMoreData();
      //   }
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Show_Presence_Top_Page(
                  size: size,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 20,
                      end: 20,
                      top: 20,
                    ),
                    child: Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        children: <Widget>[
                          buildChip(widget.mygroup!.name!),
                          buildChip(widget.mygroup!.subject!.name!),
                          // buildChip('مجموعة الياسمين 2'),
                          buildChip(widget.mygroup!.teacher!.name!),
                          buildChip('معاد الحصه :  ${widget.mylesson!.time}'),
                          buildChip('تاريخ الحصه :  ${widget.mylesson!.date}'),
                        ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 20,
                        end: 20,
                        top: 10,
                      ),
                      child: Container(
                        // color: kbackgroundColor2,
                        child: Consumer<AppointmentManager>(
                          builder: (builder, appmgr, child) => appmgr
                                  .student_attend.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'لا يوجد طلاب حضرو الحصه',
                                    style: TextStyle(fontFamily: 'GE-Bold'),
                                  ),
                                )
                              : ListView.builder(
                                  // controller: _sc,
                                  itemCount: appmgr.student_attend.length,
                                  itemBuilder: (BuildContext ctxt, int Index) =>
                                      Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    color: colors[Index % colors.length],
                                    child: ListTile(
                                      trailing: Text(
                                        // 'شسيشسي',
                                        appmgr.student_attend[Index].phone ??
                                            '',
                                        style: TextStyle(
                                            color: text_colors[
                                                Index % colors.length],
                                            fontFamily: 'GE-light'),
                                      ),
                                      // subtitle: Text(
                                      //   // 'شسيشسي',
                                      //   appmgr.student_attend[Index].code!.name ?? '',
                                      //   style: TextStyle(
                                      //       color: text_colors[Index % colors.length],
                                      //       fontFamily: 'GE-light'),
                                      // ),
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => Show_Group_Class()));
                                        // Provider.of<AppStateManager>(context,
                                        //         listen: false)
                                        //     .goToSinglegroup(
                                        //         true,
                                        //         appmgr.groups[Index].id
                                        //             .toString(),
                                        //         appmgr.groups[Index]);
                                      },
                                      title: Text(
                                        // 'شسيشسي',

                                        appmgr.student_attend[Index].name!,
                                        style: TextStyle(
                                            color: text_colors[
                                                Index % colors.length],
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'GE-medium'),
                                      ),

                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Container(
                                      //     decoration: BoxDecoration(
                                      //       borderRadius:
                                      //           BorderRadius.all(Radius.circular(5)),
                                      //       border: Border.all(
                                      //         color: Colors.grey,
                                      //         width: 0.7,
                                      //       ),
                                      //     ),
                                      //     height: 50,
                                      //     child: Material(
                                      //       elevation: 5.0,
                                      //       borderRadius: BorderRadius.circular(5.0),
                                      //       color: colors[Index % colors.length],
                                      //       child: Center(
                                      //         child: Text(
                                      //           groupManager.groups[Index].name!,
                                      //           style: TextStyle(
                                      //               color: text_colors[
                                      //                   Index % colors.length],
                                      //               fontWeight: FontWeight.bold),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    ));
  }

  Widget buildChip(text) => Chip(
        labelPadding: EdgeInsets.all(2.0),
        label: Text(
          text,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'GE-medium'),
        ),
        backgroundColor: kbuttonColor3,
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: EdgeInsets.all(8.0),
      );
}
