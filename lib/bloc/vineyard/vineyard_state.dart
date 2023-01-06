part of 'vineyard_cubit.dart';

abstract class VineyardState extends Equatable {
  const VineyardState();

  @override
  List<Object> get props => [];
}

class VineyardInitial extends VineyardState {}

class VineyardLoadingState extends VineyardState {}

class VineyardSuccessState extends VineyardState {}

class VineyardFailureState extends VineyardState {
  final String errorMessage;
  const VineyardFailureState(this.errorMessage);
}
