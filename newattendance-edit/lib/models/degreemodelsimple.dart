import 'package:attendance/models/subject.dart';
import 'package:attendance/models/teacher.dart';
import 'package:attendance/models/year.dart';

class DegreeSimpleModel {
  int? id;
  String? degree;
  
  // List<AppointmentModel>? appointments;

  DegreeSimpleModel(
      {this.id,
      this.degree,
     
      // this.appointments,
      });

  DegreeSimpleModel.fromJson(Map<String, dynamic> json) {
   

    id = json['student_id'];
    degree = json['degree'];
   

    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['degree'] = this.degree;
   
    return data;
  }
}
