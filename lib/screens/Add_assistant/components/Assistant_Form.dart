import 'package:attendance/helper/httpexception.dart';
import 'package:attendance/managers/assistant_manager.dart';
import 'package:attendance/managers/cities_manager.dart';
import 'package:attendance/managers/subject_manager.dart';
import 'package:attendance/managers/teacher_manager.dart';
import 'package:attendance/managers/year_manager.dart';
import 'package:attendance/screens/Home/components/choices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Assistant_Form extends StatefulWidget {
  const Assistant_Form({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _Assistant_FormState createState() => _Assistant_FormState();
}

class _Assistant_FormState extends State<Assistant_Form> {
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  final focus7 = FocusNode();
  final focus8 = FocusNode();
  final focus9 = FocusNode();
  final focus10 = FocusNode();
  final focus11 = FocusNode();
  final focus12 = FocusNode();
  final focus13 = FocusNode();
  final focus14 = FocusNode();
  final focus15 = FocusNode();

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var pass1Controller = TextEditingController();
  var pass2Controller = TextEditingController();
  var phoneController = TextEditingController();
  var noteController = TextEditingController();

  @override
  void dispose() {
    _isLoading = false;
    nameController.dispose();
    emailController.dispose();
    pass1Controller.dispose();
    pass2Controller.dispose();
    phoneController.dispose();
    noteController.dispose();

    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();
    focus5.dispose();
    focus6.dispose();
    focus7.dispose();
    focus8.dispose();
    focus9.dispose();
    focus10.dispose();
    focus11.dispose();
    focus12.dispose();
    focus13.dispose();
    focus14.dispose();
    focus15.dispose();

    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isLoading = true;

  Map<String, dynamic> _register_data = {'level': null};

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (teachername == 'المدرس' || _register_data['level'] == null) {
      _showErrorDialog('برجاء ادخال جميع البيانات');
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AssistantManager>(context, listen: false)
          .add_assistant(
              nameController.text,
              phoneController.text,
              emailController.text,
              pass1Controller.text,
              pass2Controller.text,
              noteController.text,
              teacher_id_selected.toString(),
              _register_data['level'] == 'مساعد اول' ? 1 : 0)
          .then((_) {
        _formKey.currentState?.reset();
        nameController.text = '';
        emailController.text = '';
        pass1Controller.text = '';
        pass2Controller.text = '';
        phoneController.text = '';

        noteController.text = '';

        teacher_id_selected = '';
        teachername = 'المدرس';
        _register_data['level'] = null;
      }).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: Text(
              'تم اضافه المساعد بنجاح',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: Duration(seconds: 3),
          ),
        ),
      );
    } on HttpException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      const errorMessage = 'حاول مره اخري';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'حدث خطا',
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
                  backgroundColor:
                      MaterialStateProperty.all(kbackgroundColor1)),
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

  ScrollController _sc = new ScrollController();

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
            _isLoading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;

      _sc.addListener(
        () {
          if (_sc.position.pixels == _sc.position.maxScrollExtent) {
            Provider.of<TeacherManager>(context, listen: false).getMoreData();
          }
        },
      );
    });
  }

  late String teacher_id_selected;
  String teachername = 'المدرس';

  void _modalBottomSheetMenu3(BuildContext context) {
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
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kbuttonColor2,
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
                            controller: _sc,
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
                                onTap: () {
                                  setState(() {
                                    teacher_id_selected = teachermanager
                                        .teachers[index].id
                                        .toString();
                                    teachername =
                                        teachermanager.teachers[index].name!;
                                  });
                                  Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: Container(
              margin: EdgeInsets.all(50),
              child: CircularProgressIndicator(),
            ),
          )
        : Container(
            // height: widget.size.height * .8,
            width: widget.size.width,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      width: widget.size.width * .9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              alignment: Alignment.centerRight,
                              width: widget.size.width * .9,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: InkWell(
                                onTap: () => _modalBottomSheetMenu3(context),
                                child: Container(
                                  child: Row(
                                    children: [
                                      Text(
                                        teachername,
                                        style:
                                            TextStyle(fontFamily: 'GE-light'),
                                      ),
                                      Spacer(),
                                      Icon(Icons.keyboard_arrow_down)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: widget.size.width * .9,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Container(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            style: TextStyle(
                                fontFamily: 'GE-medium', color: Colors.black),
                            value: _register_data['level'],
                            hint: Text('صلاحيه المساعد'),
                            isExpanded: true,
                            iconSize: 30,
                            onChanged: (newval) {
                              setState(() {
                                _register_data['level'] = newval.toString();
                              });
                            },
                            icon: Icon(Icons.keyboard_arrow_down),
                            items: ['مساعد اول', 'مساعد ثانى']
                                .map((item) => DropdownMenuItem(
                                      child: Text(item),
                                      value: item,
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  build_edit_field(
                      item: 'name',
                      hint: 'الاسم',
                      controller: nameController,
                      inputType: TextInputType.name,
                      validate: (value) {},
                      focus: focus1),
                  build_edit_field(
                      item: 'email',
                      hint: 'email',
                      controller: emailController,
                      inputType: TextInputType.name,
                      validate: (value) {},
                      focus: focus2),
                  build_edit_field(
                    item: 'password1',
                    hint: 'password',
                    controller: pass1Controller,
                    inputType: TextInputType.name,
                    validate: (value) {},
                    focus: focus3,
                  ),
                  build_edit_field(
                    item: 'password2',
                    hint: 'password confirmation',
                    controller: pass2Controller,
                    inputType: TextInputType.name,
                    validate: (value) {},
                    focus: focus15,
                  ),
                  build_edit_field(
                    item: 'phone_number',
                    hint: 'رقم التليفون',
                    controller: phoneController,
                    inputType: TextInputType.name,
                    validate: (value) {},
                    focus: focus12,
                  ),
                  build_edit_field(
                    item: 'note',
                    hint: 'ملاحظات',
                    controller: noteController,
                    inputType: TextInputType.name,
                    validate: (value) {},
                    focus: focus13,
                  ),
                  Container(
                    width: widget.size.width * .9,
                    child: TextButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.all(kbackgroundColor3)),
                      onPressed: _submit,
                      child: Text(
                        'تسجيل',
                        style: TextStyle(
                            fontFamily: 'GE-Bold', color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }

  Center build_edit_field({
    required String item,
    required String hint,
    bool small = false,
    required TextEditingController controller,
    required TextInputType inputType,
    Function(String)? validate,
    FocusNode? focus,
  }) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        width: small ? widget.size.width * .9 / 2 : widget.size.width * .9,
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: Container(
          child: TextFormField(
            // maxLength: 6,

            focusNode: focus,
            textInputAction: TextInputAction.next,
            onSaved: (value) {
              _register_data[item] = value!;
            },
            keyboardType: inputType,
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return '*';
              }
              return null;
            },
            onChanged: (value) {},
            decoration: InputDecoration(
              focusedErrorBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              errorStyle: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 12,
              ),
              hintText: hint,
              hintStyle: TextStyle(fontFamily: 'GE-light', fontSize: 15),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
