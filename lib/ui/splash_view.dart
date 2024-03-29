import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/project_settings/project_settings_cubit.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/ui/theme/app_colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  late AppPreferences appPreferences = instance<AppPreferences>();
  late WineCubit wineCubit = instance<WineCubit>();
  late ProjectSettingsCubit projectSettingsCubit = instance<ProjectSettingsCubit>();
  late VineyardCubit vineyardCubit = instance<VineyardCubit>();

  @override
  void initState() {
    super.initState();
    if (appPreferences.hasUserProject()) {
      int projectId = appPreferences.getProject()!.id;
      projectSettingsCubit.getProjectSettings(projectId);
      wineCubit.getWineVarietyList(projectId);
      wineCubit.getWineClassificationList();
      wineCubit.getWineList();
    }
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  _startDelay() {
    _timer = Timer(const Duration(milliseconds: 500), _goNext);
  }

  _goNext() {
    if (appPreferences.isUserLoggedIn()) {
      if (appPreferences.hasUserProject()) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProjectRoute, (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppLocalizations.of(context)!.appName,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Icon(Icons.wine_bar, color: AppColors.darkPrimary, size: 120),
          ),
        ),
      ),
    );
  }
}
