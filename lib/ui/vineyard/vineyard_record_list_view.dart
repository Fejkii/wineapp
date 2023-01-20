import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/ui/vineyard/vineyard_record_detail_view.dart';
import 'package:wine_app/ui/widgets/app_list_view.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardRecordListView extends StatefulWidget {
  final int vineyardId;
  const VineyardRecordListView({
    Key? key,
    required this.vineyardId,
  }) : super(key: key);

  @override
  State<VineyardRecordListView> createState() => _VineyardRecordListViewState();
}

class _VineyardRecordListViewState extends State<VineyardRecordListView> {
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();
  late List<VineyardRecordModel> vineyardRecordList;

  @override
  void initState() {
    vineyardRecordList = [];
    _getData();
    super.initState();
  }

  void _getData() {
    vineyardCubit.getVineyardRecordList(widget.vineyardId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return _list();
      },
    );
  }

  Widget _list() {
    return BlocConsumer<VineyardCubit, VineyardState>(
      listener: (context, state) {
        if (state is VineyardRecordListSuccessState) {
          vineyardRecordList = state.vineyardRecordList;
        } else if (state is VineyardFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return AppListView(listData: vineyardRecordList, itemBuilder: _itemBuilder);
        }
      },
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return AppListViewItem(
      itemBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(vineyardRecordList[index].title),
          Text(vineyardRecordList[index].vineyardRecordType.title),
          Text(appFormatDate(vineyardRecordList[index].date, dateOnly: true)),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VineyardRecordDetailView(
              vineyardId: widget.vineyardId,
              vineyardRecord: vineyardRecordList[index],
            ),
          ),
        ).then((value) => _getData());
      },
    );
  }
}
