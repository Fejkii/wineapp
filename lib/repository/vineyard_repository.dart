import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class VineyardRepository {
  Future<ApiResults> getVineyardList(int projectId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.vineyardUrl,
      endpointFilter: ApiEndpoints.projectUrl,
      identificator: projectId,
    );
  }

  Future<ApiResults> createVineyard(
    int projectId,
    String title,
    double? area,
  ) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.vineyardUrl,
      data: {
        'project_id': projectId,
        'title': title,
        'area': area,
      },
    );
  }

  Future<ApiResults> updateVineyard(
    int vineyardId,
    String title,
    double? area,
  ) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.vineyardUrl,
      identificator: vineyardId,
      data: {
        'title': title,
        'area': area,
      },
    );
  }

  Future<ApiResults> getVineyard(int vineyardId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.vineyardUrl,
      identificator: vineyardId,
    );
  }

  Future<ApiResults> updateVineyardRecord(
    int vineyardRecordId,
    int vineyardRecordTypeId,
    String title,
    String date,
    String? note,
  ) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.vineyardRecordUrl,
      identificator: vineyardRecordId,
      data: {
        "vineyard_record_type_id": vineyardRecordTypeId,
        "title": title,
        "date": date,
        "note": note,
      },
    );
  }

  Future<ApiResults> createVineyardRecord(
    int vineyardId,
    int vineyardRecordTypeId,
    String title,
    String date,
    String? note,
  ) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.vineyardRecordUrl,
      data: {
        "vineyard_id": vineyardId,
        "vineyard_record_type_id": vineyardRecordTypeId,
        "title": title,
        "date": date,
        "note": note,
      },
    );
  }

  Future<ApiResults> getVineyardRecordList(int vineyardId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.vineyardRecordUrl,
      endpointFilter: ApiEndpoints.vineyardUrl,
      identificator: vineyardId,
    );
  }

  Future<ApiResults> getVineyardRecordTypeList() async {
    return instance<ApiFactory>().getMethod(endpoint: ApiEndpoints.vineyardRecordTypeUrl);
  }
}
