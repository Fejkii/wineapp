part of 'authenticate_cubit.dart';

abstract class AuthenticateState extends Equatable {
  final bool isUserLogged;
  const AuthenticateState(
    this.isUserLogged,
  );

  @override
  List<Object> get props => [isUserLogged];
}

class AuthenticateInitial extends AuthenticateState {
  const AuthenticateInitial(super.isUserLogged);
}

class LoginState extends AuthenticateState {
  const LoginState(super.isUserLogged);
}

class LogoutState extends AuthenticateState {
  const LogoutState(super.isUserLogged);
}
