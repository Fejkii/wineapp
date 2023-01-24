import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/model/base/user_model.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/services/language_service.dart';

enum AppPreferencesKeys {
  theme,
  language,
  userToken,
  user,
  project,
  isUserOwnerOfProject,
  wines,
  wineVarieties,
  wineClassifications,
  wineRecordTypes,
  vineyardRecordTypes,
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
    await _sharedPreferences.setBool(AppPreferencesKeys.theme.name, isLightTheme);
  }

  bool getAppTheme() {
    bool? isLightTheme = _sharedPreferences.getBool(AppPreferencesKeys.theme.name);
    if (isLightTheme != null) {
      return isLightTheme;
    }
    return true;
  }

  Future<void> setIsUserLoggedIn(String userToken, UserModel user, UserProjectModel? userProject) async {
    await _sharedPreferences.setString(AppPreferencesKeys.userToken.name, userToken);
    await _sharedPreferences.setString(AppPreferencesKeys.user.name, user.toJson());
    if (userProject != null) {
      await setIsOwner(userProject.isOwner);

      if (userProject.project != null) {
        setProject(userProject.project!);
      }
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
    await _sharedPreferences.setString(AppPreferencesKeys.project.name, project.toJson());
  }

  Future<void> setIsOwner(bool isOwner) async {
    await _sharedPreferences.setBool(AppPreferencesKeys.isUserOwnerOfProject.name, isOwner);
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

  bool isUserOwnerOfProject() {
    return _sharedPreferences.getBool(AppPreferencesKeys.isUserOwnerOfProject.name) != null ? _sharedPreferences.getBool(AppPreferencesKeys.isUserOwnerOfProject.name)! : false;
  }

  Future<void> setWineVarieties(List wineVarietyList) async {
    var wineVarieties = jsonEncode(wineVarietyList);
    await _sharedPreferences.setString(AppPreferencesKeys.wineVarieties.name, wineVarieties);
  }

  List<WineVarietyModel>? getWineVarietyList() {
    List<WineVarietyModel> wineVarietyList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.wineVarieties.name)!)).forEach((element) {
      wineVarietyList.add(WineVarietyModel.fromMap(element));
    });
    return wineVarietyList;
  }

  Future<void> setWineClassifications(List wineClassificationList) async {
    var wineClassifications = jsonEncode(wineClassificationList);
    await _sharedPreferences.setString(AppPreferencesKeys.wineClassifications.name, wineClassifications);
  }

  List<WineClassificationModel>? getWineClassificationList() {
    List<WineClassificationModel> wineClassificationList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.wineClassifications.name)!)).forEach((element) {
      wineClassificationList.add(WineClassificationModel.fromMap(element));
    });
    return wineClassificationList;
  }

  Future<void> setWines(List wineList) async {
    var wines = jsonEncode(wineList);
    await _sharedPreferences.setString(AppPreferencesKeys.wines.name, wines);
  }

  List<WineBaseModel>? getWineList() {
    List<WineBaseModel> wineList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.wines.name)!)).forEach((element) {
      wineList.add(WineBaseModel.fromMap(element));
    });
    return wineList;
  }

  Future<void> setWineRecordTypes(List wineRecordTypeList) async {
    var wineRecordTypes = jsonEncode(wineRecordTypeList);
    await _sharedPreferences.setString(AppPreferencesKeys.wineRecordTypes.name, wineRecordTypes);
  }

  List<WineRecordTypeModel>? getWineRecordTypeList() {
    List<WineRecordTypeModel> wineRecordTypeList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.wineRecordTypes.name)!)).forEach((element) {
      wineRecordTypeList.add(WineRecordTypeModel.fromMap(element));
    });
    return wineRecordTypeList;
  }

  Future<void> setVineyardRecordTypes(List vineyardRecordTypeList) async {
    var vineyardRecordTypes = jsonEncode(vineyardRecordTypeList);
    await _sharedPreferences.setString(AppPreferencesKeys.vineyardRecordTypes.name, vineyardRecordTypes);
  }

  List<VineyardRecordTypeModel>? getVineyardRecordTypeList() {
    List<VineyardRecordTypeModel> vineyardRecordTypeList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.vineyardRecordTypes.name)!)).forEach((element) {
      vineyardRecordTypeList.add(VineyardRecordTypeModel.fromMap(element));
    });
    return vineyardRecordTypeList;
  }
}
