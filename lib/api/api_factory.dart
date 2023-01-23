import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:wine_app/api/api_error_handler.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/model/reponse/base_response.dart';
import 'package:wine_app/services/navigator_service.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "contet-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class ApiFactory {
  final AppPreferences _appPreferences;

  ApiFactory(this._appPreferences);

  Dio getDio() {
    int timeOut = 10 * 1000; // 5 second
    String language = _appPreferences.getAppLanguage();
    String token = _appPreferences.getUserToken() ?? "";
    Dio dio;

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: "Bearer $token",
      DEFAULT_LANGUAGE: language,
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

    return dio;
  }

  Future<ApiResults> getMethod({
    required String endpoint,
    String? endpointFilter,
    int? identificator,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      String path = endpoint;
      if (endpointFilter != null) {
        path = "$path/$endpointFilter";
      }
      if (identificator != null) {
        path = "$path/$identificator";
      }
      var response = await getDio().get(
        path,
        queryParameters: queryParameters,
      );

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);

        if (e.response!.statusCode == ResponseCode.UNATUHORIZED) {
          instance<NavigationService>().navigateTo(AppRoutes.loginRoute);
          // TODO lock dio for no more reqeusts.
        }

        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // print(e.requestOptions);
        // print(e.message);
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> postMethod({
    required String endpoint,
    String? endpointFilter,
    int? identificator,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      String path = endpoint;
      if (endpointFilter != null) {
        path = "$path/$endpointFilter";
      }
      if (identificator != null) {
        path = "$path/$identificator";
      }
      var response = await getDio().post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        if (e.response!.statusCode == ResponseCode.UNATUHORIZED) {
          instance<NavigationService>().navigateTo(AppRoutes.loginRoute);
        }
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> putMethod({
    required String endpoint,
    int? identificator,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      String path = endpoint;
      if (identificator != null) {
        path = "$endpoint/$identificator";
      }
      var response = await getDio().put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == ResponseCode.UNATUHORIZED) {
          instance<NavigationService>().navigateTo(AppRoutes.loginRoute);
        }
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }

  Future<ApiResults> deleteMethod({
    required String endpoint,
    int? identificator,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      String path = endpoint;
      if (identificator != null) {
        path = "$endpoint/$identificator";
      }
      var response = await getDio().delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      BaseResponse baseResponse = BaseResponse.fromMap(response.data);

      return ApiSuccess(baseResponse.data, response.statusCode);
    } on DioError catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == ResponseCode.UNATUHORIZED) {
          instance<NavigationService>().navigateTo(AppRoutes.loginRoute);
        }
        BaseErrorResponse baseErrorResponse = BaseErrorResponse.fromMap(e.response!.data);
        return ApiFailure(baseErrorResponse.code, baseErrorResponse.message);
      } else {
        return ApiErrorHandler.handle(e).failure;
      }
    }
  }
}
