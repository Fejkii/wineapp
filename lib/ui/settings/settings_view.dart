import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final ThemeCubit themeCubit = instance<ThemeCubit>();
  final AuthCubit authCubit = instance<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _getContentWidget(),
          appBar: AppBar(
            title: const Text(AppStrings.settings),
          ),
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
      ],
    );
  }
}
