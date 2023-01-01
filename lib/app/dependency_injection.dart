import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wine_app/api/dio_factory.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/bloc/theme/theme_cubit.dart';

final instance = GetIt.instance;

Future<void> initAppDependences() async {
  // initial shared preference isntance
  final sharedPreferences = await SharedPreferences.getInstance();
  instance.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // app preferences instance
  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance<SharedPreferences>()));

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance<AppPreferences>()));

  // final dio = await instance<DioFactory>().getDio();
  // instance.registerLazySingleton<ApiMethodsClient>(() => ApiMethodsClient(dio));

  instance.registerLazySingleton<ThemeCubit>(() => ThemeCubit(instance()));
  // instance.registerLazySingleton<ThemeCubit>(() => ThemeCubit(instance<AppPreferences>()));
}

// reset, because token is not refreshed in request after login
void resetAppDependences() {
  instance.reset(dispose: false);
  initAppDependences();
}
