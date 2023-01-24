import 'dart:convert';

class UserModel {
  int id;
  String name;
  String email;
  DateTime? emailVarificationAt;
  DateTime createdAt;
  DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    this.emailVarificationAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVarificationAt != null ? emailVarificationAt!.toIso8601String() : null,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt != null ? updatedAt!.toIso8601String() : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      emailVarificationAt: map['email_verified_at'] != null ? DateTime.parse(map['email_verified_at']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
