import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wine_app/app/app_preferences.dart';

part 'authenticate_state.dart';

class AuthenticateCubit extends Cubit<AuthenticateState> {
  AppPreferences appPreferences;
  AuthenticateCubit(this.appPreferences) : super(AuthenticateInitial(appPreferences.isUserLoggedIn()));

  late bool isUserLoggedIn = appPreferences.isUserLoggedIn();
}
