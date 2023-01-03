import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: _getContentWidget(),
          ),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is LogoutSuccesState) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
                } else if (state is LogoutFailureState) {
                  AppToastMessage().showToastMsg(
                    state.errorMessage,
                    ToastStates.error,
                  );
                }
              },
              builder: (context, state) {
                if (state is LoginLoadingState) {
                  return const AppLoadingIndicator();
                } else {
                  return ElevatedButton(
                    onPressed: () {
                      authCubit.logout();
                    },
                    child: Text(
                      AppStrings.logout,
                      style: Theme.of(context).textTheme.button,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
