class UserModel {
  String? email;
  String? name;
  String? address;
  int? gender;
  DateTime? birthday;

  UserModel({this.address, this.birthday, this.email, this.gender, this.name});

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    address = json['address'] ?? "";
    gender = json['gender'];
    birthday = json['dateOfBirth'] != null
        ? DateTime.parse(json['dateOfBirth'])
        : null;
  }
}
