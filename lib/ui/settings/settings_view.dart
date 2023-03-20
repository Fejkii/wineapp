// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/project_settings/project_settings_cubit.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_settings_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_my_bar.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ThemeCubit themeCubit = instance<ThemeCubit>();
  final AuthCubit authCubit = instance<AuthCubit>();
  final ProjectSettingsCubit projectSettingsCubit = instance<ProjectSettingsCubit>();
  final TextEditingController _defaultFreeSulfurController = TextEditingController();
  final TextEditingController _defaultLiquidSulfurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ProjectSettingsModel projectSettings;

  @override
  void initState() {
    projectSettings = instance<AppPreferences>().getProjectSettings()!;
    _defaultFreeSulfurController.text = projectSettings.defaultFreeSulfur.toString();
    _defaultLiquidSulfurController.text = projectSettings.defaultLiquidSulfur.toString();
    super.initState();
  }

  @override
  void dispose() {
    _defaultFreeSulfurController.clear();
    _defaultLiquidSulfurController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _getContentWidget(),
          appBar: myAppBar(title: AppStrings.settings, actions: [
            BlocConsumer<ProjectSettingsCubit, ProjectSettingsState>(
              listener: (context, state) {
                if (state is ProjectSettingsSuccessState) {
                  AppToastMessage().showToastMsg(AppStrings.updatedSuccessfully, ToastStates.success);
                } else if (state is ProjectSettingsFailureState) {
                  AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                }
              },
              builder: (context, state) {
                if (state is ProjectSettingsLoadingState) {
                  return const AppLoadingIndicator();
                } else {
                  return AppIconButton(
                    iconButtonType: IconButtonType.save,
                    onPress: (() {
                      if (_formKey.currentState!.validate()) {
                        projectSettingsCubit.updateProjectSettings(
                          projectSettings.id,
                          double.parse(_defaultFreeSulfurController.text),
                          double.parse(_defaultLiquidSulfurController.text),
                        );
                      }
                    }),
                  );
                }
              },
            ),
          ]),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(AppStrings.changeTheme),
            Switch(
              value: !themeCubit.isLightTheme,
              onChanged: (value) {
                themeCubit.changeAppTheme();
              },
            ),
          ],
        ),
        const Divider(height: 40),
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LogoutSuccesState) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
            } else if (state is LogoutFailureState) {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppButton(
                title: AppStrings.logout,
                buttonType: ButtonType.logout,
                onTap: () {
                  authCubit.logout();
                },
              );
            }
          },
        ),
        _projectsettings(context),
      ],
    );
  }

  Widget _projectsettings(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Divider(height: 40),
          const AppTitleText(text: AppStrings.projectSettings),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _defaultFreeSulfurController,
            label: AppStrings.defaultFreeSulfur,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _defaultLiquidSulfurController,
            label: AppStrings.defaultLiquidSulfur,
            keyboardType: TextInputType.number,
            isRequired: true,
          ),
        ],
      ),
    );
  }
}
