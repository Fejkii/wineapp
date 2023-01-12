import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/theme/app_fonts.dart';
import 'package:wine_app/ui/theme/app_text_styles.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
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
  final TextEditingController _emailController = TextEditingController();
  UserProjectCubit userProjectCubit = instance<UserProjectCubit>();
  final _formKey = GlobalKey<FormState>();
  late List<UserProjectModel> userList;

  @override
  void initState() {
    userList = [];
    userProjectCubit.getUsersForProjectList(widget.userProject.id);
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.userProject.project.title),
            ),
            body: _getContentWidget(),
          ),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.userProject.project.title),
              const Divider(height: 30),
              _addUserToProject(context),
              // const SizedBox(height: 40),
              const Divider(height: 30),
              _usersInProject()
            ],
          ),
        ),
      ),
    );
  }

  Widget _addUserToProject(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const AppContentTitleText(text: AppStrings.shareProject),
          const SizedBox(height: 20),
          AppTextFormField(
            controller: _emailController,
            label: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<UserProjectCubit, UserProjectState>(
            listener: (context, state) {
              if (state is ShareProjectSuccessState) {
                setState(() {
                  _emailController.text = "";
                  userProjectCubit.getUsersForProjectList(widget.userProject.project.id);
                });
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
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      userProjectCubit.shareProjectToUser(_emailController.text, widget.userProject.project.id);
                    }
                  },
                  child: Text(
                    AppStrings.shareProjectButton,
                    style: Theme.of(context).textTheme.button,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _usersInProject() {
    return BlocConsumer<UserProjectCubit, UserProjectState>(
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
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            userList[index].user.name,
            style: getBoldStyle(color: AppColors.white, fontSize: AppFontSize.s14),
          ),
          Text(
            userList[index].user.email,
          ),
        ],
      ),
    );
  }
}
