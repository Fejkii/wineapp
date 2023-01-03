import 'dart:convert';

import 'package:wine_app/model/base/user_model.dart';

class MainProjectModel {
  ProjectModel project;
  UserProjectModel userProject;

  MainProjectModel(
    this.project,
    this.userProject,
  );
}

class UserProjectListModel {
  List<UserProjectModel?> userProjects;

  UserProjectListModel(this.userProjects);
}

class ProjectDetailModel {
  ProjectModel project;

  ProjectDetailModel(this.project);
}

class ProjectModel {
  int id;
  String title;

  ProjectModel(
    this.id,
    this.title,
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      map['id']?.toInt() ?? 0,
      map['title'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) => ProjectModel.fromMap(json.decode(source));
}

class UserProjectModel {
  int id;
  UserModel user;
  ProjectModel project;
  bool isDefault;
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
}
