// import 'package:attendance/constants.dart';
// import 'package:attendance/helper/httpexception.dart';
// import 'package:attendance/managers/group_manager.dart';
// import 'package:attendance/managers/subject_manager.dart';
// import 'package:attendance/managers/teacher_manager.dart';
// import 'package:attendance/managers/year_manager.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class groupToAdd extends StatefulWidget {
//   const groupToAdd({
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   _groupToAddState createState() => _groupToAddState();
// }

// class _groupToAddState extends State<groupToAdd> {
//   final GlobalKey<FormState> _formKey = GlobalKey();
//   FocusNode fnode = FocusNode();
//   void _submit() async {
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
    
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await Provider.of<GroupManager>(context, listen: false)
//           .addgroup(
//             nameController.text,
//             '78',''
          
            
            
//           )
//           .then((_) {
//             nameController.text = '';
            
//           })
//           .then((value) => setState(() {
//                 _isLoading = false;
//               }))
//           .then(
//             (_) => ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.green[300],
//                 content: Text(
//                   'تم اضافه المجموعه بنجاح',
//                   style: TextStyle(fontFamily: 'GE-medium'),
//                 ),
//                 duration: Duration(seconds: 3),
//               ),
//             ),
//           );
//     } on HttpException catch (error) {
//       _showErrorDialog('حاول مره اخري ', 'حدث خطأ');
//     } catch (error) {
//       _showErrorDialog('حاول مره اخري ', 'حدث خطأ');
//     }
//     setState(() {
//       _isLoading = false;
//     });
//   }

//   var _isLoading = false;
//   Map<String, dynamic> _register_data = {
//     'name': '',
   
//   };
  
//   // int count = 1;
//   // List<dynamic> _data = [null, null, null, null, null, null, null, null];
  
 

 

  

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     // _sc.dispose();
//     // _sc2.dispose();
//     // _sc3.dispose();

//     super.dispose();
//   }

//   var nameController = TextEditingController();

 


//   void _showErrorDialog(String message, String title) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text(
//           title,
//           style: TextStyle(fontFamily: 'GE-Bold'),
//         ),
//         content: Text(
//           message,
//           style: TextStyle(fontFamily: 'AraHamah1964R-Bold'),
//         ),
//         actions: <Widget>[
//           Center(
//             child: TextButton(
//               style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(kbuttonColor2)),
//               // color: kbackgroundColor1,
//               child: Text(
//                 'حسنا',
//                 style: TextStyle(fontFamily: 'GE-medium', color: Colors.black),
//               ),
//               onPressed: () {
//                 Navigator.of(ctx).pop();
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();

//   }

  

  

  
  
//   @override
//   Widget build(BuildContext context) {
//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : Container(
//             height: widget.size.height * .9,
//             width: widget.size.width,
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   Container(
//                     height: widget.size.height * .4,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         SizedBox(
//                           height: 1,
//                         ),
//                         build_edit_field(
//                             item: 'name',
//                             hint: 'الاسم',
//                             inputType: TextInputType.name,
//                             controller: nameController),
                        
//                   Container(
//                     width: widget.size.width * .9,
//                     // margin: EdgeInsets.symmetric(vertical: 1),
//                     child: TextButton(
//                       style: ButtonStyle(
//                           elevation: MaterialStateProperty.all(2),
//                           backgroundColor:
//                               MaterialStateProperty.all(kbuttonColor2)),
//                       onPressed: _submit,
//                       child: Text(
//                         'تسجيل',
//                         style: TextStyle(
//                             fontFamily: 'GE-Bold', color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   height: .5,
//                   // )
//                 ],
//               ),
//             ),
//                 ]
//               ),

//             )
//                   );
//   }

//   Center build_edit_field({
//     required String item,
//     required String hint,
//     bool small = false,
//     required TextEditingController controller,
//     required TextInputType inputType,
//   }) {
//     return Center(
//       child: Container(
//         alignment: Alignment.centerRight,
//         width: small ? widget.size.width * .9 / 2 : widget.size.width * .9,
//         padding: EdgeInsets.symmetric(horizontal: 20),
//         height: 55,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(color: Colors.grey),
//         ),
//         child: Container(
//           child: TextFormField(
//             // focusNode: fnode,
//             onSaved: (value) {
//               _register_data[item] = value!;
//             },
//             // onTap: on_tap,

//             keyboardType: inputType,
//             controller: controller,
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return '*';
//               }
//               return null;
//             },
//             onChanged: (value) {},
//             decoration: InputDecoration(
//               hintText: hint,
//               hintStyle: TextStyle(
//                 fontFamily: 'GE-medium',
//               ),
//               enabledBorder: InputBorder.none,
//               focusedBorder: InputBorder.none,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
