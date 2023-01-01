import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_app/model/project_model.dart';
import 'package:wine_app/model/user_model.dart';
import 'package:wine_app/services/language_service.dart';

enum AppPreferencesKeys {
  theme,
  language,
  userToken,
  user,
  project,
}

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<String> getAppLanguage() async {
    String? language = _sharedPreferences.getString(AppPreferencesKeys.language.name);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageTypeEnum.english.getValue();
    }
  }

  Future<void> setAppTheme(bool isLightTheme) async {
    _sharedPreferences.setBool(AppPreferencesKeys.theme.name, isLightTheme);
  }

  bool getAppTheme() {
    bool? isLightTheme = _sharedPreferences.getBool(AppPreferencesKeys.theme.name);
    if (isLightTheme != null) {
      return isLightTheme;
    }
    return true;
  }

  Future<void> setIsUserLoggedIn(String userToken, UserModel user, ProjectModel? project) async {
    _sharedPreferences.setString(AppPreferencesKeys.userToken.name, userToken);
    _sharedPreferences.setString(AppPreferencesKeys.user.name, user.toJson());
    if (project != null) {
      setProject(project);
    }
  }

  Future<void> logout() async {
    _sharedPreferences.remove(AppPreferencesKeys.userToken.name);
    _sharedPreferences.remove(AppPreferencesKeys.user.name);
    _sharedPreferences.remove(AppPreferencesKeys.project.name);
  }

  bool? isUserLoggedIn() {
    if (_sharedPreferences.getString(AppPreferencesKeys.userToken.name) != null) {
      return true;
    }
    return null;
  }

  String? getUserToken() {
    return _sharedPreferences.getString(AppPreferencesKeys.userToken.name);
  }

  UserModel? getUser() {
    if (_sharedPreferences.getString(AppPreferencesKeys.user.name) != null) {
      return UserModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.user.name)!);
    }
    return null;
  }

  Future<void> setProject(ProjectModel project) async {
    _sharedPreferences.setString(AppPreferencesKeys.project.name, project.toJson());
  }

  bool? hasProject() {
    if (_sharedPreferences.getString(AppPreferencesKeys.project.name) != null) {
      return true;
    }
    return null;
  }

  ProjectModel? getProject() {
    if (_sharedPreferences.getString(AppPreferencesKeys.project.name) != null) {
      return ProjectModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.project.name)!);
    }
    return null;
  }
}
