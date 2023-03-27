// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard_wine/vineyard_wine_cubit.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/ui/vineyard/vineyard_wine_detail_view.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardWineListView extends StatefulWidget {
  final int vineyardId;
  const VineyardWineListView({
    Key? key,
    required this.vineyardId,
  }) : super(key: key);

  @override
  State<VineyardWineListView> createState() => _VineyardWineListViewState();
}

class _VineyardWineListViewState extends State<VineyardWineListView> {
  final VineyardWineCubit vineyardWineCubit = instance<VineyardWineCubit>();
  late List<VineyardWineModel> vineyardWineList;

  @override
  void initState() {
    vineyardWineList = [];
    _getData();
    super.initState();
  }

  void _getData() {
    vineyardWineCubit.getVineyardWineList(widget.vineyardId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardWineCubit, VineyardWineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _list(),
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.vineyardWines),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VineyardWineDetailView(vineyardId: widget.vineyardId),
                    ),
                  ).then((value) => _getData());
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _list() {
    return BlocConsumer<VineyardWineCubit, VineyardWineState>(
      listener: (context, state) {
        if (state is VineyardWineListSuccessState) {
          vineyardWineList = state.vineyardWineList;
        } else if (state is VineyardWineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardWineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: vineyardWineList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vineyardWineList[index].title),
          Text(vineyardWineList[index].quantity.toString()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardWineDetailView(
              vineyardId: vineyardWineList[index].vineyardId,
              vineyardWine: vineyardWineList[index],
            ),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
