import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/model/base/wine_record_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_date_picker.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineRecordDetailView extends StatefulWidget {
  final WineEvidenceModel wineEvidence;
  final WineRecordModel? wineRecord;
  const WineRecordDetailView({
    Key? key,
    required this.wineEvidence,
    this.wineRecord,
  }) : super(key: key);

  @override
  State<WineRecordDetailView> createState() => _WineRecordDetailViewState();
}

class _WineRecordDetailViewState extends State<WineRecordDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _freeSulfureController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final WineCubit wineCubit = instance<WineCubit>();

  late int wineEvidenceId;
  late WineRecordModel? wineRecord;
  late WineRecordTypeModel? selectedWineRecordType;
  late List<WineRecordTypeModel> wineRecordTypeList;
  late double defaultFreeSulfure;
  late double defaultLiquidSulfur;

  double sulfirizationBy = 0;
  double dosage = 0;
  String title = "";
  String data = "";

  @override
  void initState() {
    defaultFreeSulfure = appPreferences.getProjectSettings()!.defaultFreeSulfur;
    defaultLiquidSulfur = appPreferences.getProjectSettings()!.defaultLiquidSulfur;
    wineRecordTypeList = appPreferences.getWineRecordTypeList() ?? [];
    wineEvidenceId = widget.wineEvidence.id;
    wineRecord = null;
    selectedWineRecordType = null;
    if (widget.wineRecord != null) {
      wineRecord = widget.wineRecord;
      selectedWineRecordType = wineRecord!.wineRecordType;
      _dateController.text = wineRecord!.date.toIso8601String();
      _noteController.text = wineRecord!.note ?? "";
      _titleController.text = wineRecord!.title ?? "";

      if (wineRecord!.wineRecordType.id == WineRecordType.measurementFreeSulfure.getId()) {
        String value = WineRecordFreeSulfure.fromJson(wineRecord!.data).freeSulfure.toStringAsFixed(2);
        _freeSulfureController.text = value;
        _freeSulfureCalculate(double.parse(value));
      }
    }

    _freeSulfureController.addListener(() {
      setState(() {
        if (_freeSulfureController.text != "") {
          _freeSulfureCalculate(double.parse(_freeSulfureController.text));
        } else {
          sulfirizationBy = 0;
          dosage = 0;
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    _freeSulfureController.dispose();
    super.dispose();
  }

  void _freeSulfureCalculate(double value) {
    double sulfirization = appPreferences.getProjectSettings()!.defaultFreeSulfur - value;
    sulfirizationBy = sulfirization > 0 ? sulfirization : 0;
    dosage = widget.wineEvidence.volume * (0.01 * sulfirizationBy) * (10 / defaultLiquidSulfur);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(wineRecord != null ? wineRecord!.wineRecordType.title : AppLocalizations.of(context)!.addRecord),
            actions: [
              BlocConsumer<WineCubit, WineState>(
                listener: (context, state) {
                  if (state is WineRecordSuccessState) {
                    setState(() {
                      wineRecord != null
                          ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastStates.success)
                          : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastStates.success);
                    });
                    Navigator.pop(context);
                  } else if (state is WineFailureState) {
                    AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                  }
                },
                builder: (context, state) {
                  if (state is WineLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return AppIconButton(
                      iconButtonType: IconButtonType.save,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          if (WineRecordType.measurementFreeSulfure.getId() == selectedWineRecordType!.id) {
                            data = WineRecordFreeSulfure(
                              freeSulfure: double.parse(_freeSulfureController.text),
                              volume: widget.wineEvidence.volume,
                              requiredSulphurisation: defaultFreeSulfure,
                              liquidSulfur: defaultLiquidSulfur,
                              sulfurizationBy: sulfirizationBy,
                              liquidSulfurDosage: double.parse(dosage.toStringAsFixed(2)),
                            ).toJson();
                          }
                          if (wineRecord != null) {
                            wineCubit.updateWineRecord(
                              wineRecord!.id,
                              selectedWineRecordType!.id,
                              DateTime.parse(_dateController.text),
                              _titleController.text,
                              data,
                              _noteController.text,
                            );
                          } else {
                            wineCubit.createWineRecord(
                              wineEvidenceId,
                              selectedWineRecordType!.id,
                              DateTime.parse(_dateController.text),
                              _titleController.text,
                              data,
                              _noteController.text,
                            );
                          }
                        }
                      },
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: AppMargin.m10),
          AppDatePicker(
            controller: _dateController,
            setIcon: true,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineRecordTypeModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineRecordTypeList,
            itemAsString: (WineRecordTypeModel wc) => wc.title,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.wineRecordType,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (WineRecordTypeModel? value) {
              setState(() {
                selectedWineRecordType = value;
              });
            },
            selectedItem: selectedWineRecordType,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          _freeSulfure(),
          _otherRecord(),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _noteController,
            label: AppLocalizations.of(context)!.note,
            inputType: InputType.note,
          ),
          const SizedBox(height: AppMargin.m20),
          _otherInfo(),
        ],
      ),
    );
  }

  Widget _otherInfo() {
    if (widget.wineRecord != null) {
      return AppTextWithValue(text: AppLocalizations.of(context)!.created, value: appFormatDate(widget.wineRecord!.createdAt));
    } else {
      return Container();
    }
  }

  Widget _freeSulfure() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType!.id == WineRecordType.measurementFreeSulfure.getId()
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                AppTextFormField(
                  controller: _freeSulfureController,
                  label: AppLocalizations.of(context)!.measuredFreeSulfur,
                  isRequired: true,
                  inputType: InputType.number,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppMargin.m10),
                AppTextWithValue(text: AppLocalizations.of(context)!.wineQuantity, value: widget.wineEvidence.volume, unit: AppUnits.liter),
                AppTextWithValue(text: AppLocalizations.of(context)!.requiredSulphurisation, value: defaultFreeSulfure.toStringAsFixed(0)),
                AppTextWithValue(
                    text: AppLocalizations.of(context)!.liquidSulfur, value: defaultLiquidSulfur.toStringAsFixed(0), unit: AppUnits.percent),
                Column(
                  children: [
                    AppTextWithValue(text: AppLocalizations.of(context)!.sulfurizationBy, value: sulfirizationBy.toStringAsFixed(0)),
                    AppTextWithValue(
                        text: AppLocalizations.of(context)!.liquidSulfurDosage, value: dosage.toStringAsFixed(2), unit: AppUnits.mililiter),
                  ],
                )
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _otherRecord() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType!.id == WineRecordType.others.getId()
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                AppTextFormField(
                  controller: _titleController,
                  label: AppLocalizations.of(context)!.title,
                  isRequired: true,
                  inputType: InputType.title,
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }
}
