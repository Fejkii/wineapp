import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class WineRepository {
  Future<ApiResults> createWine(int projectId, int wineVarietyId, String title) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.wineUrl,
      data: {
        "project_id": projectId,
        "wine_variety_id": wineVarietyId,
        "title": title,
      },
    );
  }

  Future<ApiResults> getWine(int wineId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineUrl,
      identificator: wineId,
    );
  }

  Future<ApiResults> getWineList(int projectId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
  }

  Future<ApiResults> updateWine(int wineId, int wineVariety, String title) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.wineUrl,
      identificator: wineId,
      data: {
        "wine_variety_id": wineVariety,
        "title": title,
      },
    );
  }

  Future<ApiResults> getWineVarietyList(int projectId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineVarietyUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
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
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.wineEvidenceUrl,
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
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.wineEvidenceUrl,
      identificator: wineEvidenceId,
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
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineEvidenceUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
  }

  Future<ApiResults> createWineVariety(int projectId, String title, String code) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.wineVarietyUrl,
      data: {
        "project_id": projectId,
        "title": title,
        "code": code,
      },
    );
  }

  Future<ApiResults> updateWineVariety(int wineVarietyId, String title, String code) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.wineVarietyUrl,
      identificator: wineVarietyId,
      data: {
        "title": title,
        "code": code,
      },
    );
  }

  Future<ApiResults> getWineClassificationList() async {
    return instance<ApiFactory>().getMethod(endpoint: ApiEndpoints.wineClassificationUrl);
  }

  Future<ApiResults> getWineRecordTypeList() async {
    return instance<ApiFactory>().getMethod(endpoint: ApiEndpoints.wineRecordTypeUrl);
  }

  Future<ApiResults> getWineRecordList(int wineEvidenceId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineRecordUrl,
      endpointFilter: ApiEndpoints.wineEvidenceUrl,
      identificator: wineEvidenceId,
    );
  }

  Future<ApiResults> updateWineRecord(int wineRecordId, int wineRecordTypeId, String date, double? freeSulfure, String? note) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.wineRecordUrl,
      identificator: wineRecordId,
      data: {
        "wine_record_type_id": wineRecordTypeId,
        "date": date,
        "free_sulfure": freeSulfure,
        "note": note,
      },
    );
  }

  Future<ApiResults> getWineEvidence(int wineEvidenceId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.wineEvidenceUrl,
      identificator: wineEvidenceId,
    );
  }

  Future<ApiResults> createWineRecord(int wineEvidenceId, int wineRecordTypeId, String date, double? freeSulfure, String? note) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.wineRecordUrl,
      data: {
        "wine_evidence_id": wineEvidenceId,
        "wine_record_type_id": wineRecordTypeId,
        "date": date,
        "free_sulfure": freeSulfure,
        "note": note,
      },
    );
  }
}
