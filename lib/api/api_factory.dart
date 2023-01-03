import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wine_app/api/api_error_handler.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/model/reponse/base_response.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "contet-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class ApiFactory {
  final AppPreferences _appPreferences;
  late Dio dio;

  ApiFactory(this._appPreferences) {
    int timeOut = 10 * 1000; // 5 second
    // TODO: langugages in requests
    // String language = _appPreferences.getAppLanguage();
    String token = _appPreferences.getUserToken() ?? "";

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token",
      // DEFAULT_LANGUAGE: language,
    };

    BaseOptions baseOptions = BaseOptions(
      baseUrl: getBaseApiUrl(),
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      headers: headers,
    );

    dio = Dio(baseOptions);

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
      ));
    }
  }

  Future<ApiResults> getData(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await dio.get(endpoint, queryParameters: queryParameters);

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.requestOptions);
        // print(e.message);
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> postData(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> putData(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> deleteData(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }
}
