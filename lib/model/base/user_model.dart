import 'dart:convert';

class UserModel {
  int id;
  String name;
  String email;
  String? emailVarificationAt;
  String createdAt;
  String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVarificationAt,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'emailVarificationAt': emailVarificationAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      emailVarificationAt: map['emailVarificationAt'] ?? '',
      createdAt: map['createdAt'] ?? '',
      updatedAt: map['updatedAt'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
