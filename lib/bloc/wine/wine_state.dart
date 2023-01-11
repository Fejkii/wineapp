part of 'wine_cubit.dart';

abstract class WineState extends Equatable {
  const WineState();

  @override
  List<Object> get props => [];
}

class WineInitial extends WineState {}

class WineLoadingState extends WineState {}

class WineFailureState extends WineState {
  final String errorMessage;
  const WineFailureState(this.errorMessage);
}

class WineListSuccessState extends WineState {
  final List<WineModel> wineList;
  const WineListSuccessState(this.wineList);
}

class WineSuccessState extends WineState {}

class WineVarietySuccessState extends WineState {}

class WineVarietyListSuccessState extends WineState {
  final List<WineVarietyModel> wineVarietyList;
  const WineVarietyListSuccessState(this.wineVarietyList);
}

class WineEvidenceSuccessState extends WineState {}

class WineEvidenceListSuccessState extends WineState {
  final List<WineEvidenceModel> wineEvidenceList;
  const WineEvidenceListSuccessState(this.wineEvidenceList);
}

class WineClassificationListSuccessState extends WineState {
  final List<WineClassificationModel> wineClassificationList;
  const WineClassificationListSuccessState(this.wineClassificationList);
}

class WineRecordTypeListSuccessState extends WineState {
  final List<WineRecordTypeModel> wineRecordTypeList;
  const WineRecordTypeListSuccessState(this.wineRecordTypeList);
}
