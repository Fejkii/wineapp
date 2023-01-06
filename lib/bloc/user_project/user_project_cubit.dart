import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/api/api_result_handler.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/repository/user_project_repository.dart';

part 'user_project_state.dart';

class UserProjectCubit extends Cubit<UserProjectState> {
  UserProjectCubit() : super(UserProjectInitial());

  void getUserProjectList() async {
    emit(UserProjectLoadingState());
    ApiResults apiResults = await UserProjectRepository().getProjectList();
    if (apiResults is ApiSuccess) {
      List<UserProjectModel> userProjectList = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        userProjectList.add(UserProjectModel.fromMap(element));
      });
      emit(UserProjectListSuccessState(userProjectList));
    } else if (apiResults is ApiFailure) {
      emit(UserProjectFailureState(apiResults.message));
    }
  }

  void getUsersForProjectList(int projectId) async {
    emit(UserProjectLoadingState());
    ApiResults apiResults = await UserProjectRepository().getUsersForProject(projectId);
    if (apiResults is ApiSuccess) {
      List<UserProjectModel> users = [];
      (jsonDecode(json.encode(apiResults.data))).forEach((element) {
        users.add(UserProjectModel.fromMap(element));
      });
      emit(UsersForProjectListSuccessState(users));
    } else if (apiResults is ApiFailure) {
      emit(UserProjectFailureState(apiResults.message));
    }
  }

  void shareProjectToUser(String email, int projectId) async {
    emit(UserProjectLoadingState());
    ApiResults apiResults = await UserProjectRepository().shareProjectToUser(email, projectId);
    if (apiResults is ApiSuccess) {
      emit(ShareProjectSuccessState());
    } else if (apiResults is ApiFailure) {
      emit(UserProjectFailureState(apiResults.message));
    }
  }
}
