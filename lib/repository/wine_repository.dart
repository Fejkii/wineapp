import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class WineRepository {
  Future<ApiResults> createWine(int projectId, int wineVariety, String title) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.wineUrl,
      data: {
        "project_id": projectId,
        "wine_variety_id": wineVariety,
        "title": title,
      },
    );
  }

  Future<ApiResults> getWine(int wineId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.wineUrl}/$wineId");
  }

  Future<ApiResults> updateWine(int wineId, int wineVariety, String title) async {
    return instance<ApiFactory>().putData(
      "${ApiEndpoints.wineUrl}/$wineId",
      data: {
        "wine_variety_id": wineVariety,
        "title": title,
      },
    );
  }

  Future<ApiResults> getWineVarietyList(int projectId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.wineVarietyListUrl}/$projectId");
  }

  Future<ApiResults> createWineVariety(int projectId, String title, String code) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.wineVarietyUrl,
      data: {
        "project_id": projectId,
        "title": title,
        "code": code,
      },
    );
  }

  Future<ApiResults> updateWineVariety(int wineVarietyId, String title, String code) async {
    return instance<ApiFactory>().putData(
      "${ApiEndpoints.wineVarietyUrl}/$wineVarietyId",
      data: {
        "title": title,
        "code": code,
      },
    );
  }
}
