import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  late AppPreferences appPreferences = instance<AppPreferences>();
  late WineCubit wineCubit = instance<WineCubit>();

  @override
  void initState() {
    super.initState();
    if (appPreferences.hasUserProject()) {
      wineCubit.getWineVarietyList(appPreferences.getProject()!.id);
      wineCubit.getWineClassificationList();
      wineCubit.getWineRecordTypeList();
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
    return const MaterialApp(
      title: AppStrings.appName,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: FlutterLogo(size: 128),
          ),
        ),
      ),
    );
  }
}
