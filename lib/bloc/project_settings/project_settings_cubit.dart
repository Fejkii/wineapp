import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/model/base/project_settings_model.dart';
import 'package:wine_app/repository/project_settings_repository.dart';

part 'project_settings_state.dart';

class ProjectSettingsCubit extends Cubit<ProjectSettingsState> {
  ProjectSettingsCubit() : super(ProjectSettingsInitial());

  AppPreferences appPreferences = instance<AppPreferences>();

  void getProjectSettings(int projectId) async {
    emit(ProjectSettingsLoadingState());
    ApiResults apiResults = await ProjectSettingsRepository().getProjectSettings(projectId);
    if (apiResults is ApiSuccess) {
      ProjectSettingsModel projectSettings = ProjectSettingsModel.fromMap(apiResults.data);
      await appPreferences.setProjectSettings(projectSettings);
      emit(ProjectSettingsSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(ProjectSettingsFailureState(apiResults.message));
    }
  }

  void updateProjectSettings(int projectsettingsId, double defaultFreeSulfur, double defaultLiquidSulfur) async {
    emit(ProjectSettingsLoadingState());
    ApiResults apiResults = await ProjectSettingsRepository().updateProjectSettings(projectsettingsId, defaultFreeSulfur, defaultLiquidSulfur);
    if (apiResults is ApiSuccess) {
      await appPreferences.setProjectSettings(ProjectSettingsModel(
          id: projectsettingsId,
          projectId: appPreferences.getProject()!.id,
          defaultFreeSulfur: defaultFreeSulfur,
          defaultLiquidSulfur: defaultLiquidSulfur));
      emit(ProjectSettingsSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(ProjectSettingsFailureState(apiResults.message));
    }
  }
}
