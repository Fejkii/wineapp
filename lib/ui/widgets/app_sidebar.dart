import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/api_endpoints.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
                          text: AppLocalizations.of(context)!.appName,
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    AppContentTitleText(text: appPreferences.getProject() != null ? appPreferences.getProject()!.title : AppConstant.EMPTY),
                    const Spacer(),
                    Text(appPreferences.getUser() != null ? appPreferences.getUser()!.name : AppConstant.EMPTY),
                    Text(appPreferences.getUser() != null ? appPreferences.getUser()!.email : AppConstant.EMPTY),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppLocalizations.of(context)!.profile),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.userRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.supervised_user_circle),
                title: Text(AppLocalizations.of(context)!.project),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.projectRoute);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.nature),
                title: Text(AppLocalizations.of(context)!.wines),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineRoute);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dataset_outlined),
                title: Text(AppLocalizations.of(context)!.wineVarieties),
                onTap: () {
                  Navigator.popAndPushNamed(context, AppRoutes.wineVarietyListRoute);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.settings),
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
                      title: Text(AppLocalizations.of(context)!.logout),
                      onTap: () {
                        authCubit.logout();
                      },
                    );
                  }
                },
              ),
              const Divider(),
              _appVersionInfo(context),
            ],
          ),
        );
      },
    );
  }

  Widget _appVersionInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: AppPadding.p20, top: AppPadding.p20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppLocalizations.of(context)!.appVersion}: 0.0.1',
            style: const TextStyle(fontSize: 12),
          ),
          Text(
            '${AppLocalizations.of(context)!.apiVersion}: ${ApiEndpoints.API_VERSION}',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
