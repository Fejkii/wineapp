import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/repository/wine_repository.dart';

part 'wine_state.dart';

class WineCubit extends Cubit<WineState> {
  WineCubit() : super(WineInitial());

  void getWineVarietyList(int projectId) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineVarietyList(projectId);
    if (apiResults is ApiSuccess) {
      List<WineVarietyModel> wineVarietyList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineVarietyList.add(WineVarietyModel.fromMap(element));
      });
      emit(WineVarietyListSuccessState(wineVarietyList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void createWineVariety(String title, String code) async {
    ApiResults apiResults = await WineRepository().createWineVariety(instance<AppPreferences>().getProject()!.id, title, code);
    if (apiResults is ApiSuccess) {
      emit(WineVarietySuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void updateWineVariety(int wineVarietyId, String title, String code) async {
    ApiResults apiResults = await WineRepository().updateWineVariety(wineVarietyId, title, code);
    if (apiResults is ApiSuccess) {
      emit(WineVarietySuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }
}
