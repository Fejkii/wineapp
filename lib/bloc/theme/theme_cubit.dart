import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  AppPreferences appPreferences;
  ThemeCubit(this.appPreferences) : super(const ThemeInitial());

  static ThemeCubit get(context) => BlocProvider.of<ThemeCubit>(context);

  bool isLightTheme = true;

  void changeAppTheme() async {
    isLightTheme = !isLightTheme;
    appPreferences.setAppTheme(isLightTheme);
    emit(ChangeAppThemeState(isLightTheme));
  }

  void getAppTheme() {
    appPreferences.getAppTheme();
  }
}
