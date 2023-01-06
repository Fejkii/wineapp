part of 'wine_cubit.dart';

abstract class WineState extends Equatable {
  const WineState();

  @override
  List<Object> get props => [];
}

class WineInitial extends WineState {}

class WineLoadingState extends WineState {}

class WineSuccessState extends WineState {}

class WineVarietySuccessState extends WineState {}

class WineVarietyListSuccessState extends WineState {
  final List<WineVarietyModel> wineVarietyList;
  const WineVarietyListSuccessState(this.wineVarietyList);
}

class WineFailureState extends WineState {
  final String errorMessage;
  const WineFailureState(this.errorMessage);
}
