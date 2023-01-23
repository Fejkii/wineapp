import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/project/share_project_widget.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class UserProjectDetailView extends StatefulWidget {
  final UserProjectModel userProject;
  const UserProjectDetailView({
    Key? key,
    required this.userProject,
  }) : super(key: key);

  @override
  State<UserProjectDetailView> createState() => _UserProjectDetailViewState();
}

class _UserProjectDetailViewState extends State<UserProjectDetailView> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final UserProjectCubit userProjectCubit = instance<UserProjectCubit>();
  late UserProjectModel userProject;

  @override
  void initState() {
    userProject = widget.userProject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProjectCubit, UserProjectState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _body(),
          appBar: AppBar(
            title: Text(userProject.project.title),
          ),
        );
      },
    );
  }

  Widget _body() {
    return Column(
      children: [
        const ShareProjectWidget(),
        const SizedBox(height: AppPadding.p20),
        _setDefaultProject(),
      ],
    );
  }

  Widget _setDefaultProject() {
    return BlocListener<UserProjectCubit, UserProjectState>(
      listener: (context, state) {
        if (state is UserProjectLoadingState) {
          const AppLoadingIndicator();
        } else if (state is UserProjectFailureState) {
          AppToastMessage().showToastMsg(
            state.errorMessage,
            ToastStates.error,
          );
        } else if (state is UpdateUserProjectSuccessState) {
          AppToastMessage().showToastMsg(
            AppStrings.updated,
            ToastStates.success,
          );
        }
      },
      child: userProject.isDefault
          ? const AppTitleText(text: AppStrings.projectIsDefault)
          : Column(
              children: [
                const SizedBox(height: AppPadding.p20),
                const AppContentTitleText(text: AppStrings.setProjectDefaultContent),
                AppButton(
                  title: AppStrings.setProjectDefault,
                  onTap: () {
                    userProjectCubit.setDefaultUserProject(userProject);
                  },
                ),
              ],
            ),
    );
  }
}
