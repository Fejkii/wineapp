import 'package:flutter/material.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';

class ProjectDashboardView extends StatefulWidget {
  const ProjectDashboardView({super.key});

  @override
  State<ProjectDashboardView> createState() => _ProjectDashboardViewState();
}

class _ProjectDashboardViewState extends State<ProjectDashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instance<AppPreferences>().getProject()!.title),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Project: ${instance<AppPreferences>().getProject()!.title}"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.userProjectListRoute);
                },
                child: Text(
                  AppStrings.showUserProjectList,
                  style: Theme.of(context).textTheme.button,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
