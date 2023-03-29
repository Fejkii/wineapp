import 'package:flutter/material.dart';

class AppColors {
  static Color primary = HexColor.fromHex("#5FB332");
  static Color darkPrimary = Colors.green[900]!;
  static Color lightBackground = white;
  static const Color darkBackground = Color(0xFF313943);
  static Color primaryOpacity = primary.withOpacity(0.7);
  static Color darkPrimaryOpacity = lighten(darkPrimary);
  static Color red = Colors.red;
  static Color lightRed = Colors.red[300]!;

  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static Color lightGrey = Colors.grey[300]!;
  static Color darkGrey = Colors.grey[700]!;

  static Color blue = Colors.blue;
  static Color lightBlue = Colors.blue[200]!;
  static Color blueAcctent = Colors.blueAccent;
  static Color green = Colors.green;
  static Color lightGreen = Colors.lightGreen;

  static Color error = Colors.redAccent;
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; // opacity 100%
    }

    return Color(int.parse(hexColorString, radix: 16));
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}