import 'package:flutter/material.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/project/share_project_widget.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class ProjectDashboardView extends StatefulWidget {
  const ProjectDashboardView({super.key});

  @override
  State<ProjectDashboardView> createState() => _ProjectDashboardViewState();
}

class _ProjectDashboardViewState extends State<ProjectDashboardView> {
  AppPreferences appPreferences = instance<AppPreferences>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldLayout(
      body: _bodyWidget(),
      appBar: AppBar(
        title: Text(instance<AppPreferences>().getProject()!.title),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
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
        const Divider(height: 40),
        const ShareProjectWidget()
      ],
    );
  }
}
