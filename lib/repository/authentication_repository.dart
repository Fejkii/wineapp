import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class LoginRepository {
  Future<ApiResults> loginUser(
    String email,
    String password,
    String deviceName,
  ) async {
    return await instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.loginUrl,
      data: {
        "email": email,
        "password": password,
        "device_name": deviceName,
      },
    );
  }

  Future<ApiResults> logoutUser() async {
    return await instance<ApiFactory>().getMethod(endpoint: ApiEndpoints.logoutUrl);
  }

  Future<ApiResults> registerUser(
    String name,
    String email,
    String password,
    String deviceName,
  ) async {
    return await instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.registerUrl,
      data: {
        "name": name,
        "email": email,
        "password": password,
        "device_name": deviceName,
      },
    );
  }
}
