import 'dart:ui';

import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/Teachers_show/components/teachers_top_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class Show_Teachers extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Attendance_Screens.teachers_show,
      key: ValueKey(Attendance_Screens.teachers_show),
      child: Show_Teachers(),
    );
  }

  Show_Teachers({
    Key? key,
  }) : super(key: key);

  @override
  _Show_TeachersState createState() => _Show_TeachersState();
}

class _Show_TeachersState extends State<Show_Teachers> {
  var colors = [
    kbuttonColor1.withOpacity(.5),
    Colors.white,
  ];

  var text_colors = [Colors.black, Colors.black];

  Map<String, dynamic> _add_data = {
    'year': null,
  };
  // ScrollController _sc = new ScrollController();

  var yearController = TextEditingController();

  String text_value = '';
  ScrollController _sc = new ScrollController();

  bool _isloading = true;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      Provider.of<TeacherManager>(context, listen: false).resetlist();
      try {
        await Provider.of<TeacherManager>(context, listen: false)
            .getMoreData()
            .then((_) {
          setState(() {
            _isloading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;

      _sc.addListener(() {
        if (_sc.position.pixels == _sc.position.maxScrollExtent) {
          Provider.of<TeacherManager>(context, listen: false).getMoreData();
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _sc.dispose();

    super.dispose();
  }

  void _showErrorDialog(String message, String title, int id) {
    showDialog(
      barrierDismissible: false,
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
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.red.withOpacity(.6))),
                    // color: kbackgroundColor1,
                    child: Text(
                      'نعم',
                      style: TextStyle(
                          fontFamily: 'GE-medium', color: Colors.black),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      Navigator.of(ctx).pop();

                      await Provider.of<TeacherManager>(context, listen: false)
                          .delete_teacher(id)
                          .then((value) => Provider.of<TeacherManager>(context,
                                  listen: false)
                              .getMoreData())
                          .then((_) {
                        setState(() {
                          _isloading = false;
                        });
                      });
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.green.withOpacity(.6))),
                    // color: kbackgroundColor1,
                    child: Text(
                      'لا',
                      style: TextStyle(
                          fontFamily: 'GE-medium', color: Colors.black),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey[350],
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Show_Teachers_Top_Page(
                  size: size,
                ),
                Container(
                  color: Colors.white,
                  height: 20,
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
                                        .getMoreData();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child:
                                        Text("error please tap to try again"),
                                  ),
                                ));
                              }
                            } else {
                              return ListView.builder(
                                controller: _sc,
                                itemCount: teachermanager.teachers.length +
                                    (teachermanager.hasmore ? 1 : 0),
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  if (Index == teachermanager.teachers.length) {
                                    if (teachermanager.error) {
                                      return Center(
                                          child: InkWell(
                                        onTap: () {
                                          teachermanager.setloading(true);
                                          teachermanager.seterror(false);
                                          Provider.of<TeacherManager>(context,
                                                  listen: false)
                                              .getMoreData();
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

                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    color: colors[Index % colors.length],
                                    child: Dismissible(
                                      direction: DismissDirection.startToEnd,
                                      background: Container(color: Colors.red),
                                      // key: Key(Index.toString()),
                                      key: UniqueKey(),

                                      onDismissed: (dirction) {
                                        if (dirction ==
                                            DismissDirection.startToEnd) {
                                          _showErrorDialog(
                                              'تاكيد مسح المدرس',
                                              'تاكيد',
                                              teachermanager
                                                  .teachers[Index].id!);
                                        }
                                      },
                                      child: InkWell(
                                        onDoubleTap: () {
                                          Provider.of<AppStateManager>(context,
                                                  listen: false)
                                              .teacherTapped(
                                                  teachermanager
                                                      .teachers[Index].id
                                                      .toString(),
                                                  true,
                                                  teachermanager
                                                      .teachers[Index]);
                                        },
                                        child: ListTile(
                                          title: Text(
                                            teachermanager
                                                        .teachers[Index].name ==
                                                    null
                                                ? ''
                                                : teachermanager
                                                    .teachers[Index].name!,
                                            style: TextStyle(
                                                color: text_colors[
                                                    Index % colors.length],
                                                fontFamily: 'GE-light'),
                                          ),
                                          // trailing: Text(
                                          //   teachermanager.teachers[Index]
                                          //           .years ==null? '':
                                          //          teachermanager.teachers[Index]
                                          //           .years. ,
                                          //   style: TextStyle(
                                          //       color: text_colors[
                                          //           Index % colors.length],
                                          //       fontFamily: 'GE-light'),
                                          // ),
                                          onTap: () {
                                            // Provider.of<AppStateManager>(
                                            //         context,
                                            //         listen: false)
                                            //     .goToSinglegroup(
                                            //         true,
                                            //         teachermanager
                                            //             .teachers[Index].id
                                            //             .toString(),
                                            //         teachermanager
                                            //             .teachers[Index]);
                                          },
                                          subtitle: Text(
                                            teachermanager.teachers[Index]
                                                        .subject ==
                                                    null
                                                ? ''
                                                : teachermanager.teachers[Index]
                                                    .subject!.name!
                                                    .toString(),
                                            style: TextStyle(
                                                color: text_colors[
                                                    Index % colors.length],
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'GE-medium'),
                                          ),
                                        ),
                                      ),
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
                  ),
                ),
              ],
            ),
    ));
  }
}
