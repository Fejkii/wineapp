import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class ProjectRepository {
  Future<ApiResults> createProject(
    String title,
    bool isDefault,
  ) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.projectUrl,
      data: {
        "title": title,
        "is_default": isDefault,
      },
    );
  }
}
