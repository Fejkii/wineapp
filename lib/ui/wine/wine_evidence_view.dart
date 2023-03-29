import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quantity_input/quantity_input.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
  late int wineVolume;

  @override
  void initState() {
    wineEvidence = widget.wineEvidence;
    wineVolume = wineEvidence.volume.toInt();
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
        const SizedBox(height: AppMargin.m20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.wineQuantity),
            QuantityInput(
              value: wineVolume,
              acceptsZero: true,
              step: 10,
              onChanged: (value) => setState(() => wineVolume = int.parse(value.replaceAll(',', ''))),
              inputWidth: 100,
              buttonColor: Colors.green,
            ),
            AppIconButton(
              iconButtonType: IconButtonType.save,
              onPress: () {
                wineEvidence.volume = wineVolume.toDouble();
                wineCubit.updateWineEvidenceVolume(wineEvidence.id, wineVolume.toDouble());
              },
            ),
          ],
        ),
        const SizedBox(height: AppMargin.m20),
        _otherInfo(),
        const SizedBox(height: AppMargin.m20),
        AppButton(
          title: AppLocalizations.of(context)!.addRecord,
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
          TableCell(child: Text(AppLocalizations.of(context)!.acid)),
          TableCell(child: Text(wineEvidence.acid.toString())),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.sugar)),
          TableCell(child: Text(wineEvidence.sugar.toString())),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.alcohol)),
          TableCell(child: Text(wineEvidence.alcohol.toString())),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.created)),
          TableCell(child: Text(appFormatDate(wineEvidence.createdAt))),
        ]),
        if (wineEvidence.updatedAt != null)
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.updated)),
            TableCell(child: Text(appFormatDate(wineEvidence.updatedAt!))),
          ]),
        if (wineEvidence.note != AppConstant.EMPTY)
          TableRow(children: [
            TableCell(child: Text(AppLocalizations.of(context)!.note)),
            TableCell(child: Text(wineEvidence.note!)),
          ]),
      ],
    );
  }
}
