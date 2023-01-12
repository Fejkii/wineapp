import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_sidebar.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';
import 'package:wine_app/ui/wine/wine_view.dart';

class WineListView extends StatefulWidget {
  const WineListView({super.key});

  @override
  State<WineListView> createState() => _WineListViewState();
}

class _WineListViewState extends State<WineListView> {
  WineCubit wineCubit = instance<WineCubit>();
  late List<WineModel> wineList;

  @override
  void initState() {
    wineList = [];
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    wineCubit.getWineList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return Scaffold(
          drawer: AppSidebar(),
          appBar: AppBar(
            title: const Text(AppStrings.wines),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WineView(wine: null),
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
              _wineVarietyList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wineVarietyList() {
    return BlocConsumer<WineCubit, WineState>(
      listener: (context, state) {
        if (state is WineListSuccessState) {
          wineList = state.wineList;
        } else if (state is WineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is WineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: wineList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wineList[index].title),
          Text(wineList[index].wineVariety.title),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineView(wine: wineList[index]),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
