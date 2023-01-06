part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final bool isUserLoggedIn;
  final bool hasUserProject;

  const LoginSuccessState(
    this.isUserLoggedIn,
    this.hasUserProject,
  );
}

class LoginFailureState extends AuthState {
  final String errorMessage;
  const LoginFailureState(this.errorMessage);
}

class LogoutSuccesState extends AuthState {}

class LogoutFailureState extends AuthState {
  final String errorMessage;
  const LogoutFailureState(this.errorMessage);
}

class RegisterSuccesState extends AuthState {}

class RegisterFailureState extends AuthState {
  final String errorMessage;
  const RegisterFailureState(this.errorMessage);
}
