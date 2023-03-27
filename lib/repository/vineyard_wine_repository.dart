import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/api_endpoints.dart';

class VineyardWineRepository {
  Future<ApiResults> getVineyardWineList(int vineyardId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.vineyardWineUrl,
      endpointFilter: ApiEndpoints.vineyardUrl,
      identificator: vineyardId,
    );
  }

  Future<ApiResults> createVineyardWine(
    int vineyardId,
    int wineId,
    String title,
    int quantity,
    String? note,
  ) async {
    return instance<ApiFactory>().postMethod(
      endpoint: ApiEndpoints.vineyardWineUrl,
      data: {
        'vineyard_id': vineyardId,
        'wine_id': wineId,
        'title': title,
        'quantity': quantity,
        'note': note,
      },
    );
  }

  Future<ApiResults> updateVineyardWine(
    int vineyardWineId,
    int wineId,
    String title,
    int quantity,
    String? note,
  ) async {
    return instance<ApiFactory>().putMethod(
      endpoint: ApiEndpoints.vineyardWineUrl,
      identificator: vineyardWineId,
      data: {
        'wine_id': wineId,
        'title': title,
        'quantity': quantity,
        'note': note,
      },
    );
  }

  Future<ApiResults> getVineyardWine(int vineyardWineId) async {
    return instance<ApiFactory>().getMethod(
      endpoint: ApiEndpoints.vineyardWineUrl,
      identificator: vineyardWineId,
    );
  }
}
