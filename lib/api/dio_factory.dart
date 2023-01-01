import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "contet-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();

    int timeOut = 5 * 1000; // 5 second
    String language = await _appPreferences.getAppLanguage();
    String token = _appPreferences.getUserToken() ?? "";

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token",
      DEFAULT_LANGUAGE: language,
    };

    dio.options = BaseOptions(
      baseUrl: getBaseApiUrl(),
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      headers: headers,
    );

    if (kReleaseMode) {
      // ignore: avoid_print
      print("release mode no logs");
    } else {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ));
    }

    return dio;
  }
}
