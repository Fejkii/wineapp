import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';
import 'package:wine_app/ui/wine/wine_record_detail_view.dart';

class WineRecordList extends StatefulWidget {
  final int wineEvidenceId;
  const WineRecordList({
    Key? key,
    required this.wineEvidenceId,
  }) : super(key: key);

  @override
  State<WineRecordList> createState() => _WineRecordListState();
}

class _WineRecordListState extends State<WineRecordList> {
  WineCubit wineCubit = instance<WineCubit>();
  late List<WineRecordModel> wineRecordList;

  @override
  void initState() {
    wineRecordList = [];
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    wineCubit.getWineRecordList(widget.wineEvidenceId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return _list();
      },
    );
  }

  Widget _list() {
    return BlocConsumer<WineCubit, WineState>(
      listener: (context, state) {
        if (state is WineRecordListSuccessState) {
          wineRecordList = state.wineRecordList;
        } else if (state is WineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is WineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: wineRecordList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(wineRecordList[index].title),
          Text(wineRecordList[index].wineRecordType.title),
          Text(appFormatDate(wineRecordList[index].date, dateOnly: true)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WineRecordDetailView(
              wineEvidenceId: widget.wineEvidenceId,
              wineRecord: wineRecordList[index],
            ),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
