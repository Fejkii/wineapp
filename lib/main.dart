import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/app_bloc_observer.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/services/route_service.dart';
import 'package:wine_app/ui/theme/app_theme.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  initAppDependences();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  late ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => instance<ThemeCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return Sizer(builder: (context, orientation, deviceType) {
            themeCubit = instance<ThemeCubit>();
            themeCubit.getAppTheme;
            return MaterialApp(
              // theme: getAppTheme(),
              // TODO: make colors in themes
              theme: themeCubit.isLightTheme ? AppThemes.lightTheme : AppThemes.darkTheme,
              onGenerateRoute: RouteGenerator.onGenerateRoute,
              initialRoute: AppRoutes.splashRoute,
              debugShowCheckedModeBanner: false,
            );
          });
        },
      ),
    );
  }
}
