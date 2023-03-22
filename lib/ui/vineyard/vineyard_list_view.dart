import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/ui/vineyard/vineyard_detail_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_view.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

import '../widgets/app_loading_indicator.dart';

class VineyardListView extends StatefulWidget {
  const VineyardListView({Key? key}) : super(key: key);

  @override
  State<VineyardListView> createState() => _VineyardListViewState();
}

class _VineyardListViewState extends State<VineyardListView> {
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();
  late List<VineyardModel> vineyardList = [];

  @override
  void initState() {
    _getData();
    super.initState();
  }

  void _getData() {
    vineyardCubit.getVineyardList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _list(),
          hasSidebar: true,
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.vineyards),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VineyardDetailView(),
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
    return BlocConsumer<VineyardCubit, VineyardState>(
      listener: (context, state) {
        if (state is VineyardListSuccessState) {
          vineyardList = state.vineyardList;
        } else if (state is VineyardFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: vineyardList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vineyardList[index].title),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardView(vineyard: vineyardList[index]),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
