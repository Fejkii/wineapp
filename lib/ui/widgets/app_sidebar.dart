import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class AppSidebar extends StatelessWidget {
  AppSidebar({Key? key}) : super(key: key);
  final AuthCubit authCubit = instance<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            // padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Text(
                  AppStrings.appName,
                  style: TextStyle(fontSize: 25),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.verified_user),
                title: const Text(AppStrings.profile),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(AppStrings.settings),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.settingsRoute);
                },
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
                    return ListTile(
                      leading: const Icon(Icons.exit_to_app),
                      title: const Text(AppStrings.logout),
                      onTap: () {
                        authCubit.logout();
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
