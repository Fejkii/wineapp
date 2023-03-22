import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';
import 'package:wine_app/ui/wine/wine_evidence_view.dart';
import 'package:wine_app/ui/wine/wine_evidence_detail_view.dart';

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
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    wineCubit.getWineEvidenceList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _list(),
          hasSidebar: true,
          appBar: AppBar(
            title:  Text(AppLocalizations.of(context)!.wineEvidence),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WineEvidenceDetailView(),
                    ),
                  );
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
          Text("${wineEvidenceList[index].volume.toString()} l"),
          Text(wineEvidenceList[index].year.toString()),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineEvidenceView(wineEvidence: wineEvidenceList[index]),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
