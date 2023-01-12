import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'vineyard_state.dart';

class VineyardCubit extends Cubit<VineyardState> {
  VineyardCubit() : super(VineyardInitial());
}
