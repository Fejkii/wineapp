import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/project/user_project_detail_view.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class UserProjectListView extends StatefulWidget {
  const UserProjectListView({super.key});

  @override
  State<UserProjectListView> createState() => _UserProjectListViewState();
}

class _UserProjectListViewState extends State<UserProjectListView> {
  UserProjectCubit userProjectCubit = instance<UserProjectCubit>();
  late List<UserProjectModel> userProjectList;

  @override
  void initState() {
    userProjectList = [];
    userProjectCubit.getUserProjectList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProjectCubit, UserProjectState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createProjectRoute);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: _getContentWidget(),
        );
      },
    );
  }

  Widget _getContentWidget() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.p20),
        child: BlocConsumer<UserProjectCubit, UserProjectState>(
          listener: (context, state) {
            if (state is UserProjectListSuccessState) {
              userProjectList = state.userProjectList;
            } else if (state is UserProjectFailureState) {
              AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
            }
          },
          builder: (context, state) {
            if (state is UserProjectLoadingState) {
              return const AppLoadingIndicator();
            } else {
              return AppListView(listData: userProjectList, itemBuilder: _itemBuilder);
            }
          },
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Text(userProjectList[index].project.title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProjectDetailView(userProject: userProjectList[index]),
          ),
        );
      },
    );
  }
}
