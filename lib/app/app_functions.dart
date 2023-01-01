import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:wine_app/const/api_routes.dart';
import 'package:wine_app/model/device_info_model.dart';

Future<DeviceInfoModel> getDeviceDetails() async {
  String name = "Unknown";
  String identifier = "Unknown";
  String version = "Unknown";

  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;

      name = "${build.brand} ${build.model}";
      identifier = build.androidId;
      version = build.version.codename;
    } else if (Platform.isIOS) {
      var build = await deviceInfoPlugin.iosInfo;

      name = "${build.name} ${build.model}";
      identifier = build.identifierForVendor;
      version = build.systemVersion;
    }
  } on PlatformException {
    return DeviceInfoModel(name, identifier, version);
  }
  return DeviceInfoModel(name, identifier, version);
}

String getBaseApiUrl() {
  if (kReleaseMode) {
    return ApiRoute.BASE_URL;
  }

  try {
    if (Platform.isAndroid) {
      return ApiRoute.TEST_ANDROID_BASE_URL; // On localhost must be on Android device this URL
    } 
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }

  return ApiRoute.TEST_BASE_URL;
}

bool isEmailValid(String email) {
  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
}

bool isPasswordValid(String password) {
  return RegExp(r"^.{6,}$").hasMatch(password);
}

bool isTitleValid(String title) {
  return RegExp("").hasMatch(title);
}
