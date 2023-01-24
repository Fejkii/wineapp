import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class UserRepository {
  Future<ApiResults> updateUser(
    int userId,
    String name,
    String email,
  ) async {
    return await instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.userUrl,
      identificator: userId,
      data: {
        "name": name,
        "email": email,
      },
    );
  }
}
