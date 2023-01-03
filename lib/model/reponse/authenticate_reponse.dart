import 'dart:convert';

import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/model/base/user_model.dart';

class LoginResponse {
  String rememberToken;
  UserModel user;
  ProjectModel project;
  LoginResponse({
    required this.rememberToken,
    required this.user,
    required this.project,
  });

  Map<String, dynamic> toMap() {
    return {
      'remember_token': rememberToken,
      'user': user.toMap(),
      'project': project.toMap(),
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      rememberToken: map['remember_token'] ?? '',
      user: UserModel.fromMap(map['user']),
      project: ProjectModel.fromMap(map['project']),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) => LoginResponse.fromMap(json.decode(source));
}
