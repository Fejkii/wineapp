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

  AppPreferences appPreferences = instance<AppPreferences>();

  void getWineList() async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineList(appPreferences.getProject()!.id);
    if (apiResults is ApiSuccess) {
      List<WineModel> wineList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineList.add(WineModel.fromMap(element));
      });
      List<Map<String, dynamic>> wineBaseList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineBaseList.add(WineBaseModel.fromWineData(element).toMap());
      });
      appPreferences.setWines(wineBaseList);
      emit(WineListSuccessState(wineList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineBaseList() async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineList(appPreferences.getProject()!.id);
    if (apiResults is ApiSuccess) {
      List<Map<String, dynamic>> wineBaseList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineBaseList.add(WineBaseModel.fromWineData(element).toMap());
      });
      appPreferences.setWines(wineBaseList);
      emit(WineBaseListSuccessState(wineBaseList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void createWine(String title, int wineVarietyId) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().createWine(appPreferences.getProject()!.id, wineVarietyId, title);
    if (apiResults is ApiSuccess) {
      emit(WineSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void updateWine(int wineId, int wineVarietyId, String title) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().updateWine(wineId, wineVarietyId, title);
    if (apiResults is ApiSuccess) {
      emit(WineSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineVarietyList(int projectId) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineVarietyList(projectId);
    if (apiResults is ApiSuccess) {
      List<WineVarietyModel> wineVarietyList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineVarietyList.add(WineVarietyModel.fromMap(element));
      });
      appPreferences.setWineVarieties(apiResults.data);
      emit(WineVarietyListSuccessState(wineVarietyList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void createWineVariety(String title, String code) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().createWineVariety(appPreferences.getProject()!.id, title, code);
    if (apiResults is ApiSuccess) {
      emit(WineVarietySuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void updateWineVariety(int wineVarietyId, String title, String code) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().updateWineVariety(wineVarietyId, title, code);
    if (apiResults is ApiSuccess) {
      emit(WineVarietySuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineClassificationList() async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineClassificationList();
    if (apiResults is ApiSuccess) {
      List<WineClassificationModel> wineClassificationList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineClassificationList.add(WineClassificationModel.fromMap(element));
      });
      await appPreferences.setWineClassifications(apiResults.data);
      emit(WineClassificationListSuccessState(wineClassificationList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineRecordTypeList() async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineRecordTypeList();
    if (apiResults is ApiSuccess) {
      appPreferences.setWineRecordTypes(apiResults.data);
      emit(WineRecordTypeListSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void createWineEvidence(
      int wineId, int? classificationId, String title, double volume, int year, double? alcohol, double? acid, double? sugar, String? note) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository()
        .createWineEvidence(appPreferences.getProject()!.id, wineId, classificationId, title, volume, year, alcohol, acid, sugar, note);
    if (apiResults is ApiSuccess) {
      emit(WineEvidenceSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void updateWineEvidence(int wineEvidenceId, int wineId, int? classificationId, String title, double volume, int year, double? alcohol, double? acid,
      double? sugar, String? note) async {
    emit(WineLoadingState());
    ApiResults apiResults =
        await WineRepository().updateWineEvidence(wineEvidenceId, wineId, classificationId, title, volume, year, alcohol, acid, sugar, note);
    if (apiResults is ApiSuccess) {
      emit(WineEvidenceSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineEvidenceList() async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineEvidenceList(appPreferences.getProject()!.id);
    if (apiResults is ApiSuccess) {
      List<WineEvidenceModel> wineEvidenceList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineEvidenceList.add(WineEvidenceModel.fromMap(element));
      });
      emit(WineEvidenceListSuccessState(wineEvidenceList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineRecordList(int wineEvidenceId) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineRecordList(wineEvidenceId);
    if (apiResults is ApiSuccess) {
      List<WineRecordModel> wineRecordList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        wineRecordList.add(WineRecordModel.fromMap(element));
      });
      emit(WineRecordListSuccessState(wineRecordList));
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void getWineEvidence(int wineEvidenceId) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().getWineEvidence(wineEvidenceId);
    if (apiResults is ApiSuccess) {
      emit(WineEvidenceSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void updateWineRecord(int wineRecordId, int wineRecordTypeId, String title, DateTime date, String? note) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().updateWineRecord(
      wineRecordId,
      wineRecordTypeId,
      title,
      date.toIso8601String(),
      note,
    );
    if (apiResults is ApiSuccess) {
      emit(WineRecordSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }

  void createWineRecord(int wineEvidenceId, int wineRecordTypeId, String title, DateTime date, String? note) async {
    emit(WineLoadingState());
    ApiResults apiResults = await WineRepository().createWineRecord(
      wineEvidenceId,
      wineRecordTypeId,
      title,
      date.toIso8601String(),
      note,
    );
    if (apiResults is ApiSuccess) {
      emit(WineRecordSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(WineFailureState(apiResults.message));
    }
  }
}
