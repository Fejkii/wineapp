import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class WineRepository {
  Future<ApiResults> createWine(int projectId, int wineVarietyId, String title) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.wineUrl,
      data: {
        "project_id": projectId,
        "wine_variety_id": wineVarietyId,
        "title": title,
      },
    );
  }

  Future<ApiResults> getWine(int wineId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.wineUrl}/$wineId");
  }

  Future<ApiResults> getWineList(int projectId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.wineListUrl}/$projectId");
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

  Future<ApiResults> createWineEvidence(
    int projectId,
    int wineId,
    int? classificationId,
    String title,
    double volume,
    int year,
    double? alcohol,
    double? acid,
    double? sugar,
    String? note,
  ) async {
    return instance<ApiFactory>().postData(
      ApiEndpoints.wineEvidenceUrl,
      data: {
        'project_id': projectId,
        'wine_id': wineId,
        'wine_classification_id': classificationId,
        'title': title,
        'volume': volume,
        'year': year,
        'alcohol': alcohol,
        'acid': acid,
        'sugar': sugar,
        'note': note,
      },
    );
  }

  Future<ApiResults> updateWineEvidence(
    int wineEvidenceId,
    int wineId,
    int? classificationId,
    String title,
    double volume,
    int year,
    double? alcohol,
    double? acid,
    double? sugar,
    String? note,
  ) async {
    return instance<ApiFactory>().putData(
      "${ApiEndpoints.wineEvidenceUrl}/$wineEvidenceId",
      data: {
        'wine_id': wineId,
        'wine_classification_id': classificationId,
        'title': title,
        'volume': volume,
        'year': year,
        'alcohol': alcohol,
        'acid': acid,
        'sugar': sugar,
        'note': note,
      },
    );
  }

  Future<ApiResults> getWineEvidenceList(int projectId) async {
    return instance<ApiFactory>().getData("${ApiEndpoints.wineEvidenceListUrl}/$projectId");
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

  Future<ApiResults> getWineClassificationList() async {
    return instance<ApiFactory>().getData(ApiEndpoints.wineClassificationUrl);
  }

  Future<ApiResults> getWineRecordTypeList() async {
    return instance<ApiFactory>().getData(ApiEndpoints.wineRecordTypeUrl);
  }
}
