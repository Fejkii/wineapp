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
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _requiredSulphurisationController = TextEditingController();
  final TextEditingController _liquidSulfurController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final WineCubit wineCubit = instance<WineCubit>();

  late int wineEvidenceId;
  late WineRecordModel? wineRecord;
  late WineRecordType? selectedWineRecordType;
  late List<WineRecordType> wineRecordTypeList;
  late double defaultFreeSulfure;
  late double defaultLiquidSulfur;
  late bool _isInProgress;

  double sulfirizationBy = 0;
  double dosage = 0;
  String title = "";

  @override
  void initState() {
    defaultFreeSulfure = appPreferences.getProjectSettings()!.defaultFreeSulfur;
    defaultLiquidSulfur = appPreferences.getProjectSettings()!.defaultLiquidSulfur;
    wineRecordTypeList = WineRecordType.values.map((e) => e).toList();
    wineEvidenceId = widget.wineEvidence.id;
    wineRecord = null;
    selectedWineRecordType = null;
    _requiredSulphurisationController.text = defaultFreeSulfure.toStringAsFixed(0);
    _liquidSulfurController.text = defaultLiquidSulfur.toStringAsFixed(0);
    _volumeController.text = widget.wineEvidence.volume.toStringAsFixed(0);
    _isInProgress = false;

    if (widget.wineRecord != null) {
      wineRecord = widget.wineRecord;
      selectedWineRecordType = WineRecordType.values.firstWhere((wrt) => wrt.getId() == wineRecord!.wineRecordType.id);
      _noteController.text = wineRecord!.note ?? "";
      _titleController.text = wineRecord!.title ?? "";

      if (wineRecord!.wineRecordType.id == WineRecordType.measurementFreeSulfure.getId()) {
        double freeSulfure = WineRecordFreeSulfure.fromJson(wineRecord!.data).freeSulfure;
        double volume = WineRecordFreeSulfure.fromJson(wineRecord!.data).volume;
        double requiredSulphurisation = WineRecordFreeSulfure.fromJson(wineRecord!.data).requiredSulphurisation;
        double liquidSulfur = WineRecordFreeSulfure.fromJson(wineRecord!.data).liquidSulfur;
        _freeSulfureCalculate(volume, freeSulfure, requiredSulphurisation, liquidSulfur);
        _volumeController.text = volume.toStringAsFixed(0);
        _freeSulfureController.text = freeSulfure.toStringAsFixed(0);
        _requiredSulphurisationController.text = requiredSulphurisation.toStringAsFixed(0);
        _liquidSulfurController.text = liquidSulfur.toStringAsFixed(0);
      }

      if (wineRecord!.wineRecordType.id == WineRecordType.fermentation.getId()) {
        _dateToController.text = wineRecord!.dateTo != null ? wineRecord!.dateTo!.toIso8601String() : "";
        _isInProgress = wineRecord!.isInProgress != null ? wineRecord!.isInProgress! : false;
      }
    }

    _freeSulfureListener(_volumeController);
    _freeSulfureListener(_freeSulfureController);
    _freeSulfureListener(_requiredSulphurisationController);
    _freeSulfureListener(_liquidSulfurController);

    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dateToController.dispose();
    _noteController.dispose();
    _titleController.dispose();
    _freeSulfureController.dispose();
    _requiredSulphurisationController.dispose();
    _liquidSulfurController.dispose();
    _volumeController.dispose();
    super.dispose();
  }

  void _freeSulfureListener(TextEditingController controller) {
    controller.addListener(() {
      setState(() {
        if (_volumeController.text != "" &&
            _freeSulfureController.text != "" &&
            _requiredSulphurisationController.text != "" &&
            _liquidSulfurController.text != "") {
          _freeSulfureCalculate(
            double.parse(_volumeController.text),
            double.parse(_freeSulfureController.text),
            double.parse(_requiredSulphurisationController.text),
            double.parse(_liquidSulfurController.text),
          );
        } else {
          sulfirizationBy = 0;
          dosage = 0;
        }
      });
    });
  }

  void _freeSulfureCalculate(double volume, double measuredSulfure, double requiredSulphurisation, double liquidSulfur) {
    double sulfirization = requiredSulphurisation - measuredSulfure;
    sulfirizationBy = sulfirization > 0 ? sulfirization : 0;
    dosage = volume * (0.01 * sulfirizationBy) * (10 / liquidSulfur);
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
                          String data = "";
                          if (WineRecordType.measurementFreeSulfure == selectedWineRecordType) {
                            _titleController.text = "";
                            data = WineRecordFreeSulfure(
                              freeSulfure: double.parse(_freeSulfureController.text),
                              volume: widget.wineEvidence.volume,
                              requiredSulphurisation: double.parse(_requiredSulphurisationController.text),
                              liquidSulfur: double.parse(_liquidSulfurController.text),
                              sulfurizationBy: sulfirizationBy,
                              liquidSulfurDosage: double.parse(dosage.toStringAsFixed(2)),
                            ).toJson();
                          }
                          if (wineRecord != null) {
                            wineCubit.updateWineRecord(
                              wineRecord!.id,
                              selectedWineRecordType!.getId(),
                              appToDateTime(_dateController.text)!,
                              _isInProgress,
                              appToDateTime(_dateToController.text),
                              _titleController.text,
                              data,
                              _noteController.text,
                            );
                          } else {
                            wineCubit.createWineRecord(
                              wineEvidenceId,
                              selectedWineRecordType!.getId(),
                              appToDateTime(_dateController.text)!,
                              _isInProgress,
                              appToDateTime(_dateToController.text),
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
            initDate: wineRecord?.date,
            fillTodayDate: true,
            setIcon: true,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineRecordType>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineRecordTypeList,
            itemAsString: (WineRecordType wrt) => wrt.getTranslate(context),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                labelText: AppLocalizations.of(context)!.wineRecordType,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (WineRecordType? value) {
              setState(() {
                selectedWineRecordType = value;
              });
            },
            validator: (WineRecordType? item) {
              if (item == null) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectedItem: selectedWineRecordType,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          _freeSulfure(),
          _fermentation(),
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
      return AppTextWithValue(text: AppLocalizations.of(context)!.created, value: appFormatDateTime(widget.wineRecord!.createdAt, dateOnly: false));
    } else {
      return Container();
    }
  }

  Widget _freeSulfure() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.measurementFreeSulfure
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                AppTextFormField(
                  controller: _freeSulfureController,
                  label: AppLocalizations.of(context)!.measuredFreeSulfur,
                  isRequired: true,
                  inputType: InputType.double,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppMargin.m10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.wineQuantity,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextFormField(
                          controller: _volumeController,
                          isRequired: true,
                          label: "",
                          keyboardType: TextInputType.number,
                          unit: AppUnits().liter(_volumeController, context)),
                    ),
                  ],
                ),
                const SizedBox(height: AppMargin.m10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.requiredSulphurisation,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextFormField(
                        controller: _requiredSulphurisationController,
                        isRequired: true,
                        label: "",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppMargin.m10),
                Row(
                  children: [
                    Flexible(
                      child: AppTextWithValue(
                        text: AppLocalizations.of(context)!.liquidSulfur,
                        value: "",
                      ),
                    ),
                    Flexible(
                      child: AppTextFormField(
                        controller: _liquidSulfurController,
                        isRequired: true,
                        label: "",
                        keyboardType: TextInputType.number,
                        unit: AppUnits.percent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppMargin.m10),
                AppTextWithValue(
                  text: AppLocalizations.of(context)!.sulfurizationBy,
                  value: sulfirizationBy.toStringAsFixed(0),
                ),
                AppTextWithValue(
                  text: AppLocalizations.of(context)!.liquidSulfurDosage,
                  value: dosage.toStringAsFixed(1),
                  unit: AppUnits.miliLiter,
                )
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _fermentation() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.fermentation
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.inProgress),
                    Switch(
                      value: _isInProgress,
                      onChanged: (value) {
                        setState(() {
                          _isInProgress = !_isInProgress;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: AppMargin.m20),
                AppDatePicker(
                  controller: _dateToController,
                  label: AppLocalizations.of(context)!.dateTo,
                  initDate: wineRecord?.dateTo,
                  fillTodayDate: false,
                  setIcon: true,
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _otherRecord() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType == WineRecordType.others
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
