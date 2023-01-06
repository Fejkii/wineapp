import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_app/api/api_factory.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/bloc/project/project_cubit.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';

final instance = GetIt.instance;

Future<void> initAppDependences() async {
  // initial shared preference isntance
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<SharedPreferences>()));

  instance.registerLazySingleton<ApiFactory>(() => ApiFactory(instance<AppPreferences>()));

  instance.registerLazySingleton<ThemeCubit>(() => ThemeCubit(instance<AppPreferences>()));

  instance.registerLazySingleton<AuthCubit>(() => AuthCubit(instance<AppPreferences>()));

  instance.registerLazySingleton<ProjectCubit>(() => ProjectCubit(instance<AppPreferences>()));
  
  instance.registerLazySingleton<UserProjectCubit>(() => UserProjectCubit());
}

// reset, because token is not refreshed in request after login
void resetAppDependences() {
  instance.reset(dispose: false);
  initAppDependences();
}
