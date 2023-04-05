import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/bloc/vineyard_wine/vineyard_wine_cubit.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/reponse/base_response.dart';
import 'package:wine_app/ui/vineyard/vineyard_detail_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_record_detail_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_record_list_view.dart';
import 'package:wine_app/ui/vineyard/vineyard_wine_list_view.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardView extends StatefulWidget {
  final VineyardModel vineyard;
  const VineyardView({
    Key? key,
    required this.vineyard,
  }) : super(key: key);

  @override
  State<VineyardView> createState() => _VineyardViewState();
}

class _VineyardViewState extends State<VineyardView> {
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();
  final VineyardWineCubit vineyardWineCubit = instance<VineyardWineCubit>();
  late VineyardModel vineyard;
  late SummaryResponse? summaryResponse;

  @override
  void initState() {
    vineyard = widget.vineyard;
    summaryResponse = null;
    _getData();
    super.initState();
  }

  void _getData() {
    vineyardCubit.getVineyard(vineyard.id);
    vineyardWineCubit.getVineyardWineSummary(vineyard.id);
    vineyardCubit.getVineyardRecordList(vineyard.id);
    vineyardCubit.getVineyardRecordTypeList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
          appBar: AppBar(
            title: Text(vineyard.title),
            actions: [
              AppIconButton(
                iconButtonType: IconButtonType.edit,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VineyardDetailView(vineyard: vineyard),
                    ),
                  ).then((value) => _getData());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _otherInfo(),
        const SizedBox(height: AppMargin.m20),
        AppButton(
          title: AppLocalizations.of(context)!.vineyardWines,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VineyardWineListView(vineyardId: vineyard.id),
              ),
            ).then((value) => _getData());
          },
        ),
        const SizedBox(height: AppMargin.m20),
        AppButton(
          title: AppLocalizations.of(context)!.addRecord,
          buttonType: ButtonType.add,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VineyardRecordDetailView(vineyard: vineyard),
              ),
            ).then((value) => _getData());
          },
        ),
        const SizedBox(height: AppMargin.m10),
        VineyardRecordListView(vineyard: vineyard),
        const SizedBox(height: AppMargin.m20),
      ],
    );
  }

  Widget _otherInfo() {
    return BlocConsumer<VineyardWineCubit, VineyardWineState>(
      listener: (context, state) {
        if (state is VineyardWineSummarySuccessState) {
          summaryResponse = state.vineyardWineSummary;
        } else if (state is VineyardWineFailureState) {
          AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
        }
      },
      builder: (context, state) {
        if (state is VineyardWineLoadingState) {
          return const AppLoadingIndicator();
        } else {
          return Column(
            children: [
              AppTextWithValue(
                text: AppLocalizations.of(context)!.area,
                value: vineyard.area.toString(),
                unit: AppUnits.squareMeter,
              ),
              AppTextWithValue(
                text: AppLocalizations.of(context)!.wineVarietyQuantity,
                value: summaryResponse?.count,
              ),
              AppTextWithValue(
                text: AppLocalizations.of(context)!.vineyardWineQuantity,
                value: summaryResponse?.sum,
              ),
            ],
          );
        }
      },
    );
  }
}
