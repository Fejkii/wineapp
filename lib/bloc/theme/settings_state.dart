part of 'settings_cubit.dart';

abstract class SettingsState extends Equatable {
  final bool isLightTheme;
  final String appLanguage;
  const SettingsState(
    this.isLightTheme,
    this.appLanguage,
  );

  @override
  List<Object> get props => [isLightTheme, appLanguage];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial(super.isLightTheme, super.appLanguage);
}

class ChangeAppSettingsState extends SettingsState {
  const ChangeAppSettingsState(super.isLightTheme, super.appLanguage);
}
