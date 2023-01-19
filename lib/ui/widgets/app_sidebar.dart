import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';

class AppSidebar extends StatelessWidget {
  AppSidebar({Key? key}) : super(key: key);
  final AuthCubit authCubit = instance<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: [
                    const Text(AppStrings.appName, style: TextStyle(fontSize: 25)),
                    const SizedBox(height: 20),
                    Text(instance<AppPreferences>().getProject() != null ? instance<AppPreferences>().getProject()!.title : ""),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
                title: const Text(AppStrings.project),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.projectRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
                title: const Text(AppStrings.wines),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.key_sharp),
                title: const Text(AppStrings.wineVarieties),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineVarietyListRoute);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(AppStrings.settings),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.settingsRoute);
                },
              ),
              const Divider(),
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
