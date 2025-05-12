class LoginModel {
  String? email;
  String? name;
  String? token;

  LoginModel({this.email, this.name, this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    token = json['token'];
  }
}
