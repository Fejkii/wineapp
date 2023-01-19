import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/wine/wine_evidence_view.dart';
import 'package:wine_app/ui/wine/wine_record_detail.dart';
import 'package:wine_app/ui/wine/wine_record_list.dart';

class WineEvidenceDetailView extends StatefulWidget {
  final WineEvidenceModel wineEvidence;
  const WineEvidenceDetailView({
    Key? key,
    required this.wineEvidence,
  }) : super(key: key);

  @override
  State<WineEvidenceDetailView> createState() => _WineEvidenceDetailViewState();
}

class _WineEvidenceDetailViewState extends State<WineEvidenceDetailView> {
  WineCubit wineCubit = instance<WineCubit>();
  AppPreferences appPreferences = instance<AppPreferences>();
  List<WineModel> wineList = [];
  WineModel? selectedWine;
  late WineEvidenceModel wineEvidence;

  @override
  void initState() {
    wineEvidence = widget.wineEvidence;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getData() {
    wineCubit.getWineEvidence(wineEvidence.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(wineEvidence.title),
              actions: [
                AppIconButton(
                    iconButtonType: IconButtonType.edit,
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WineEvidenceView(wineEvidence: wineEvidence),
                        ),
                      ).then((value) => _getData());
                    })
              ],
            ),
            body: _getContentWidget(),
          ),
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
              const SizedBox(height: AppMargin.m10),
              _otherInfo(),
              const SizedBox(height: AppMargin.m20),
              AppLoginButton(
                title: AppStrings.addRecord,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WineRecordDetailView(wineEvidenceId: wineEvidence.id),
                    ),
                  ).then((value) => _getData());
                },
              ),
              const SizedBox(height: AppMargin.m10),
              _wineRedordList(),
              const SizedBox(height: AppMargin.m20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _wineRedordList() {
    return WineRecordList(wineEvidenceId: wineEvidence.id);
  }

  Widget _otherInfo() {
    return Table(
      children: [
        TableRow(children: [
          const TableCell(child: Text(AppStrings.volume)),
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
        TableRow(children: [
          const TableCell(child: Text(AppStrings.updated)),
          TableCell(child: Text(appFormatDate(wineEvidence.updatedAt!))),
        ]),
        TableRow(children: [
          const TableCell(child: Text(AppStrings.note)),
          TableCell(child: Text(wineEvidence.note)),
        ]),
      ],
    );
  }
}
