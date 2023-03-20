import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/app_bloc_observer.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/bloc/project_settings/project_settings_cubit.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/bloc/user/user_cubit.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/services/navigator_service.dart';
import 'package:wine_app/services/route_service.dart';
import 'package:wine_app/ui/theme/app_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initAppDependences();
  await instance<AppPreferences>().initSP();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeCubit themeCubit;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (context) => instance<ThemeCubit>()),
        BlocProvider<AuthCubit>(create: (context) => instance<AuthCubit>()),
        BlocProvider<UserCubit>(create: (context) => instance<UserCubit>()),
        BlocProvider<ProjectCubit>(create: (context) => instance<ProjectCubit>()),
        BlocProvider<ProjectSettingsCubit>(create: (context) => instance<ProjectSettingsCubit>()),
        BlocProvider<UserProjectCubit>(create: (context) => instance<UserProjectCubit>()),
        BlocProvider<WineCubit>(create: (context) => instance<WineCubit>()),
        BlocProvider<VineyardCubit>(create: (context) => instance<VineyardCubit>()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Sizer(builder: (context, orientation, deviceType) {
            themeCubit = instance<ThemeCubit>();
            themeCubit.getAppTheme;
            return MaterialApp(
              theme: themeCubit.getAppTheme() ? AppThemes.lightTheme : AppThemes.darkTheme,
              onGenerateRoute: RouteGenerator.onGenerateRoute,
              initialRoute: AppRoutes.splashRoute,
              debugShowCheckedModeBanner: false,
              navigatorKey: instance<NavigationService>().navigatorKey,
            );
          });
        },
      ),
    );
  }
}
