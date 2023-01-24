part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UpdateUserSuccessState extends UserState {
  final UserModel user;
  const UpdateUserSuccessState(this.user);
}

class UserFailureState extends UserState {
  final String errorMessage;
  const UserFailureState(this.errorMessage);
}
