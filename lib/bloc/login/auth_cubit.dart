import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/model/reponse/authenticate_reponse.dart';
import 'package:wine_app/repository/authentication_repository.dart';
import '../../model/base/device_info_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AppPreferences appPreferences;
  AuthCubit(this.appPreferences) : super(AuthInitial());

  late bool isUserLoggedIn = appPreferences.isUserLoggedIn();

  void login(
    String email,
    String password,
  ) async {
    emit(LoginLoadingState());
    DeviceInfoModel deviceInfoModel = await getDeviceDetails();
    ApiResults apiResults = await LoginRepository().loginUser(email, password, deviceInfoModel.name);

    if (apiResults is ApiSuccess) {
      LoginResponse auth = LoginResponse.fromMap(apiResults.data);

      appPreferences.setIsUserLoggedIn(auth.rememberToken, auth.user, auth.project);
      emit(const LoginSuccessState(true));
    } else if (apiResults is ApiFailure) {
      emit(LoginFailureState(apiResults.message));
    }
  }

  void logout() async {
    emit(LogoutLoadingState());
    appPreferences.logout();
    emit(const LogoutSuccesState(false));

    // TODO: Repire API to delete tokens
    // ApiResults apiResults = await LoginRepository().logoutUser();
    // if (apiResults is ApiSuccess) {
    //   appPreferences.logout();
    //   emit(const LogoutSuccesState(false));
    // } else if (apiResults is ApiFailure) {
    //   emit(LogoutFailureState(apiResults.message));
    // }
  }
}
