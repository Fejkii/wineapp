import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';
import 'package:wine_app/model/base/device_info_model.dart';

Future<DeviceInfoModel> getDeviceDetails() async {
  String name = "Unknown";
  String identifier = "Unknown";
  String version = "Unknown";

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;

      name = "${build.brand} - ${build.model}";
      identifier = build.androidId;
      version = build.version.codename;
    } else if (Platform.isIOS) {
      var build = await deviceInfoPlugin.iosInfo;

      name = "${build.name} - ${build.model}";
      identifier = build.identifierForVendor;
      version = build.systemVersion;
    }
  } on PlatformException {
    return DeviceInfoModel(name, identifier, version);
  }
  return DeviceInfoModel(name, identifier, version);
}

String getBaseApiUrl() {
  return ApiEndpoints.BASE_URL;
}

bool isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

bool isPasswordValid(String password) {
  return RegExp(r"^.{6,}$").hasMatch(password);
}

bool isTitleValid(String title) {
  return RegExp(r"^.{2,}$").hasMatch(title);
}

bool isDoubleValid(String value) {
  return RegExp(r"^(-?)(0|([1-9][0-9]*))(\\.[0-9]+)?$").hasMatch(value);
}

String appFormatDateTime(DateTime dateTime, {bool dateOnly = false}) {
  if (dateOnly) {
    return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).format(dateTime);
  }
  return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).add_Hms().format(dateTime);
}

DateTime? appToDateTime(String dateTime) {
  if (dateTime != "") {
    return DateFormat.yMMMd(instance<AppPreferences>().getAppLanguage()).parse(dateTime);
  }
  return null;
}
