import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/wine/wine_evidence_detail_view.dart';
import 'package:wine_app/ui/wine/wine_record_detail_view.dart';
import 'package:wine_app/ui/wine/wine_record_list.dart';

class WineEvidenceView extends StatefulWidget {
  final WineEvidenceModel wineEvidence;
  const WineEvidenceView({
    Key? key,
    required this.wineEvidence,
  }) : super(key: key);

  @override
  State<WineEvidenceView> createState() => _WineEvidenceViewState();
}

class _WineEvidenceViewState extends State<WineEvidenceView> {
  WineCubit wineCubit = instance<WineCubit>();
  late WineEvidenceModel wineEvidence;

  @override
  void initState() {
    wineEvidence = widget.wineEvidence;
    super.initState();
  }

  void _getData() {
    wineCubit.getWineEvidence(wineEvidence.id);
    wineCubit.getWineRecordList(wineEvidence.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
          appBar: AppBar(
            title: Text(wineEvidence.title),
            actions: [
              AppIconButton(
                iconButtonType: IconButtonType.edit,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WineEvidenceDetailView(wineEvidence: wineEvidence),
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
        const SizedBox(height: AppMargin.m10),
        _otherInfo(),
        const SizedBox(height: AppMargin.m20),
        AppButton(
          title: AppStrings.addRecord,
          buttonType: ButtonType.add,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WineRecordDetailView(wineEvidence: wineEvidence),
              ),
            ).then((value) => _getData());
          },
        ),
        const SizedBox(height: AppMargin.m10),
        WineRecordList(wineEvidence: wineEvidence),
        const SizedBox(height: AppMargin.m20),
      ],
    );
  }

  Widget _otherInfo() {
    return Table(
      children: [
        TableRow(children: [
          const TableCell(child: Text(AppStrings.wineQuantity)),
          TableCell(child: Text(wineEvidence.volume.toString())),
        ]),
        TableRow(children: [
          const TableCell(child: Text(AppStrings.acid)),
          TableCell(child: Text(wineEvidence.acid.toString())),
        ]),
        TableRow(children: [
          const TableCell(child: Text(AppStrings.sugar)),
          TableCell(child: Text(wineEvidence.sugar.toString())),
        ]),
        TableRow(children: [
          const TableCell(child: Text(AppStrings.alcohol)),
          TableCell(child: Text(wineEvidence.alcohol.toString())),
        ]),
        TableRow(children: [
          const TableCell(child: Text(AppStrings.created)),
          TableCell(child: Text(appFormatDate(wineEvidence.createdAt))),
        ]),
        if (wineEvidence.updatedAt != null)
          TableRow(children: [
            const TableCell(child: Text(AppStrings.updated)),
            TableCell(child: Text(appFormatDate(wineEvidence.updatedAt!))),
          ]),
        if (wineEvidence.note != AppConstant.EMPTY)
          TableRow(children: [
            const TableCell(child: Text(AppStrings.note)),
            TableCell(child: Text(wineEvidence.note)),
          ]),
      ],
    );
  }
}
