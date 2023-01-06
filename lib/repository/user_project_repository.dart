import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class UserProjectRepository {
  Future<ApiResults> getProjectList() async {
    return instance<ApiFactory>().getData(ApiEndpoints.userProjectListUrl);
  }

  Future<ApiResults> getUsersForProject(int projectId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.projectUserListUrl}/$projectId");
  }

  Future<ApiResults> shareProjectToUser(String email, int projectId) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.userProjectUrl,
      data: {
        "email": email,
        "project_id": projectId,
      },
    );
  }
}
