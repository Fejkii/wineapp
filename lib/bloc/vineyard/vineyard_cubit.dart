import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'vineyard_state.dart';

class VineyardCubit extends Cubit<VineyardState> {
  VineyardCubit() : super(VineyardInitial());
}
