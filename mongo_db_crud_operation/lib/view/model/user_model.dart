// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String name;
  int age;
  String email;

  UserModel({
    required this.name,
    required this.age,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json["name"],
        age: json["age"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "age": age,
        "email": email,
      };
}
