import 'dart:ui';

import 'package:attendance/constants.dart';
import 'package:attendance/helper/httpexception.dart';
import 'package:attendance/managers/App_State_manager.dart';
import 'package:attendance/managers/Appointment_manager.dart';
import 'package:attendance/managers/degree_manager.dart';
import 'package:attendance/managers/group_manager.dart';
import 'package:attendance/models/StudentModelSimple.dart';
import 'package:attendance/models/appointment.dart';
import 'package:attendance/models/group.dart';
import 'package:attendance/models/groupmodelsimple.dart';
import 'package:attendance/navigation/screens.dart';
import 'package:attendance/screens/Student_register/components/Register_form.dart';
import 'package:attendance/screens/show_group_presence/components/Presence_top_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'components/default_form_field.dart';

String? Group_Id;
int? Student__id;
var added_degrees = [];
int i = 0;
bool isLoading = false;

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

  // @override

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
  List<StudentModelSimple> search_list = [];
  List<StudentModelSimple> search_list_all = [];
  TextEditingController searchController = new TextEditingController();
  Icon _searchIcon = new Icon(Icons.search);
  // final List<Map<String, dynamic>> _allUsers = [
  // //   // {"id": 1, "name": "Andy", "age": 29},
  // //   // {"id": 2, "name": "Aragon", "age": 40},
  // //   // {"id": 3, "name": "Bob", "age": 5},
  // //   // {"id": 4, "name": "Barbara", "age": 35},
  // //   // {"id": 5, "name": "Candy", "age": 21},
  // //   // {"id": 6, "name": "Colin", "age": 55},
  // //   // {"id": 7, "name": "Audra", "age": 30},
  // //   // {"id": 8, "name": "Banana", "age": 14},
  // //   // {"id": 9, "name": "Caversky", "age": 100},
  // //   // {"id": 10, "name": "Becky", "age": 32},
  // // ];

  // This list holds the data for the list view
  //List _foundUsers = [];
  // @override
  // initState() {
  //   // at the beginning, all users are shown
  //   _foundUsers = _allUsers;
  //   super.initState();
  // }

  // This function is called whenever the text field changes

  // void _searchPressed() {
  //   setState(() {
  //     search_list;
  //     search_list_all;
  //     if (this._searchIcon.icon == Icons.search) {
  //       this._searchIcon = new Icon(Icons.close);
  //       // this._appBarTitle = new TextField(
  //       //   controller: searchController,
  //       //   cursorColor: Colors.white,
  //       //   style: TextStyle(color: Colors.white),
  //       //   decoration: new InputDecoration(
  //       //     hintStyle: TextStyle(color: Colors.white),
  //       //     prefixIcon: new Icon(
  //       //       Icons.search,
  //       //       color: Colors.white,
  //       //     ),
  //       //     hintText: 'Search...',
  //       //   ),
  //       // );
  //     } else {
  //       this._searchIcon = new Icon(Icons.search);
  //       // this._appBarTitle = new Text('Search Example');

  //       searchController.clear();
  //     }
  //   });
  // }
  //  if(text.isNotEmpty){
  //     setState(() {
  //       dogsBreedList = tempList;
  //     });
  //   }
  //   else{
  //     final List<String> filtered_names = List<String>();
  //     tempList.map((breed){
  //       if(breed.contains(text.toString().toUpperCase())){
  //         filtered_names.add(breed);
  //       }
  //     }).toList();
  //     setState(() {
  //       dogsBreedList.clear();
  //       dogsBreedList.addAll(filtered_names);
  //     });
  //   }
  // }
  // void _runFilter(String enteredKeyword) {
  //   List<Map<String, dynamic>> results = [];
  //   if (enteredKeyword.isEmpty) {
  //     // if the search field is empty or only contains white-space, we'll display all users
  //     results = _allUsers;
  //   } else {
  //     results = _allUsers
  //         .where((user) =>
  //             user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
  //         .toList();
  //     // we use the toLowerCase() method to make it case-insensitive
  //   }

  //   // Refresh the UI
  //   setState(() {
  //     _foundUsers = results;
  //   });
  // }

  bool sent = false;
  String Lesson_Id = '';
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode fnode = FocusNode();

  void get_degree() async {
    setState(() {
      Lesson_Id;
      search_list;
      search_list_all;
      isLoading = true;
    });
    await Provider.of<AppointmentManager>(context, listen: false)
        .get_degrees(Lesson_Id)
        .then((_) {
      // degreeController.text = '';
      // setState(() {
      //   //   sent = true;
      //   search_list_all.clear();
      //   search_list_all.addAll(search_list);
      // });
    }).then((value) => setState(() {
              _isLoading = false;
            }));
    //.then(
    // (_) => ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: Colors.green[300],
    //     content: Text(
    //       'تم',
    //       style: TextStyle(fontFamily: 'GE-medium'),
    //     ),
    //     duration: Duration(seconds: 3),
    //   ),
    // ),
    // );
    // }
    // on HttpException catch (error) {
    //   _showErrorDialog('حاول مره اخري ', 'حدث خطأ');

    setState(() {
      search_list_all = search_list;
      _isLoading = false;
      isLoading = false;
    });
  }

  _filterDogList(String text) {
    if (text.isNotEmpty) {
      setState(() {
        search_list_all = search_list;
      });
    } else {
      final List<StudentModelSimple> filtered_names = [];
      search_list.map((breed) {
        if (breed.name!.contains(text.toString().toUpperCase())) {
          filtered_names.add(breed);
        }
      });
      setState(() {
        search_list_all.clear();
        search_list_all.addAll(filtered_names);
      });
    }
  }

  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    // try {
    setState(() {
      Group_Id;
    });
    await Provider.of<GroupManager>(context, listen: false)
        .adddegree(degreeController.text, '$Student__id', Lesson_Id)
        .then((_) {
          degreeController.text = '';
          setState(() {
            sent = true;
          });
        })
        .then((value) => setState(() {
              _isLoading = false;
            }))
        .then(
          (_) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green[300],
              content: Text(
                'تم اضافه الدرجة بنجاح',
                style: TextStyle(fontFamily: 'GE-medium'),
              ),
              duration: Duration(seconds: 3),
            ),
          ),
        );
    //}
    // on HttpException catch (error) {
    //   _showErrorDialog('حاول مره اخري ', 'حدث خطأ');
    // } catch (error) {
    //   _showErrorDialog('حاول مره اخري ', 'حدث خطأ');
    // }
    // setState(() {
    //   _isLoading = false;
    // });
  }

  var _isLoading = false;
  Map<String, dynamic> _register_data = {
    'name': '',
  };

  // int count = 1;
  // List<dynamic> _data = [null, null, null, null, null, null, null, null];

  @override
  void dispose() {
    super.dispose();
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

  int _selectedIndex = 0;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  String button_text = 'أضافة درجة';
  bool show_text = false;

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
  var degreeController = TextEditingController();

  String text_value = '';

  bool _isloading = true;

  @override
  void initState() {
    super.initState();

    // sea=new List();
    searchController.addListener(() {
      print(searchController.text);
      if (searchController.text.isEmpty) {
        setState(() {
          search_list.clear();
          search_list.addAll(search_list_all);
          search_list;
          search_list_all;
          print("search_list");
          print(search_list);
          print("search_list_all");
          print(search_list_all);
        });
      } else {
        setState(() {
          search_list.clear();
          for (int k = 0; k < search_list_all.length; k++) {
            print(search_list_all[k].name! + " names ");
            if (search_list_all[k]
                .name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase())) {
              print(search_list_all[k].name! + " names inside");
              search_list.add(search_list_all[k]);
            } else {
              search_list.clear();
              search_list_all.clear();
            }
          }
        });
      }
    });

    Future.delayed(Duration.zero, () async {
      // Provider.of<AppointmentManager>(context, listen: false).resetlist();
      try {
        await Provider.of<AppointmentManager>(context, listen: false)
            .get_students_attending_lesson(widget.group_id!, widget.mylessonid!)
            .then((_) {
          setState(() {
            _isloading = false;

            search_list = search_list_all;

            Lesson_Id = widget.mylessonid!;
            print('LESSON_Id');
            print(Lesson_Id);
            print('widget.group_id!');
            print(widget.group_id!);

            search_list_all = search_list;
            isLoading = false;
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
// var degreeController = TextEditingController();

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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 26,
                    vertical: 5,
                  ),
                  child: Center(
                    child: TextField(
                      // onChanged: (value) => _runFilter(value),
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'بحث بالاسم  ',
                        suffixIcon: IconButton(
                            icon: this._searchIcon,
                            onPressed: () {
                              // _searchPressed();
                            }),
                      ),
                      onChanged: (text) {
                        _filterDogList(text);
                      },
                    ),
                  ),
                ),
                SizedBox(
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
                        // color: kbackgroundColor2,
                        child: Consumer<AppointmentManager>(
                          builder: (builder, appmgr, child) => appmgr
                                      .student_attend.isEmpty ||
                                  _isLoading
                              ? Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'لا يوجد طلاب',
                                    //  حضرو الحصه',
                                    style: TextStyle(fontFamily: 'GE-Bold'),
                                  ),
                                )
                              : ListView.separated(
                                  separatorBuilder:
                                      (BuildContext ctxt, int Index) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            child: Divider(
                                              color: Colors.black,
                                              height: 3,
                                              //thickness: 3,
                                            ),
                                          ),
                                  // controller: _sc,
                                  itemCount: appmgr.student_attend.length,
                                  itemBuilder: (BuildContext ctxt, int Index) {
                                    search_list
                                        .add(appmgr.student_attend[Index]);
                                    // search_list_all.clear();
                                    // search_list_all.addAll(search_list);

                                    print("search_listtttttttt");
                                    print(search_list);
                                    // key:
                                    // ValueKey(appmgr.student_attend[Index]);
                                    // _foundUsers.add(appmgr.student_attend)
                                    // for (int j = 0;
                                    //     j <= list_index.length ;
                                    //     j++) {

                                    //}
                                    // _foundUsers
                                    //     .add(appmgr.student_attend[Index]);
                                    // i = Index;
                                    Student__id =
                                        appmgr.student_attend[Index].id;
                                    print('Student__id');
                                    print(Student__id);
                                    // _allUsers.add({
                                    //   "id": appmgr.student_attend[Index].id,
                                    //   "name": appmgr.student_attend[Index].name
                                    // });
                                    // int index = Index;
                                    return Column(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.symmetric(vertical: 5),
                                          color: colors[Index % colors.length],
                                          child: ListTile(
                                            trailing: Text(
                                              // 'شسيشسي',
                                              appmgr.student_attend[Index]
                                                      .phone ??
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

                                              appmgr
                                                  .student_attend[Index].name!,
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
                                        Row(
                                          children: [
                                            sent == true
                                                ? Container(
                                                    width: 80,
                                                    height: 35,
                                                    color: colors[
                                                        Index % colors.length],
                                                    child: Center(
                                                      child: Text(
                                                        // degreeController.text,

                                                        // added_degrees[i] ==
                                                        //         appmgr
                                                        //             .student_attend[
                                                        //                 Index]
                                                        //             .parentPhone!
                                                        //     ? added_degrees[i]
                                                        appmgr
                                                            .appointments_degree![
                                                                Index]
                                                            .degree!,
                                                        // appmgr
                                                        //     .appointments_degree![Index].degree!,

                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Spacer(),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: MaterialButton(
                                                color: Colors.black,
                                                onPressed: () {
                                                  // setState(() {

                                                  // });
                                                  _onSelected(Index);
                                                  // Scaffold.of(context);
                                                  // Provider.of<AppStateManager>(
                                                  //    context,
                                                  //
                                                  //
                                                  //   listen: false);
                                                  // for (i;
                                                  //     i <= list_index.length;
                                                  //     i++) {
                                                  if (_selectedIndex == Index) {
                                                    setState(() {
                                                      show_text = !show_text;

                                                      _selectedIndex;
                                                      _submit();
                                                      sent;
                                                      print('degree');
                                                      print(appmgr
                                                          .student_attend[Index]
                                                          .name);
                                                      added_degrees.add(appmgr
                                                          .student_attend[Index]
                                                          .parentPhone);

                                                      added_degrees;
                                                      i;
                                                      Lesson_Id;

                                                      get_degree();
                                                      print('degreeeeeeeeee');
                                                      print(appmgr
                                                          .appointments_degree![
                                                              Index]
                                                          .discount!);

                                                      print('degreeeeeeeeee');
                                                      // print( appmgr
                                                      //       .appointment[Index].id);

                                                      print('degreeeeeeeeee');
                                                      // print( appmgr
                                                      //       .appointment[Index].students![Index].degree!);
                                                    });
                                                  }
                                                  // _submit();

                                                  // }
                                                  get_degree();
                                                },
                                                child: Text(
                                                  //context:ctxt,
                                                  show_text &&
                                                          _selectedIndex ==
                                                              Index
                                                      ? 'حفظ'
                                                      : button_text,

                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        _selectedIndex == Index
                                            //list_index[index]
                                            ? Visibility(
                                                visible:
                                                    !show_text ? false : true,
                                                child: Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Container(
                                                    width: 120,
                                                    color: colors[
                                                        Index % colors.length],
                                                    child: TextFormField(
                                                      controller:
                                                          degreeController,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            :

                                            // Text('data'),
                                            // defaultFormField(
                                            //   controller:degreeController ,
                                            //   type: TextInputType.number,
                                            //   validate: (){},
                                            //   //  text: '',
                                            //   // isPassword: false,
                                            //   prefix: Icons.format_list_numbered

                                            // ),
                                            // Edit_Text(size: size, name: ''),

                                            // TextFormField(),
                                            // SizedBox(
                                            //   width: 15,
                                            // ),

                                            // Text("jjj")

                                            SizedBox(
                                                height: 10,
                                              ),
                                      ],
                                    );
                                  }),
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
