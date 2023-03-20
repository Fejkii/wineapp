part of 'project_settings_cubit.dart';

abstract class ProjectSettingsState extends Equatable {
  const ProjectSettingsState();

  @override
  List<Object> get props => [];
}

class ProjectSettingsInitial extends ProjectSettingsState {}

class ProjectSettingsLoadingState extends ProjectSettingsState {}

class ProjectSettingsSuccessState extends ProjectSettingsState {}

class ProjectSettingsFailureState extends ProjectSettingsState {
  final String errorMessage;
  const ProjectSettingsFailureState(this.errorMessage);
}