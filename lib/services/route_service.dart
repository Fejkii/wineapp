import 'package:flutter/material.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/services/custom_view_route.dart';
import 'package:wine_app/ui/authentication/forget_password_view.dart';
import 'package:wine_app/ui/authentication/login_view.dart';
import 'package:wine_app/ui/authentication/register_view.dart';
import 'package:wine_app/ui/home/home_view.dart';
import 'package:wine_app/ui/project/create_project_view.dart';
import 'package:wine_app/ui/project/project_dashboard.dart';
import 'package:wine_app/ui/project/user_project_list_view.dart';
import 'package:wine_app/ui/settings/settings_view.dart';
import 'package:wine_app/ui/splash_view.dart';
import 'package:wine_app/ui/user/user_detail_view.dart';
import 'package:wine_app/ui/wine/wine_list_view.dart';
import 'package:wine_app/ui/wine/wine_variety_list_view.dart';

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.registerRoute:
        return CustomViewRoute(direction: AxisDirection.left, child: const RegisterView());
      case AppRoutes.forgetPasswordRoute:
        return CustomViewRoute(direction: AxisDirection.left, child: const ForgetPasswordView());
      case AppRoutes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case AppRoutes.userRoute:
        return MaterialPageRoute(builder: (_) => const UserDetailView());
      case AppRoutes.projectRoute:
        return MaterialPageRoute(builder: (_) => const ProjectDashboardView());
      case AppRoutes.createProjectRoute:
        return MaterialPageRoute(builder: (_) => const CreateProjectView());
      case AppRoutes.userProjectListRoute:
        return MaterialPageRoute(builder: (_) => const UserProjectListView());
      case AppRoutes.settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case AppRoutes.wineRoute:
        return MaterialPageRoute(builder: (_) => const WineListView());
      case AppRoutes.wineVarietyListRoute:
        return MaterialPageRoute(builder: (_) => const WineVarietyListView());
      default:
        return null;
    }
  }
}
