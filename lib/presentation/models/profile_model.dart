class UserModel {
  bool? status;
  Null? message;
  Data? data;

  UserModel({this.status, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = Data.fromJson(json['data']);
  }

}

class Data {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? image;
  int? points;
  double? credit;
  String? token;

  
  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    points = json['points'];
    credit = json['credit'];
    token = json['token'];
  }
}