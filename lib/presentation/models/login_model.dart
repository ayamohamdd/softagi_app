class LoginModel {
  bool? status;
  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    data = UserData.fromJson(json['data']);
  }
}

class UserData {
  dynamic id;
  String name='';
  String email='';
  String phone='';
  String image='';
  dynamic points;
  dynamic credit;
  String token='';

  UserData.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    image = json["image"];
    points = json["points"];
    credit = json["credit"];
    token = json["token"];
  }
}
