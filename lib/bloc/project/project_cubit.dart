import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/model/reponse/user_project_response.dart';
import 'package:wine_app/repository/project_repositry.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  AppPreferences appPreferences;
  ProjectCubit(this.appPreferences) : super(ProjectInitial());

  void createProject(
    String title,
    bool isDefault,
  ) async {
    emit(CreateProjectLoadingState());
    ApiResults apiResults = await ProjectRepository().createProject(title, isDefault);

    if (apiResults is ApiSuccess) {
      UserProjectResponse userProject = UserProjectResponse.fromMap(apiResults.data);

      if (userProject.isDefault) {
        appPreferences.setProject(userProject.project);
      }
      emit(CreateProjectSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(CreateProjectFailureState(apiResults.message));
    }
  }
}
