import 'dart:convert';

import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/model/base/user_model.dart';

class LoginResponse {
  String rememberToken;
  UserModel user;
  UserProjectModel? userProject;
  LoginResponse({
    required this.rememberToken,
    required this.user,
    this.userProject,
  });

  Map<String, dynamic> toMap() {
    return {
      'remember_token': rememberToken,
      'user': user.toMap(),
      'user_project': userProject != null ? userProject!.toMap() : null,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      rememberToken: map['remember_token'] ?? '',
      user: UserModel.fromMap(map['user']),
      userProject: map['user_project'] != null ? UserProjectModel.fromMap(map['user_project']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) => LoginResponse.fromMap(json.decode(source));
}
