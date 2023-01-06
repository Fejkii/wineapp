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
import 'package:wine_app/ui/widgets/app_toast_messages.dart';
import 'package:wine_app/ui/wine/wine_variety_view.dart';

class WineVarietyListView extends StatefulWidget {
  const WineVarietyListView({super.key});

  @override
  State<WineVarietyListView> createState() => _WineVarietyListViewState();
}

class _WineVarietyListViewState extends State<WineVarietyListView> {
  WineCubit wineCubit = instance<WineCubit>();
  late List<WineVarietyModel> wineVarietyList;

  @override
  void initState() {
    wineVarietyList = [];
    wineCubit.getWineVarietyList(instance<AppPreferences>().getProject()!.id);
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
          appBar: AppBar(
            title: const Text(AppStrings.wineVarieties),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WineVarietyView(wineVariety: null),
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
        if (state is WineVarietyListSuccessState) {
          wineVarietyList = state.wineVarietyList;
        } else if (state is WineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is WineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: wineVarietyList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wineVarietyList[index].title),
          Text(wineVarietyList[index].code),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineVarietyView(wineVariety: wineVarietyList[index]),
          ),
        );
      },
    );
  }
}
