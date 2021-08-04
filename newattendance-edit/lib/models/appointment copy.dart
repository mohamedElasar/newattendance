// import 'package:attendance/models/student.dart';

// import 'StudentModelSimple.dart';

// class AppointmentModelDegree {
//   // int? id;
//   // String? time;
//   // String? date;
//   List<StudentModelSimple>? students;

//   AppointmentModelDegree({ this.students});

//   AppointmentModelDegree.fromJson(Map<String, dynamic> json) {
   
//     students = List<StudentModelSimple>.from(
//       json['students'].map(
//         (model) => StudentModelSimple.fromJson(model),
//       ),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
   

//     if (this.students != null) {
//       data['students'] = this.students!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
