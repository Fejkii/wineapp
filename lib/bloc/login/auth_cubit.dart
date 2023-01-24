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

  void login(
    String email,
    String password,
  ) async {
    emit(AuthLoadingState());
    DeviceInfoModel deviceInfoModel = await getDeviceDetails();
    ApiResults apiResults = await LoginRepository().loginUser(email, password, deviceInfoModel.name);
    if (apiResults is ApiSuccess) {
      LoginResponse auth = LoginResponse.fromMap(apiResults.data);
      await appPreferences.setIsUserLoggedIn(auth.rememberToken, auth.user, auth.userProject);
      emit(LoginSuccessState(true, auth.userProject != null && auth.userProject!.project != null ? true : false));
    } else if (apiResults is ApiFailure) {
      emit(LoginFailureState(apiResults.message));
    }
  }

  void logout() async {
    emit(AuthLoadingState());
    ApiResults apiResults = await LoginRepository().logoutUser();
    if (apiResults is ApiSuccess) {
      appPreferences.logout();
      emit(LogoutSuccesState());
    } else if (apiResults is ApiFailure) {
      appPreferences.logout();
      emit(LogoutFailureState(apiResults.message));
    }
  }

  void register(
    String name,
    String email,
    String password,
  ) async {
    emit(AuthLoadingState());
    DeviceInfoModel deviceInfoModel = await getDeviceDetails();
    ApiResults apiResults = await LoginRepository().registerUser(name, email, password, deviceInfoModel.name);
    if (apiResults is ApiSuccess) {
      LoginResponse auth = LoginResponse.fromMap(apiResults.data);
      await appPreferences.setIsUserLoggedIn(auth.rememberToken, auth.user, auth.userProject);
      emit(LoginSuccessState(true, auth.userProject != null && auth.userProject!.project != null ? true : false));
    } else if (apiResults is ApiFailure) {
      emit(LoginFailureState(apiResults.message));
    }
  }
}
