import 'package:flutter/material.dart';
import 'package:wine_app/ui/theme/app_fonts.dart';

TextStyle _getTextStyle(double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

// regular text style
TextStyle getRegularStyle({double fontSize = AppFontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, AppFonts.fontFamily, AppFontWeight.regular, color);
}

// light text style
TextStyle getLightStyle({double fontSize = AppFontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, AppFonts.fontFamily, AppFontWeight.light, color);
}

// bold text style
TextStyle getBoldStyle({double fontSize = AppFontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, AppFonts.fontFamily, AppFontWeight.bold, color);
}

// semiBold text style
TextStyle getSemiBoldStyle({double fontSize = AppFontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, AppFonts.fontFamily, AppFontWeight.semiBold, color);
}

// medium text style
TextStyle getMediumtyle({double fontSize = AppFontSize.s12, required Color color}) {
  return _getTextStyle(fontSize, AppFonts.fontFamily, AppFontWeight.medium, color);
}
