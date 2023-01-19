import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/project/share_project_widget.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class UserProjectDetailView extends StatefulWidget {
  final UserProjectModel userProject;
  const UserProjectDetailView({
    Key? key,
    required this.userProject,
  }) : super(key: key);

  @override
  State<UserProjectDetailView> createState() => _UserProjectDetailViewState();
}

class _UserProjectDetailViewState extends State<UserProjectDetailView> {
  final AppPreferences appPreferences = instance<AppPreferences>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProjectCubit, UserProjectState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: const ShareProjectWidget(),
          appBar: AppBar(
            title: Text(appPreferences.getProject()!.title),
          ),
        );
      },
    );
  }
}
