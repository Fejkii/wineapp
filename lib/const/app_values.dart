import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppMargin {
  static const double m5 = 5.0;
  static const double m10 = 10.0;
  static const double m15 = 15.0;
  static const double m20 = 20.0;
  static const double m40 = 40.0;
}

class AppPadding {
  static const double p5 = 5.0;
  static const double p10 = 10.0;
  static const double p15 = 15.0;
  static const double p20 = 20.0;
  static const double p100 = 100.0;
}

class AppSize {
  static const double s0 = 0;
  static const double s0_5 = 0.5;
  static const double s1_5 = 1.5;
  static const double s4 = 4.0;
  static const double s5 = 5.0;
  static const double s10 = 10.0;
  static const double s15 = 15.0;
  static const double s20 = 20.0;
  static const double s40 = 40.0;
  static const double s60 = 60.0;
  static const double s100 = 100.0;
  static const double s180 = 180.0;
}

class AppRadius {
  static const double r5 = 5.0;
  static const double r15 = 15.0;
}

class AppDuration {
  static const int d300 = 300;
}

class AppConstant {
  static const String EMPTY = "";
  static const int ZERO = 0;
  static const DateTime? NULL_DATE = null;
}

enum ToastStates {
  success,
  error,
  warning,
}

class AppUnits {
  static const String miliLiter = "ml";
  static const String percent = "%";
  static const String squareMeter = "m\u00B2";
  static const String gramPerOneLiter = "g/1l";

  String liter(TextEditingController controller, BuildContext context) {
    return controller.text != ""
        ? AppLocalizations.of(context)!.unitLiter(double.parse(controller.text))
        : AppLocalizations.of(context)!.unitLiter(0);
  }
}
