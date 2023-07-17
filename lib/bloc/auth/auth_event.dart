part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleLogin extends AuthEvent {
  const GoogleLogin();

  @override
  List<Object> get props => [];
}
