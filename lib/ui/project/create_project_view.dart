import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
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
  bool _isDefaultValue = false;
  late ProjectCubit projectCubit = instance<ProjectCubit>();
  late bool hasUserProject;
  final AuthCubit authCubit = instance<AuthCubit>();

  @override
  void initState() {
    hasUserProject = instance<AppPreferences>().hasUserProject();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: (() {
                    authCubit.logout();
                    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
                  }),
                  icon: const Icon(Icons.exit_to_app),
                ),
              ],
            ),
            body: _getContentWidget(),
          ),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppTitleText(
              text: hasUserProject ? AppStrings.nextProject : AppStrings.noProject,
            ),
            const SizedBox(height: 80),
            _form(context),
          ],
        ),
      ),
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
            title: const Text(AppStrings.isProjectDefault),
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
                  _titleController.text = "";
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
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      projectCubit.createProject(_titleController.text, _isDefaultValue);
                    }
                  },
                  child: Text(
                    AppStrings.createProject,
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
}
