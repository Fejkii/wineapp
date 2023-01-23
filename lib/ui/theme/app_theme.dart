import 'package:flutter/material.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';

class AppThemes {
  //..............light Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.primaryOpacity,
    ),
    scaffoldBackgroundColor: AppColors.white,
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.darkPrimary),
    iconTheme: IconThemeData(color: AppColors.primary),
    canvasColor: AppColors.primary,
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey,
      buttonColor: AppColors.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontSize: AppSize.s15),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: AppSize.s15),
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r15),
        ),
      ),
    ),
    cardColor: AppColors.lightGrey,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: AppColors.primary,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.lightGrey,
      elevation: 0,
      selectedIconTheme: const IconThemeData(size: 30),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.darkPrimary),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(AppColors.white),
      fillColor: MaterialStateProperty.all(AppColors.primary),
    ),
  );

  //..............dark Theme
  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkPrimaryOpacity,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textSelectionTheme: TextSelectionThemeData(cursorColor: AppColors.white),
    iconTheme: IconThemeData(color: AppColors.grey),
    canvasColor: AppColors.darkPrimary,
    buttonTheme: ButtonThemeData(
      shape: const StadiumBorder(),
      disabledColor: AppColors.grey,
      buttonColor: AppColors.primary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.white,
        textStyle: const TextStyle(fontSize: AppSize.s15),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: AppSize.s15),
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.darkPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r15),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.white;
        }
        return null;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.grey;
        }
        return null;
      }),
    ),
    cardColor: AppColors.darkGrey,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.darkPrimary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: AppColors.darkPrimary,
      selectedItemColor: AppColors.white,
      unselectedItemColor: AppColors.grey,
      elevation: 0,
      selectedIconTheme: const IconThemeData(size: 30),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColors.darkPrimary),
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(AppColors.white),
      fillColor: MaterialStateProperty.all(AppColors.darkPrimary),
    ),
  );
}
