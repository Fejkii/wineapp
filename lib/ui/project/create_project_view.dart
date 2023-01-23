import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/project/user_project_detail_view.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class CreateProjectView extends StatefulWidget {
  const CreateProjectView({Key? key}) : super(key: key);

  @override
  State<CreateProjectView> createState() => _CreateProjectViewState();
}

class _CreateProjectViewState extends State<CreateProjectView> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ProjectCubit projectCubit = instance<ProjectCubit>();
  final AuthCubit authCubit = instance<AuthCubit>();
  final UserProjectCubit userProjectCubit = instance<UserProjectCubit>();
  late bool _isDefaultValue = false;
  late bool hasUserProject;
  late List<UserProjectModel> userProjectList;

  @override
  void initState() {
    userProjectList = [];
    hasUserProject = instance<AppPreferences>().hasUserProject();
    userProjectCubit.getUserProjectList();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProjectCubit, ProjectState>(listener: (context, state) {}),
        BlocListener<UserProjectCubit, UserProjectState>(listener: (context, state) {}),
      ],
      child: AppScaffoldLayout(
        body: _bodyWidget(),
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: (() {
                authCubit.logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
              }),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        AppTitleText(text: hasUserProject ? AppStrings.nextProject : AppStrings.noProject),
        const SizedBox(height: 20),
        _form(context),
        _getSharedProjects()
      ],
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextFormField(
            controller: _titleController,
            label: AppStrings.projectName,
            isRequired: true,
            inputType: InputType.title,
            icon: Icons.tag,
          ),
          const SizedBox(height: AppMargin.m20),
          CheckboxListTile(
            title: const Text(AppStrings.setProjectDefault),
            subtitle: const Text(AppStrings.isProjectDefaultSubtitle),
            value: _isDefaultValue,
            onChanged: (newValue) {
              setState(() {
                _isDefaultValue = newValue!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<ProjectCubit, ProjectState>(
            listener: (context, state) {
              if (state is CreateProjectSuccessState) {
                setState(() {
                  _titleController.text = AppConstant.EMPTY;
                  _isDefaultValue = false;
                });
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
              } else if (state is CreateProjectFailureState) {
                AppToastMessage().showToastMsg(
                  state.errorMessage,
                  ToastStates.error,
                );
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
              }
            },
            builder: (context, state) {
              if (state is CreateProjectLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppStrings.createProject,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      projectCubit.createProject(_titleController.text, _isDefaultValue);
                    }
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _getSharedProjects() {
    return userProjectList.isNotEmpty
        ? Column(
            children: [
              const SizedBox(height: AppPadding.p20),
              const AppTitleText(text: AppStrings.sharedProject),
              const AppContentText(text: AppStrings.selectProject),
              SafeArea(
                child: BlocConsumer<UserProjectCubit, UserProjectState>(
                  listener: (context, state) {
                    if (state is UserProjectListSuccessState) {
                      userProjectList = state.userProjectList;
                    } else if (state is UserProjectFailureState) {
                      AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is UserProjectLoadingState) {
                      return const AppLoadingIndicator();
                    } else {
                      return AppListView(listData: userProjectList, itemBuilder: _itemBuilder);
                    }
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (userProjectList[index].isDefault) const Icon(Icons.star, size: AppSize.s20),
          if (userProjectList[index].isDefault) const SizedBox(width: AppPadding.p10),
          Text(userProjectList[index].project.title),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProjectDetailView(userProject: userProjectList[index]),
          ),
        );
      },
    );
  }
}
