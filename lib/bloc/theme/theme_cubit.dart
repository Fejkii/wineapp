import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  AppPreferences appPreferences;
  ThemeCubit(this.appPreferences) : super(ThemeInitial(appPreferences.getAppTheme()));

  static ThemeCubit get(context) => BlocProvider.of<ThemeCubit>(context);

  late bool isLightTheme = appPreferences.getAppTheme();

  void changeAppTheme() async {
    isLightTheme = !isLightTheme;
    appPreferences.setAppTheme(isLightTheme);
    emit(ChangeAppThemeState(isLightTheme));
  }

  bool getAppTheme() {
    return appPreferences.getAppTheme();
  }
}
