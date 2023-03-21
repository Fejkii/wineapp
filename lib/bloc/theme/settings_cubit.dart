import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  AppPreferences appPreferences;
  SettingsCubit(this.appPreferences) : super(SettingsInitial(appPreferences.getAppTheme(), appPreferences.getAppLanguage()));

  static SettingsCubit get(context) => BlocProvider.of<SettingsCubit>(context);

  void changeAppTheme() async {
    late bool isLightTheme = appPreferences.getAppTheme();
    isLightTheme = !isLightTheme;
    appPreferences.setAppTheme(isLightTheme);
    emit(ChangeAppSettingsState(isLightTheme, appPreferences.getAppLanguage()));
  }

  void changeAppLanguage(String language) async {
    appPreferences.setAppLanguage(language);
    emit(ChangeAppSettingsState(appPreferences.getAppTheme(), language));
  }

  bool getAppTheme() {
    return appPreferences.getAppTheme();
  }

  Locale getAppLanguage() {
    return Locale(appPreferences.getAppLanguage());
  }
}
