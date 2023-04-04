import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/base/vineyard_record_model.dart';
import 'package:wine_app/repository/vineyard_repository.dart';

part 'vineyard_state.dart';

class VineyardCubit extends Cubit<VineyardState> {
  VineyardCubit() : super(VineyardInitial());

  AppPreferences appPreferences = instance<AppPreferences>();

  void getVineyardList() async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().getVineyardList(appPreferences.getProject()!.id);
    if (apiResults is ApiSuccess) {
      List<VineyardModel> wineList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineList.add(VineyardModel.fromMap(element));
      });
      emit(VineyardListSuccessState(wineList));
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void createVineyard(String title, double? area) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().createVineyard(appPreferences.getProject()!.id, title, area);
    if (apiResults is ApiSuccess) {
      emit(VineyardSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void updateVineyard(int vineyardId, String title, double? area) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().updateVineyard(vineyardId, title, area);
    if (apiResults is ApiSuccess) {
      emit(VineyardSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void getVineyard(int vineyardId) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().getVineyard(vineyardId);
    if (apiResults is ApiSuccess) {
      emit(VineyardSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void getVineyardRecordList(int vineyardId) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().getVineyardRecordList(vineyardId);
    if (apiResults is ApiSuccess) {
      List<VineyardRecordModel> vineyardRecordList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        vineyardRecordList.add(VineyardRecordModel.fromMap(element));
      });
      emit(VineyardRecordListSuccessState(vineyardRecordList));
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void updateVineyardRecord(
    int vineyardRecordId,
    int vineyardRecordTypeId,
    DateTime date,
    bool? isInProgress,
    DateTime? dateTo,
    String? title,
    String? data,
    String? note,
  ) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().updateVineyardRecord(
      vineyardRecordId,
      vineyardRecordTypeId,
      date.toIso8601String(),
      isInProgress,
      dateTo?.toIso8601String(),
      title,
      data,
      note,
    );
    if (apiResults is ApiSuccess) {
      emit(VineyardRecordSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void createVineyardRecord(
    int vineyardId,
    int vineyardRecordTypeId,
    DateTime date,
    bool? isInProgress,
    DateTime? dateTo,
    String? title,
    String? data,
    String? note,
  ) async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().createVineyardRecord(
      vineyardId,
      vineyardRecordTypeId,
      date.toIso8601String(),
      isInProgress,
      dateTo?.toIso8601String(),
      title,
      data,
      note,
    );
    if (apiResults is ApiSuccess) {
      emit(VineyardRecordSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }

  void getVineyardRecordTypeList() async {
    emit(VineyardLoadingState());
    ApiResults apiResults = await VineyardRepository().getVineyardRecordTypeList();
    if (apiResults is ApiSuccess) {
      await appPreferences.setVineyardRecordTypes(apiResults.data);
      emit(VineyardRecordTypeListSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(VineyardFailureState(apiResults.message));
    }
  }
}
