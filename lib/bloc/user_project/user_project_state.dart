part of 'user_project_cubit.dart';

abstract class UserProjectState extends Equatable {
  const UserProjectState();

  @override
  List<Object> get props => [];
}

class UserProjectInitial extends UserProjectState {}

class UserProjectLoadingState extends UserProjectState {}

class UserProjectListSuccessState extends UserProjectState {
  final List<UserProjectModel> userProjectList;
  const UserProjectListSuccessState(this.userProjectList);
}

class UserProjectFailureState extends UserProjectState {
  final String errorMessage;
  const UserProjectFailureState(this.errorMessage);
}

class UsersForProjectListSuccessState extends UserProjectState {
  final List<UserProjectModel> userList;
  const UsersForProjectListSuccessState(this.userList);
}

class ShareProjectSuccessState extends UserProjectState {}
