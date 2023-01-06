import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/user_project/user_project_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/project_model.dart';
import 'package:wine_app/ui/project/user_project_detail_view.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/theme/app_fonts.dart';
import 'package:wine_app/ui/theme/app_text_styles.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
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
                  icon: const Icon(Icons.add))
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
        padding: const EdgeInsets.all(AppPadding.p20),
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
              return userProjectList.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: userProjectList.length,
                      itemBuilder: _itemBuilder,
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          AppContentTitleText(text: AppStrings.emptyData, size: 20),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.search_off, size: 20),
                          ),
                        ],
                      ),
                    );
            }
          },
        ),
      ),
    );
  }

  Future<void> _onPullRefresh() async {
    // List<UserProjectModel?> freshUserProjects = await _viewModel.getUserProjectList();
    // setState(() {
    //   _userProjectlist = freshUserProjects;
    // });
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return InkWell(
      child: Card(
        child: Center(
          heightFactor: 3,
          child: Text(
            userProjectList[index].project.title,
            style: getBoldStyle(color: AppColors.black, fontSize: AppFontSize.s14),
          ),
        ),
      ),
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
