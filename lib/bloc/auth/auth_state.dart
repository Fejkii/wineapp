// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LoggedInState extends AuthState {
  final String userName;

  const LoggedInState({
    required this.userName,
  });

  @override
  List<Object> get props => [];
}

class LoggedOutState extends AuthState {
  final String userName;

  const LoggedOutState({
    required this.userName,
  });

  @override
  List<Object> get props => [];
}
