import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/theme/app_fonts.dart';
import 'package:wine_app/ui/theme/app_text_styles.dart';

ThemeData getAppTheme() {
  return ThemeData(
    // Colors of the app
    primaryColor: AppColors.primary,
    primaryColorLight: AppColors.lightRed,
    primaryColorDark: AppColors.darkPrimary,
    scaffoldBackgroundColor: AppColors.white,
    backgroundColor: AppColors.white,
    disabledColor: AppColors.lightGrey,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.grey), // accent color

    // Ripple color
    splashColor: AppColors.primapryOpacity,

    // Card view theme
    cardTheme: CardTheme(
      color: AppColors.white,
      shadowColor: AppColors.grey,
      elevation: AppSize.s4,
    ),

    // AppBar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: AppColors.white.withOpacity(0.6),
      foregroundColor: AppColors.red,
      elevation: 0,
      // elevation: AppSize.s4,
      // shadowColor: AppColors.primapryOpacity70,
      titleTextStyle: getRegularStyle(
        color: AppColors.primary,
        fontSize: AppFontSize.s16,
      ),
    ),

    // App Navigation Bottom Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey),

    // Button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey,
      buttonColor: AppColors.primary,
      splashColor: AppColors.primapryOpacity,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.red),
    ),

    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: AppColors.white),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s15),
        ),
      ),
    ),

    // Text theme
    textTheme: TextTheme(
      headline1: getSemiBoldStyle(color: AppColors.darkGrey, fontSize: AppFontSize.s16),
      subtitle1: getMediumtyle(color: AppColors.grey, fontSize: AppFontSize.s14),
      subtitle2: getMediumtyle(color: AppColors.primary, fontSize: AppFontSize.s14),
      caption: getRegularStyle(color: AppColors.grey),
      bodyText1: getRegularStyle(color: AppColors.grey),
      button: TextStyle(color: AppColors.white),
    ),

    // Icon theme
    iconTheme: IconThemeData(color: AppColors.grey),
  );
}

class AppThemes {
  //..............light Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.white,
      secondary: AppColors.primapryOpacity,
    ),
    iconTheme: IconThemeData(color: AppColors.primary),

    // Button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey,
      buttonColor: AppColors.primary,
      splashColor: AppColors.primapryOpacity,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.red),
    ),

    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: AppColors.white),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s15),
        ),
      ),
    ),

    scaffoldBackgroundColor: AppColors.white,
    backgroundColor: AppColors.white,
    disabledColor: AppColors.lightGrey,
    appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
        )),
    canvasColor: AppColors.darkPrimary,

    // App Navigation Bottom Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      elevation: 0,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.darkPrimary),
    sliderTheme: const SliderThemeData(
      inactiveTickMarkColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.all(AppColors.darkPrimary),
    ),
    dialogBackgroundColor: AppColors.primary,
    toggleButtonsTheme: const ToggleButtonsThemeData(
        selectedColor: Color(0xFF4a707a), selectedBorderColor: Colors.transparent, borderColor: Colors.transparent, fillColor: Colors.transparent),
  );

  //..............dark Theme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.primapryOpacity,
    ),
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.white),
    iconTheme: IconThemeData(color: AppColors.primapryOpacity),

    // Button theme
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey,
      buttonColor: AppColors.primary,
      splashColor: AppColors.primapryOpacity,
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.red),
    ),

    // Elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: AppColors.white),
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s15),
        ),
      ),
    ),
    scaffoldBackgroundColor: Color(0xFF313943),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xFF313943),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    ),

    canvasColor: AppColors.primary,

    // App Navigation Bottom Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: AppColors.darkPrimary,
      selectedItemColor: AppColors.primary2,
      unselectedItemColor: AppColors.grey,
      elevation: 0,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
    sliderTheme: const SliderThemeData(
      inactiveTickMarkColor: Colors.transparent,
      activeTickMarkColor: Colors.transparent,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(Colors.white),
      fillColor: MaterialStateProperty.all(Color(0xFFeab57c)),
    ),
    dialogBackgroundColor: Color(0xFFeab57c),
    toggleButtonsTheme:
        const ToggleButtonsThemeData(selectedBorderColor: Colors.transparent, borderColor: Colors.transparent, fillColor: Colors.transparent),
  );
}
