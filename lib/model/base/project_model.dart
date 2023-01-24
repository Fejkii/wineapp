// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  ProjectModel? project;
  bool isDefault;
  bool isOwner;
  DateTime createdAt;
  DateTime updatedAt;

  UserProjectModel(
    this.id,
    this.user,
    this.project,
    this.isDefault,
    this.isOwner,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': user.toMap(),
      'project': project != null ? project!.toMap() : null,
      'is_default': isDefault,
      'is_owner': isOwner,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserProjectModel.fromMap(Map<String, dynamic> map) {
    return UserProjectModel(
      map['id']?.toInt() ?? 0,
      UserModel.fromMap(map['user']),
      map['project'] != null ? ProjectModel.fromMap(map['project']) : null,
      map['is_default'],
      map['is_owner'],
      DateTime.parse(map['created_at']),
      DateTime.parse(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProjectModel.fromJson(String source) => UserProjectModel.fromMap(json.decode(source));
}
