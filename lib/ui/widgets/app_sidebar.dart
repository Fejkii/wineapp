import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/api_endpoints.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';

class AppSidebar extends StatelessWidget {
  AppSidebar({Key? key}) : super(key: key);
  final AuthCubit authCubit = instance<AuthCubit>();
  final AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.wine_bar, color: Theme.of(context).primaryIconTheme.color),
                        const SizedBox(width: 10),
                        AppTitleText(
                          text: AppStrings.appName,
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppContentTitleText(text: appPreferences.getProject() != null ? appPreferences.getProject()!.title : ""),
                    const Spacer(),
                    Text(appPreferences.getUser() != null ? appPreferences.getUser()!.name : ""),
                    Text(appPreferences.getUser() != null ? appPreferences.getUser()!.email : ""),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.supervised_user_circle),
                title: const Text(AppStrings.project),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.projectRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.nature),
                title: const Text(AppStrings.wines),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
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
                      leading: const Icon(Icons.logout),
                      title: const Text(AppStrings.logout),
                      onTap: () {
                        authCubit.logout();
                      },
                    );
                  }
                },
              ),
              const Divider(),
              _appVersionInfo(),
            ],
          ),
        );
      },
    );
  }

  Widget _appVersionInfo() {
    return Container(
      padding: const EdgeInsets.only(left: AppPadding.p20, top: AppPadding.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '${AppStrings.appVersion}: 0.0.1',
            style: TextStyle(fontSize: 12),
          ),
          Text(
            '${AppStrings.apiVersion}: ${ApiEndpoints.API_VERSION}',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
