import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/model/base/user_model.dart';
import 'package:wine_app/services/language_service.dart';

enum AppPreferencesKeys {
  theme,
  language,
  userToken,
  user,
  project,
}

class AppPreferences {
  late SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<SharedPreferences> initSP() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  String getAppLanguage() {
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

  bool isUserLoggedIn() {
    return _sharedPreferences.getString(AppPreferencesKeys.userToken.name) != null &&
            _sharedPreferences.getString(AppPreferencesKeys.userToken.name)!.isNotEmpty
        ? true
        : false;
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

  bool hasUserProject() {
    return _sharedPreferences.getString(AppPreferencesKeys.project.name) != null ? true : false;
  }

  ProjectModel? getProject() {
    if (_sharedPreferences.getString(AppPreferencesKeys.project.name) != null) {
      return ProjectModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.project.name)!);
    }
    return null;
  }
}
