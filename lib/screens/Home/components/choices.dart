import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';
import 'package:attendance/managers/year_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../Home_Screen.dart';

class Choices extends StatefulWidget {
  const Choices({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _ChoicesState createState() => _ChoicesState();
}

late String year_id_selected;
String yearname = 'السنه الدراسيه';
late String subjectId_selected;
String subjectname = 'الماده الدراسيه';
late String teacher_id_selected;
String teachername = 'المدرس';
late String group_id_selected;
String group_name = 'المجموعه';
late String app_id_selected;
String app_name = 'اختر حصه';

late String scanResult_code;

class _ChoicesState extends State<Choices> {
  ScrollController _sc1 = new ScrollController();
  ScrollController _sc2 = new ScrollController();
  ScrollController _sc3 = new ScrollController();
  ScrollController _sc4 = new ScrollController();
  void dispose() {
    _sc1.dispose();
    _sc2.dispose();
    _sc3.dispose();

    super.dispose();
  }

  bool _isloadingyears = true;
  bool _isloadingsubjects = false;
  bool _isloadingteachers = false;
  bool _isloadinggroups = false;
  bool _isloadingappointment = false;
  bool _scanloading = false;
  bool _isinit = true;

  // @override
  // void didChangeDependencies() async {
  //   if (_isinit == true) {
  //     // Provider.of<GroupManager>(context, listen: false).resetlist();
  //     // Provider.of<TeacherManager>(context, listen: false).resetlist();
  //     // // Provider.of<YearManager>(context, listen: false).resetlist();
  //     // Provider.of<SubjectManager>(context, listen: false).resetlist();
  //     // Provider.of<YearManager>(context, listen: false).resetlist();

  //   }
  //   _isinit = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      yearname = 'السنه الدراسيه';
      subjectname = 'الماده الدراسيه';
      teachername = 'المدرس';
      group_name = 'المجموعه';
      app_name = 'الحصه';
      Provider.of<GroupManager>(context, listen: false).resetlist();
      Provider.of<TeacherManager>(context, listen: false).resetlist();
      // Provider.of<YearManager>(context, listen: false).resetlist();
      Provider.of<SubjectManager>(context, listen: false).resetlist();
      Provider.of<YearManager>(context, listen: false).resetlist();
      try {
        await Provider.of<YearManager>(context, listen: false)
            .getMoreData()
            .then((value) {
          setState(() {
            _isloadingyears = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;
    });

    _sc1.addListener(
      () {
        if (_sc1.position.pixels == _sc1.position.maxScrollExtent) {
          Provider.of<YearManager>(context, listen: false).getMoreData();
        }
      },
    );
    _sc2.addListener(
      () {
        if (_sc2.position.pixels == _sc2.position.maxScrollExtent) {
          Provider.of<SubjectManager>(context, listen: false)
              .getMoreDatafiltered(year_id_selected.toString());
        }
      },
    );
    _sc3.addListener(
      () {
        if (_sc3.position.pixels == _sc3.position.maxScrollExtent) {
          Provider.of<TeacherManager>(context, listen: false)
              .getMoreDatafiltered(year_id_selected, subjectId_selected);
        }
      },
    );
    _sc4.addListener(
      () {
        if (_sc4.position.pixels == _sc4.position.maxScrollExtent) {
          Provider.of<GroupManager>(context, listen: false).getMoreDatafiltered(
              year_id_selected, subjectId_selected, teacher_id_selected);
        }
      },
    );
    super.initState();
  }

  bool _loadingscann = false;
  List<String> formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('hh:mm'); //"6:00 AM"
    final dateformate = DateFormat('y-M-d');
    return [format.format(dt), dateformate.format(dt)];
  }

  void _modalBottomSheetMenusubject(BuildContext context) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'الماده الدراسيه',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<SubjectManager>(
                      builder: (_, subjectmanager, child) {
                        if (subjectmanager.subjects!.isEmpty) {
                          if (subjectmanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (subjectmanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                subjectmanager.setloading(true);
                                subjectmanager.seterror(false);
                                Provider.of<SubjectManager>(context,
                                        listen: false)
                                    .getMoreDatafiltered(
                                        year_id_selected.toString());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc2,
                            itemCount: subjectmanager.subjects!.length +
                                (subjectmanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == subjectmanager.subjects!.length) {
                                if (subjectmanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      subjectmanager.setloading(true);
                                      subjectmanager.seterror(false);
                                      Provider.of<SubjectManager>(context,
                                              listen: false)
                                          .getMoreDatafiltered(
                                              year_id_selected.toString());
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<TeacherManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    subjectId_selected = subjectmanager
                                        .subjects![index].id
                                        .toString();
                                    subjectname =
                                        subjectmanager.subjects![index].name!;
                                    subject_level = true;
                                    teacher_level = false;
                                    group_level = false;
                                    _isloadingteachers = true;
                                    teachername = 'المدرس';
                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                  });
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);
                                  Navigator.pop(context);

                                  await Provider.of<TeacherManager>(context,
                                          listen: false)
                                      .getMoreDatafiltered(
                                          year_id_selected, subjectId_selected)
                                      .then((value) {
                                    setState(() {
                                      _isloadingteachers = false;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                      subjectmanager.subjects![index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenuyear(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbuttonColor3,
                  ),
                  child: Center(
                    child: Text(
                      'السنه الدراسيه',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<YearManager>(
                      builder: (_, yearmanager, child) {
                        if (yearmanager.years.isEmpty) {
                          if (yearmanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (yearmanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                yearmanager.setloading(true);
                                yearmanager.seterror(false);
                                Provider.of<YearManager>(context, listen: false)
                                    .getMoreData();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc1,
                            itemCount: yearmanager.years.length +
                                (yearmanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == yearmanager.years.length) {
                                if (yearmanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      yearmanager.setloading(true);
                                      yearmanager.seterror(false);
                                      Provider.of<YearManager>(context,
                                              listen: false)
                                          .getMoreData();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<SubjectManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    year_id_selected =
                                        yearmanager.years[index].id.toString();
                                    yearname = yearmanager.years[index].name!;
                                    year_level = true;
                                    subject_level = false;
                                    teacher_level = false;
                                    group_level = false;
                                    _isloadingsubjects = true;
                                    subjectname = 'الماده الدراسيه';
                                    teachername = 'المدرس';
                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                  });
                                  Navigator.pop(context);
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);

                                  await Provider.of<SubjectManager>(context,
                                          listen: false)
                                      .getMoreDatafiltered(
                                          year_id_selected.toString())
                                      .then((value) {
                                    setState(() {
                                      _isloadingsubjects = false;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(yearmanager.years[index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenuteacher(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbackgroundColor1,
                  ),
                  child: Center(
                    child: Text(
                      'المدرس',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'GE-bold',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0))),
                    child: Consumer<TeacherManager>(
                      builder: (_, teachermanager, child) {
                        if (teachermanager.teachers.isEmpty) {
                          if (teachermanager.loading) {
                            return Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ));
                          } else if (teachermanager.error) {
                            return Center(
                                child: InkWell(
                              onTap: () {
                                teachermanager.setloading(true);
                                teachermanager.seterror(false);
                                Provider.of<TeacherManager>(context,
                                        listen: false)
                                    .getMoreDatafiltered(
                                        year_id_selected, subjectId_selected);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text("error please tap to try again"),
                              ),
                            ));
                          }
                        } else {
                          return ListView.builder(
                            controller: _sc3,
                            itemCount: teachermanager.teachers.length +
                                (teachermanager.hasmore ? 1 : 0),
                            itemBuilder: (BuildContext ctxt, int index) {
                              if (index == teachermanager.teachers.length) {
                                if (teachermanager.error) {
                                  return Center(
                                      child: InkWell(
                                    onTap: () {
                                      teachermanager.setloading(true);
                                      teachermanager.seterror(false);
                                      Provider.of<TeacherManager>(context,
                                              listen: false)
                                          .getMoreDatafiltered(year_id_selected,
                                              subjectId_selected);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child:
                                          Text("error please tap to try again"),
                                    ),
                                  ));
                                } else {
                                  return Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: CircularProgressIndicator(),
                                  ));
                                }
                              }

                              return GestureDetector(
                                onTap: () async {
                                  Provider.of<GroupManager>(context,
                                          listen: false)
                                      .resetlist();
                                  setState(() {
                                    teacher_id_selected = teachermanager
                                        .teachers[index].id
                                        .toString();
                                    teachername =
                                        teachermanager.teachers[index].name!;
                                    teacher_level = true;
                                    group_level = false;
                                    _isloadinggroups = true;

                                    group_name = 'المجموعه';
                                    app_name = 'الحصه';
                                  });
                                  Navigator.pop(context);
                                  Provider.of<AppStateManager>(context,
                                          listen: false)
                                      .setHomeOptions(false);
                                  await Provider.of<GroupManager>(context,
                                          listen: false)
                                      .getMoreDatafiltered(
                                          year_id_selected,
                                          subjectId_selected,
                                          teacher_id_selected)
                                      .then((value) {
                                    setState(() {
                                      _isloadinggroups = false;
                                    });
                                  });
                                },
                                child: ListTile(
                                  title: Text(
                                      teachermanager.teachers[index].name!),
                                ),
                              );
                            },
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheetMenugroup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kbackgroundColor3,
                ),
                child: Center(
                  child: Text(
                    'المجموعات',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GE-bold',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: Consumer<GroupManager>(
                    builder: (_, groupmanager, child) {
                      if (groupmanager.groups.isEmpty) {
                        if (groupmanager.loading) {
                          print(groupmanager.loading);
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          ));
                        } else if (groupmanager.error) {
                          return Center(
                              child: InkWell(
                            onTap: () {
                              groupmanager.setloading(true);
                              groupmanager.seterror(false);
                              Provider.of<GroupManager>(context, listen: false)
                                  .getMoreDatafiltered(year_id_selected,
                                      subjectId_selected, teacher_id_selected);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("error please tap to try again"),
                            ),
                          ));
                        }
                      } else {
                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: _sc4,
                                itemCount: groupmanager.groups.length +
                                    (groupmanager.hasmore ? 1 : 0),
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if (index == groupmanager.groups.length) {
                                    if (groupmanager.error) {
                                      print('2');

                                      return Center(
                                          child: InkWell(
                                        onTap: () {
                                          groupmanager.setloading(true);
                                          groupmanager.seterror(false);
                                          Provider.of<GroupManager>(context,
                                                  listen: false)
                                              .getMoreDatafiltered(
                                                  year_id_selected,
                                                  subjectId_selected,
                                                  teacher_id_selected);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                              "error please tap to try again"),
                                        ),
                                      ));
                                    } else {
                                      print('1');
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () async {
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .setgroupID(
                                              groupmanager.groups[index].id
                                                  .toString(),
                                              groupmanager.groups[index]);
                                      setState(() {
                                        group_id_selected = groupmanager
                                            .groups[index].id
                                            .toString();
                                        group_name =
                                            groupmanager.groups[index].name!;
                                        group_level = true;
                                        _isloadingappointment = true;
                                        app_name = 'الحصه';
                                      });
                                      Provider.of<AppStateManager>(context,
                                              listen: false)
                                          .setHomeOptions(true);
                                      Navigator.pop(context);
                                      await Provider.of<AppointmentManager>(
                                              context,
                                              listen: false)
                                          .get_appointments(group_id_selected)
                                          .then((value) => setState(() {
                                                _isloadingappointment = false;
                                              }));
                                    },
                                    child: ListTile(
                                      title: Text(
                                          groupmanager.groups[index].name!),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _modalBottomSheetMenuappoint(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 300.0,
          color: Colors.transparent,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kbackgroundColor1,
                ),
                child: Center(
                  child: Text(
                    'اختار حصه',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GE-bold',
                    ),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: double.infinity,
                color: Colors.white,
                // decoration: BoxDecoration(
                //   color: kbackgroundColor2,
                // ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: kbuttonColor3),
                      onPressed: () async {
                        Navigator.pop(context);

                        setState(() {
                          _isloadingappointment = true;
                          group_level = false;
                        });
                        try {
                          await Provider.of<AppointmentManager>(context,
                                  listen: false)
                              .add_appointment(
                                group_id_selected,
                                formatTimeOfDay(TimeOfDay.now())[0],
                                formatTimeOfDay(TimeOfDay.now())[1],
                              )
                              .then((value) => Provider.of<AppointmentManager>(
                                      context,
                                      listen: false)
                                  .get_appointments(group_id_selected))
                              .then((value) => setState(() {
                                    _isloadingappointment = false;
                                    group_level = true;
                                  }))
                              .then((value) => setState(() {
                                    app_name = [
                                      Provider.of<AppointmentManager>(context,
                                              listen: false)
                                          .currentapp!
                                          .date,
                                      Provider.of<AppointmentManager>(context,
                                              listen: false)
                                          .currentapp!
                                          .time
                                    ].join(',');
                                  }))
                              .then(
                                (_) =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.black38,
                                    content: Text(
                                      'تم اضافه الحصه بنجاح',
                                      style: TextStyle(fontFamily: 'GE-medium'),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ),
                                ),
                              );
                        } catch (e) {
                          _showErrorDialog('حاول مره اخري ', 'حدث خطأ');
                        }
                      },
                      icon: Icon(Icons.add),
                      label: Text(
                        'أضف حصه جديده',
                        style: TextStyle(
                            fontFamily: 'GE-medium', color: Colors.black),
                      )),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(20.0),
                    //     topRight: Radius.circular(20.0))
                  ),
                  child: Consumer<AppointmentManager>(
                    builder: (_, appointmentmanager, child) {
                      if (appointmentmanager.appointments!.isEmpty) {
                        if (!appointmentmanager.loading) {
                          // print('1');
                          return Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                'لا توجد حصص',
                                style: TextStyle(
                                    fontFamily: 'GE-medium',
                                    color: Colors.black),
                              ),
                            ),
                          );
                        } else if (appointmentmanager.error) {
                          // print('2');

                          return Center(
                              child: InkWell(
                            onTap: () {
                              appointmentmanager.setloading(true);
                              appointmentmanager.seterror(false);
                              Provider.of<AppointmentManager>(context,
                                      listen: false)
                                  .get_appointments(group_id_selected);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text("error please tap to try again"),
                            ),
                          ));
                        }
                      } else {
                        // print('3');

                        return Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount:
                                    appointmentmanager.appointments!.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  if (index ==
                                      appointmentmanager.appointments!.length) {
                                    if (appointmentmanager.error) {
                                      return Center(
                                          child: InkWell(
                                        onTap: () {
                                          appointmentmanager.setloading(true);
                                          appointmentmanager.seterror(false);
                                          Provider.of<AppointmentManager>(
                                                  context,
                                                  listen: false)
                                              .get_appointments(
                                                  group_id_selected);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                              "error please tap to try again"),
                                        ),
                                      ));
                                    } else {
                                      return Center(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: CircularProgressIndicator(),
                                      ));
                                    }
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        app_id_selected = appointmentmanager
                                            .appointments![index].id
                                            .toString();
                                        app_name = appointmentmanager
                                            .appointments![index].time
                                            .toString();
                                      });
                                      Navigator.pop(context);
                                      // Provider.of<AppStateManager>(context,
                                      //         listen: false)
                                      //     .setgroupID(
                                      //         appointmentmanager
                                      //             .groups[index].id
                                      //             .toString(),
                                      //         appointmentmanager.groups[index]);
                                      // setState(() {
                                      //   group_id_selected = appointmentmanager
                                      //       .groups[index].id
                                      //       .toString();
                                      //   group_name = appointmentmanager
                                      //       .groups[index].name!;
                                      //   group_level = true;
                                      // });
                                      // Provider.of<AppStateManager>(context,
                                      //         listen: false)
                                      //     .setHomeOptions(true);
                                      // Navigator.pop(context);
                                    },
                                    //  ' الساعه :   ${appointmentmanager.appointments![index].time!
                                    // .toString()}'
                                    child: ListTile(
                                      title: Text(
                                        ' الساعه :   ${appointmentmanager.appointments![index].time!.toString()}',
                                        style:
                                            TextStyle(fontFamily: 'GE-light'),
                                      ),
                                      trailing: Text(
                                        ' التاريخ :   ${appointmentmanager.appointments![index].date!.toString()}',
                                        style:
                                            TextStyle(fontFamily: 'GE-light'),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(kbuttonColor2)),
              // color: kbackgroundColor1,
              child: Text(
                'حسنا',
                style: TextStyle(fontFamily: 'GE-medium', color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  List<String> years_levels = [];
  List<String> subjects = [];
  List<String> teachers = [];
  List<String> groups = [];
  var year_level = false;
  var subject_level = false;
  var teacher_level = false;
  var group_level = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * .7,
      child: Column(
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Choice_container(
                  hinttext: yearname,
                  color: kbuttonColor3,
                  items: years_levels,
                  size: widget.size,
                  fnc: () => _modalBottomSheetMenuyear(context),
                  loading: _isloadingyears,
                  active: true,
                ),
                Choice_container(
                  hinttext: subjectname,
                  color: kbackgroundColor1,
                  items: subjects,
                  size: widget.size,
                  fnc: () => _modalBottomSheetMenusubject(context),
                  active: year_level == true,
                  loading: _isloadingsubjects,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Choice_container(
                  hinttext: teachername,
                  color: kbackgroundColor1,
                  items: teachers,
                  size: widget.size,
                  fnc: () => _modalBottomSheetMenuteacher(context),
                  active: subject_level == true,
                  loading: _isloadingteachers,
                ),
                Choice_container(
                  hinttext: group_name,
                  color: kbackgroundColor3,
                  items: groups,
                  size: widget.size,
                  fnc: () => _modalBottomSheetMenugroup(context),
                  active: teacher_level == true,
                  loading: _isloadinggroups,
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button_Container(
                  color: kbuttonColor2,
                  size: widget.size,
                  text: 'ادخال طالب',
                  fnc: () async {
                    Provider.of<AppStateManager>(context, listen: false)
                        .registerStudent(true);
                  },
                ),
                Button_Container(
                  color: kbuttonColor3,
                  size: widget.size,
                  text: 'ادخال معلم',
                  fnc: () async {
                    Provider.of<AppStateManager>(context, listen: false)
                        .registerTeacher(true);
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button_Container(
                  color: kbackgroundColor3,
                  size: widget.size,
                  text: 'الدرجات ',
                  fnc: () {},
                ),
                Button_Container(
                  color: kbuttonColor2,
                  size: widget.size,
                  text: 'ادخال مجموعه',
                  fnc: () async {
                    Provider.of<AppStateManager>(context, listen: false)
                        .registerGroup(true);
                  },
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button_Container(
                  color: kbuttonColor2,
                  size: widget.size,
                  text: 'المواد الدراسيه',
                  fnc: () async {
                    Provider.of<AppStateManager>(context, listen: false)
                        .modifySubjects(true);
                  },
                ),
                Button_Container(
                  color: kbackgroundColor1,
                  size: widget.size,
                  text: 'السنوات الدراسيه',
                  fnc: () async {
                    Provider.of<AppStateManager>(context, listen: false)
                        .addYears(true);
                  },
                ),
              ],
            ),
          ),
          Container(
            // padding: EdgeInsets.only(right: 6),
            margin: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 30,
            width: widget.size.width * .5,
            decoration: BoxDecoration(
              color:
                  group_level ? kbuttonColor3 : kbuttonColor3.withOpacity(.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: InkWell(
              onTap: group_level
                  ? () {
                      _modalBottomSheetMenuappoint(context);
                    }
                  : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    _isloadingappointment
                        ? CircularProgressIndicator()
                        : Text(
                            app_name,
                            style: TextStyle(
                                fontFamily: 'AraHamah1964B-Bold',
                                fontSize: 20,
                                color: group_level
                                    ? Colors.black
                                    : Colors.black26),
                          ),
                    Spacer(),
                    Icon(Icons.keyboard_arrow_down)
                  ],
                ),
              ),
            ),
          ),
          Consumer<AppStateManager>(
            builder: (context, appstatemanager, child) => GestureDetector(
              onTap: app_name != 'الحصه'
                  ? () async {
                      setState(() {
                        _loadingscann = true;
                      });
                      String res = await FlutterBarcodeScanner.scanBarcode(
                          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
                      try {
                        await Provider.of<AppointmentManager>(context,
                                listen: false)
                            .attendlesson(app_id_selected, res, app_id_selected)
                            .then(
                              (value) =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green[300],
                                  content: Text(
                                    'تم تسجيل حضور الطالب بنجاح',
                                    style: TextStyle(fontFamily: 'GE-medium'),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              ),
                            );
                      } catch (e) {
                        _showErrorDialog('حاول مره اخري', 'حدث خطأ');
                      }
                      setState(() {
                        _loadingscann = false;
                      });

                      // .then((value) =>
                      //     _showErrorDialog(app_id_selected, res));
                    }
                  // .then((value) =>
                  //     _showErrorDialog(app_id_selected, scanResult_code))
                  : null,
              child: Scan_button(
                active: app_name != 'الحصه' || !_loadingscann,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'حدث خطأ حاول مره اخري ';
      _showErrorDialog('حاول مره اخري', 'حدث خطا');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      scanResult_code = barcodeScanRes;
    });
    // setState(() {
    //   _scanBarcode = barcodeScanRes;
    // });
  }

  Future scanBarcode() async {
    String? scanResult;
    setState(() {
      _scanloading = true;
    });
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
              '#ff6666', "cancel", true, ScanMode.BARCODE)
          .then((value) {
        print(value);
      });
      // .then(
      //   (value) => Provider.of<AppointmentManager>(context, listen: false)
      //       .attendlesson(group_id_selected, value, app_id_selected),
      // )
      // .then((value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       backgroundColor: Colors.green[300],
      //       content: Text(
      //         'تم تسجيل حضور الطالب بنجاح',
      //         style: TextStyle(fontFamily: 'GE-medium'),
      //       ),
      //       duration: Duration(seconds: 3),
      //     )));
    } on PlatformException {
      _showErrorDialog('حاول مره اخري', 'حدث خطا');
    }
    if (!mounted) return;
    setState(() {
      scanResult_code = scanResult!;

      _scanloading = false;
    });
  }
}

class Choice_container extends StatelessWidget {
  Choice_container(
      {Key? key,
      required this.size,
      required this.color,
      required this.items,
      // required this.value,
      required this.fnc,
      required this.hinttext,
      required this.active,
      this.loading = false})
      : super(key: key);
  final String hinttext;
  final Size size;
  final Color color;
  final List<String> items;
  // final String value;
  final Function() fnc;
  final bool active;
  final bool? loading;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 6),
      margin: EdgeInsets.all(1),
      alignment: Alignment.center,
      height: size.height * .6 * .16,
      width: size.width * .45,
      decoration: BoxDecoration(
        color: active ? color : color.withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: active ? () => fnc() : null,
        child: Container(
          child: Row(
            children: [
              loading!
                  ? CircularProgressIndicator()
                  : Container(
                      width: size.width * .35,
                      child: Text(
                        hinttext,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            fontFamily: 'AraHamah1964B-Bold',
                            fontSize: 30,
                            color: active ? Colors.black : Colors.black26),
                      ),
                    ),
              Spacer(),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      ),
    );
  }
}

class Button_Container extends StatelessWidget {
  const Button_Container(
      {Key? key,
      required this.size,
      required this.color,
      required this.text,
      required this.fnc})
      : super(key: key);
  final Size size;
  final Color color;
  final String text;
  final VoidCallback fnc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: fnc,
      child: Container(
        margin: EdgeInsets.all(1),
        alignment: Alignment.center,
        height: size.height * .6 * .16,
        width: size.width * .45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: size.width * .4,
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style:
                    TextStyle(fontFamily: 'AraHamah1964B-Bold', fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
