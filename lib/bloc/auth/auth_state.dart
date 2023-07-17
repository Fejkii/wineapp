// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoginState extends AuthState {
  String userName;
  String email;
  LoginState({
    required this.userName,
    required this.email,
  });
}
