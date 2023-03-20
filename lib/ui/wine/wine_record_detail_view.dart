import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
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

      if (wineRecord!.freeSulfure != null) {
        _freeSulfureController.text = wineRecord!.freeSulfure!.toStringAsFixed(0);
        _freeSulfureCalculate(double.parse(_freeSulfureController.text));
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
            title: Text(wineRecord != null ? wineRecord!.wineRecordType.title : AppStrings.addRecord),
            actions: [
              BlocConsumer<WineCubit, WineState>(
                listener: (context, state) {
                  if (state is WineRecordSuccessState) {
                    setState(() {
                      wineRecord != null
                          ? AppToastMessage().showToastMsg(AppStrings.updatedSuccessfully, ToastStates.success)
                          : AppToastMessage().showToastMsg(AppStrings.createdSuccessfully, ToastStates.success);
                    });
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
                          wineRecord != null
                              ? wineCubit.updateWineRecord(
                                  wineRecord!.id,
                                  selectedWineRecordType!.id,
                                  DateTime.parse(_dateController.text),
                                  double.tryParse(_freeSulfureController.text),
                                  _noteController.text,
                                )
                              : wineCubit.createWineRecord(
                                  wineEvidenceId,
                                  selectedWineRecordType!.id,
                                  DateTime.parse(_dateController.text),
                                  double.tryParse(_freeSulfureController.text),
                                  _noteController.text,
                                );
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
          AppDatePicker(
            controller: _dateController,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineRecordTypeModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineRecordTypeList,
            itemAsString: (WineRecordTypeModel wc) => wc.title,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppStrings.wineRecordType,
                hintText: AppStrings.selectInSelectBox,
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
          const SizedBox(height: AppMargin.m20),
          _freeSulfure(),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _noteController,
            label: AppStrings.note,
            inputType: InputType.note,
          ),
        ],
      ),
    );
  }

  Widget _freeSulfure() {
    if (selectedWineRecordType != null) {
      return selectedWineRecordType!.id == 1
          ? Column(
              children: [
                AppTextFormField(
                  controller: _freeSulfureController,
                  label: AppStrings.measuredFreeSulfur,
                  isRequired: true,
                  inputType: InputType.number,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: AppMargin.m10),
                AppTextWithValue(text: AppStrings.wineQuantity, value: widget.wineEvidence.volume, unit: AppUnits.liter),
                AppTextWithValue(text: AppStrings.requiredSulphurisation, value: defaultFreeSulfure.toStringAsFixed(0)),
                AppTextWithValue(text: AppStrings.liquidSulfur, value: defaultLiquidSulfur.toStringAsFixed(0), unit: AppUnits.percent),
                Column(
                  children: [
                    AppTextWithValue(text: AppStrings.sulfurizationBy, value: sulfirizationBy.toStringAsFixed(0)),
                    AppTextWithValue(text: AppStrings.liquidSulfurDosage, value: dosage.toStringAsFixed(2), unit: AppUnits.mililiter),
                  ],
                )
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }
}
