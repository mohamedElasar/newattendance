class AssistantModel {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? password;
  String? passwordConfirmation;
  String? note;
  String? teacherId;
  int? level;

  AssistantModel(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.password,
      this.passwordConfirmation,
      this.note,
      this.teacherId,
      this.level});

  AssistantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    note = json['note'];
    teacherId = json['teacher_id'];
    level = json['premier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['password'] = this.password;
    data['password_confirmation'] = this.passwordConfirmation;
    data['note'] = this.note;
    data['teacher_id'] = this.teacherId;
    data['premier'] = this.level;
    return data;
  }
}
