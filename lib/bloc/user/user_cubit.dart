import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/model/base/user_model.dart';
import 'package:wine_app/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AppPreferences appPreferences;
  UserCubit(this.appPreferences) : super(UserInitial());

  void updateUser(String name, String email) async {
    emit(UserLoadingState());
    ApiResults apiResults = await UserRepository().updateUser(
      appPreferences.getUser()!.id,
      name,
      email,
    );

    if (apiResults is ApiSuccess) {
      UserModel user = UserModel.fromMap(apiResults.data);
      await appPreferences.setUser(user);
      emit(UpdateUserSuccessState(user));
    } else if (apiResults is ApiFailure) {
      emit(UserFailureState(apiResults.message));
    }
  }
}
