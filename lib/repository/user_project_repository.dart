import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class UserProjectRepository {
  Future<ApiResults> getUserProjectList(int userId) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.userProjectUrl,
      endpointFilter: ApiEndpoints.listUrl,
      data: {
        "user_id": userId,
      },
    );
  }

  Future<ApiResults> getUsersForProject(int projectId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.userProjectUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
  }

  Future<ApiResults> shareProjectToUser(String email, int projectId) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.userProjectUrl,
      data: {
        "email": email,
        "project_id": projectId,
      },
    );
  }

  Future<ApiResults> deleteUserFromProject(int userProjectId) async {
    return instance<ApiFactory>().deleteMethod(
      endpoint: ApiEndpoints.userProjectUrl,
      identificator: userProjectId,
    );
  }

  Future<ApiResults> setDefaultUserProject(int userProjectId) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.userProjectUrl,
      identificator: userProjectId,
      data: {
        "is_default": true,
      },
    );
  }
}
