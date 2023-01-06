import 'dart:convert';

import 'package:wine_app/model/base/user_model.dart';

class ProjectModel {
  int id;
  String title;
  ProjectModel({
    required this.id,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source));
}

class UserProjectModel {
  int id;
  UserModel user;
  ProjectModel project;
  int isDefault;
  String createdAt;
  String updatedAt;

  UserProjectModel(
    this.id,
    this.user,
    this.project,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'project': project.toMap(),
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProjectModel.fromMap(Map<String, dynamic> map) {
    return UserProjectModel(
      map['id']?.toInt() ?? 0,
      UserModel.fromMap(map['user']),
      ProjectModel.fromMap(map['project']),
      map['is_default'] ?? int,
      map['created_at'] ?? '',
      map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProjectModel.fromJson(String source) => UserProjectModel.fromMap(json.decode(source));
}
