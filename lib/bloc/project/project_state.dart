part of 'project_cubit.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class CreateProjectLoadingState extends ProjectState {}

class CreateProjectSuccessState extends ProjectState {}

class CreateProjectFailureState extends ProjectState {
  final String errorMessage;
  const CreateProjectFailureState(this.errorMessage);
}
