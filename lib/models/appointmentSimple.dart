class AppointmentModelSimple {
  int? id;
  bool? attend;
  String? degree;
  String? compensationId;

  AppointmentModelSimple(
      {this.id, this.attend, this.degree, this.compensationId});

  AppointmentModelSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    attend = json['attend'];
    degree = json['degree'];
    compensationId = json['compensation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['attend'] = this.attend;
    data['degree'] = this.degree;
    data['compensation_id'] = this.compensationId;
    return data;
  }
}
