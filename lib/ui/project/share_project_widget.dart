import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_modal_dialog.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class ShareProjectWidget extends StatefulWidget {
  const ShareProjectWidget({super.key});

  @override
  State<ShareProjectWidget> createState() => _ShareProjectWidgetState();
}

class _ShareProjectWidgetState extends State<ShareProjectWidget> {
  final TextEditingController _emailController = TextEditingController();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final UserProjectCubit userProjectCubit = instance<UserProjectCubit>();
  final _formKey = GlobalKey<FormState>();
  late List<UserProjectModel> userList;
  late ProjectModel project;

  @override
  void initState() {
    project = appPreferences.getProject()!;
    userProjectCubit.getUsersForProjectList(project.id);
    userList = [];
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProjectCubit, UserProjectState>(
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                addUserToProject(context),
                const Divider(height: 40),
                _usersInProject(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget addUserToProject(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppContentTitleText(text: AppLocalizations.of(context)!.shareProject),
          const SizedBox(height: 20),
          AppTextFormField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<UserProjectCubit, UserProjectState>(
            listener: (context, state) {
              if (state is ShareProjectSuccessState) {
                setState(() {
                  AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastStates.success);
                  _emailController.text = AppConstant.EMPTY;
                  userProjectCubit.getUsersForProjectList(project.id);
                });
              } else if (state is DeleteUserProjectSuccessState) {
                AppToastMessage().showToastMsg(AppLocalizations.of(context)!.userProjectDeleted, ToastStates.success);
                userProjectCubit.getUsersForProjectList(project.id);
              } else if (state is UserProjectFailureState) {
                AppToastMessage().showToastMsg(
                  state.errorMessage,
                  ToastStates.error,
                );
              }
            },
            builder: (context, state) {
              if (state is CreateProjectLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.shareProjectButton,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      userProjectCubit.shareProjectToUser(_emailController.text, project.id);
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

  Widget _usersInProject() {
    return Column(
      children: [
        AppTitleText(text: AppLocalizations.of(context)!.usersInProject),
        BlocConsumer<UserProjectCubit, UserProjectState>(
          listener: (context, state) {
            if (state is UsersForProjectListSuccessState) {
              userList = state.userList;
            } else if (state is UserProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
            }
          },
          builder: (context, state) {
            if (state is UserProjectLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppListView(listData: userList, itemBuilder: _itemBuilder);
            }
          },
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (userList[index].isOwner) const Icon(Icons.key, size: AppSize.s20),
              if (userList[index].isOwner) const SizedBox(width: AppPadding.p10),
              Text(userList[index].user.name),
            ],
          ),
          Text(
            userList[index].user.email,
          ),
        ],
      ),
      onDelete: (value) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AppModalDialog(
            title: AppLocalizations.of(context)!.deleteUserProject,
            content: AppLocalizations.of(context)!.deleteUserProjectContent,
            onTap: () {
              userProjectCubit.deleteUserFromProject(userList[index].id);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
