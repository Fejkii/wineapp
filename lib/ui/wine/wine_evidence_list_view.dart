import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_sidebar.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';
import 'package:wine_app/ui/wine/wine_evidence_view.dart';

class WineEvidenceListView extends StatefulWidget {
  const WineEvidenceListView({super.key});

  @override
  State<WineEvidenceListView> createState() => _WineEvidenceListViewState();
}

class _WineEvidenceListViewState extends State<WineEvidenceListView> {
  WineCubit wineCubit = instance<WineCubit>();
  late List<WineEvidenceModel> wineEvidenceList;

  @override
  void initState() {
    wineEvidenceList = [];
    wineCubit.getWineEvidenceList();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return Scaffold(
          drawer: AppSidebar(),
          appBar: AppBar(
            title: const Text(AppStrings.wineEvidence),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WineEvidenceView(),
                    ),
                  );
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _list(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _list() {
    return BlocConsumer<WineCubit, WineState>(
      listener: (context, state) {
        if (state is WineEvidenceListSuccessState) {
          wineEvidenceList = state.wineEvidenceList;
        } else if (state is WineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is WineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: wineEvidenceList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wineEvidenceList[index].title),
          Text(wineEvidenceList[index].volume.toString()),
          Text(wineEvidenceList[index].year.toString()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineEvidenceView(wineEvidence: wineEvidenceList[index]),
          ),
        ).then((value) => _onGoBack());
      },
    );
  }

  void _onGoBack() {
    wineCubit.getWineEvidenceList();
  }
}
