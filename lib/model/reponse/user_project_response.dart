import 'dart:convert';

import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/model/base/user_model.dart';

class UserProjectResponse {
  int id;
  ProjectModel project;
  UserModel user;
  bool isDefault;
  String createdAt;
  String updatedAt;
  
  UserProjectResponse({
    required this.id,
    required this.project,
    required this.user,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'project': project.toMap(),
      'user': user.toMap(),
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProjectResponse.fromMap(Map<String, dynamic> map) {
    return UserProjectResponse(
      id: map['id']?.toInt() ?? 0,
      project: ProjectModel.fromMap(map['project']),
      user: UserModel.fromMap(map['user']),
      isDefault: map['is_default'] ?? false,
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProjectResponse.fromJson(String source) => UserProjectResponse.fromMap(json.decode(source));
}