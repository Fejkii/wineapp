import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({Key? key}) : super(key: key);

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          Center(child: Text(AppStrings.projectName)),
        ],
      ),
    );
  }
}