import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class ProjectSettingsRepository {
  Future<ApiResults> updateProjectSettings(
    int projectSettingsId,
    double defaultFreeSulfur,
    double defaultLiquidSulfur,
  ) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.projectSettingsUrl,
      identificator: projectSettingsId,
      data: {
        'default_free_sulfur': defaultFreeSulfur,
        'default_liquid_sulfur': defaultLiquidSulfur,
      },
    );
  }

  Future<ApiResults> getProjectSettings(
    int projectId,
  ) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.projectSettingsUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
  }
}
