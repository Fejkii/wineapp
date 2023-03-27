part of 'vineyard_wine_cubit.dart';

abstract class VineyardWineState extends Equatable {
  const VineyardWineState();

  @override
  List<Object> get props => [];
}

class VineyardWineInitial extends VineyardWineState {}

class VineyardWineLoadingState extends VineyardWineState {}

class VineyardWineSuccessState extends VineyardWineState {}

class VineyardWineListSuccessState extends VineyardWineState {
  final List<VineyardWineModel> vineyardWineList;
  const VineyardWineListSuccessState(this.vineyardWineList);
}

class VineyardWineSummarySuccessState extends VineyardWineState {
  final SummaryResponse vineyardWineSummary;
  const VineyardWineSummarySuccessState(this.vineyardWineSummary);
}

class VineyardWineFailureState extends VineyardWineState {
  final String errorMessage;
  const VineyardWineFailureState(this.errorMessage);
}

class VineyardWineRecordSuccessState extends VineyardWineState {}

class VineyardWineRecordListSuccessState extends VineyardWineState {
  final List<VineyardWineModel> vineyardWineRecordList;
  const VineyardWineRecordListSuccessState(this.vineyardWineRecordList);
}

class VineyardRecordTypeListSuccessState extends VineyardWineState {}