import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/reponse/base_response.dart';
import 'package:wine_app/repository/vineyard_wine_repository.dart';

part 'vineyard_wine_state.dart';

class VineyardWineCubit extends Cubit<VineyardWineState> {
  VineyardWineCubit() : super(VineyardWineInitial());

  AppPreferences appPreferences = instance<AppPreferences>();

  void getVineyardWineList(int vineyardId) async {
    emit(VineyardWineLoadingState());
    ApiResults apiResults = await VineyardWineRepository().getVineyardWineList(vineyardId);
    if (apiResults is ApiSuccess) {
      SummaryResponse response;
      List<VineyardWineModel> vineyardWineList = [];
      response = SummaryResponse.fromMap(apiResults.data);
      (jsonDecode(json.encode(response.data))).forEach((element) {
        vineyardWineList.add(VineyardWineModel.fromMap(element));
      });
      emit(VineyardWineListSuccessState(vineyardWineList));
    } else if (apiResults is ApiFailure) {
      emit(VineyardWineFailureState(apiResults.message));
    }
  }

  void getVineyardWineSummary(int vineyardId) async {
    emit(VineyardWineLoadingState());
    ApiResults apiResults = await VineyardWineRepository().getVineyardWineList(vineyardId);
    if (apiResults is ApiSuccess) {
      emit(VineyardWineSummarySuccessState(SummaryResponse.fromMap(apiResults.data)));
    } else if (apiResults is ApiFailure) {
      emit(VineyardWineFailureState(apiResults.message));
    }
  }

  void createVineyardWine(int vineyardId, int wineId, String title, int quantity, String? note) async {
    emit(VineyardWineLoadingState());
    ApiResults apiResults = await VineyardWineRepository().createVineyardWine(vineyardId, wineId, title, quantity, note);
    if (apiResults is ApiSuccess) {
      emit(VineyardWineSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardWineFailureState(apiResults.message));
    }
  }

  void updateVineyardWine(int vineyardWineId, int wineId, String title, int quantity, String? note) async {
    emit(VineyardWineLoadingState());
    ApiResults apiResults = await VineyardWineRepository().updateVineyardWine(vineyardWineId, wineId, title, quantity, note);
    if (apiResults is ApiSuccess) {
      emit(VineyardWineSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardWineFailureState(apiResults.message));
    }
  }

  void getVineyardWine(int vineyardWineId) async {
    emit(VineyardWineLoadingState());
    ApiResults apiResults = await VineyardWineRepository().getVineyardWine(vineyardWineId);
    if (apiResults is ApiSuccess) {
      emit(VineyardWineSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardWineFailureState(apiResults.message));
    }
  }
}
