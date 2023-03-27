part of 'vineyard_cubit.dart';

abstract class VineyardState extends Equatable {
  const VineyardState();

  @override
  List<Object> get props => [];
}

class VineyardInitial extends VineyardState {}

class VineyardLoadingState extends VineyardState {}

class VineyardSuccessState extends VineyardState {}

class VineyardListSuccessState extends VineyardState {
  final List<VineyardModel> vineyardList;
  const VineyardListSuccessState(this.vineyardList);
}

class VineyardFailureState extends VineyardState {
  final String errorMessage;
  const VineyardFailureState(this.errorMessage);
}

class VineyardRecordSuccessState extends VineyardState {}

class VineyardRecordListSuccessState extends VineyardState {
  final List<VineyardRecordModel> vineyardRecordList;
  const VineyardRecordListSuccessState(this.vineyardRecordList);
}

class VineyardRecordTypeListSuccessState extends VineyardState {}
