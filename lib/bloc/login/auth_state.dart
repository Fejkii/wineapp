part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final bool isUserLoggedIn;

  const LoginSuccessState(this.isUserLoggedIn);
}

class LoginFailureState extends AuthState {
  final String errorMessage;

  const LoginFailureState(this.errorMessage);
}

class LogoutLoadingState extends AuthState {}

class LogoutSuccesState extends AuthState {
  final bool isUserLoggedIn;

  const LogoutSuccesState(this.isUserLoggedIn);
}

class LogoutFailureState extends AuthState {
  final String errorMessage;

  const LogoutFailureState(this.errorMessage);
}
