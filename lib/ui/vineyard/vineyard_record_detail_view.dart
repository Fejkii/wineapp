import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/base/vineyard_record_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_date_picker.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardRecordDetailView extends StatefulWidget {
  final VineyardModel vineyard;
  final VineyardRecordModel? vineyardRecord;
  const VineyardRecordDetailView({
    Key? key,
    required this.vineyard,
    this.vineyardRecord,
  }) : super(key: key);

  @override
  State<VineyardRecordDetailView> createState() => _VineyardRecordDetailViewState();
}

class _VineyardRecordDetailViewState extends State<VineyardRecordDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _sprayNameController = TextEditingController();
  final TextEditingController _amountSprayController = TextEditingController();
  final TextEditingController _amountWaterController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();

  late VineyardModel vineyard;
  late VineyardRecordModel? vineyardRecord;
  late VineyardRecordTypeModel? selectedVineyardRecordType;
  late List<VineyardRecordTypeModel> vineyardRecordTypeList;
  late bool _isInProgress;

  @override
  void initState() {
    vineyardRecordTypeList = appPreferences.getVineyardRecordTypeList() ?? [];
    vineyard = widget.vineyard;
    vineyardRecord = null;
    selectedVineyardRecordType = null;
    _isInProgress = false;

    if (widget.vineyardRecord != null) {
      vineyardRecord = widget.vineyardRecord;
      selectedVineyardRecordType = vineyardRecord!.vineyardRecordType;
      _titleController.text = vineyardRecord!.title ?? "";
      _dateController.text = vineyardRecord!.date.toIso8601String();
      _noteController.text = vineyardRecord!.note ?? "";
      if (vineyardRecord!.vineyardRecordType.id == VineyardRecordType.spraying.getId()) {
        _sprayNameController.text = VineyardRecordSpraying.fromJson(vineyardRecord!.data).sprayName;
        _amountSprayController.text = VineyardRecordSpraying.fromJson(vineyardRecord!.data).amountSpray.toStringAsFixed(1);
        _amountWaterController.text = VineyardRecordSpraying.fromJson(vineyardRecord!.data).amountWater.toStringAsFixed(1);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _dateToController.dispose();
    _noteController.dispose();
    _sprayNameController.dispose();
    _amountSprayController.dispose();
    _amountWaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(vineyardRecord != null ? vineyardRecord!.vineyardRecordType.title : AppLocalizations.of(context)!.addRecord),
            actions: [
              BlocConsumer<VineyardCubit, VineyardState>(
                listener: (context, state) {
                  if (state is VineyardRecordSuccessState) {
                    setState(() {
                      vineyardRecord != null
                          ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastStates.success)
                          : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastStates.success);
                    });
                    Navigator.pop(context);
                  } else if (state is VineyardFailureState) {
                    AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                  }
                },
                builder: (context, state) {
                  if (state is VineyardLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return AppIconButton(
                      iconButtonType: IconButtonType.save,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          String data = "";
                          if (VineyardRecordType.spraying.getId() == selectedVineyardRecordType!.id) {
                            _titleController.text = "";
                            data = VineyardRecordSpraying(
                              sprayName: _sprayNameController.text,
                              amountSpray: double.parse(_amountSprayController.text),
                              amountWater: double.parse(_amountWaterController.text),
                            ).toJson();
                          }
                          if (vineyardRecord != null) {
                            vineyardCubit.updateVineyardRecord(
                              vineyardRecord!.id,
                              selectedVineyardRecordType!.id,
                              appToDateTime(_dateController.text)!,
                              _isInProgress,
                              appToDateTime(_dateToController.text),
                              _titleController.text,
                              data,
                              _noteController.text,
                            );
                          } else {
                            vineyardCubit.createVineyardRecord(
                              vineyard.id,
                              selectedVineyardRecordType!.id,
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
            setIcon: true,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<VineyardRecordTypeModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: vineyardRecordTypeList,
            itemAsString: (VineyardRecordTypeModel wc) => wc.title,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.vineyardRecordType,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (VineyardRecordTypeModel? value) {
              setState(() {
                selectedVineyardRecordType = value;
              });
            },
            selectedItem: selectedVineyardRecordType,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          _sprayingRecord(),
          _otherRecord(),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _noteController,
            label: AppLocalizations.of(context)!.note,
            inputType: InputType.note,
          ),
        ],
      ),
    );
  }

  Widget _sprayingRecord() {
    if (selectedVineyardRecordType != null) {
      return selectedVineyardRecordType!.id == VineyardRecordType.spraying.getId()
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                AppTextFormField(
                  controller: _sprayNameController,
                  label: AppLocalizations.of(context)!.sprayName,
                  isRequired: true,
                  inputType: InputType.title,
                ),
                const SizedBox(height: AppMargin.m20),
                AppContentTitleText(text: AppLocalizations.of(context)!.ratio),
                const SizedBox(height: AppMargin.m10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppTextFormField(
                        controller: _amountSprayController,
                        label: AppLocalizations.of(context)!.spray,
                        isRequired: true,
                        inputType: InputType.number,
                      ),
                    ),
                    const SizedBox(width: AppMargin.m20),
                    const AppContentText(
                      text: "/",
                      size: 25,
                    ),
                    const SizedBox(width: AppMargin.m20),
                    Flexible(
                      child: AppTextFormField(
                        controller: _amountWaterController,
                        label: AppLocalizations.of(context)!.water,
                        isRequired: true,
                        inputType: InputType.number,
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }

  Widget _otherRecord() {
    if (selectedVineyardRecordType != null) {
      return selectedVineyardRecordType!.id == VineyardRecordType.others.getId()
          ? Column(
              children: [
                const SizedBox(height: AppMargin.m20),
                AppTextFormField(
                  controller: _titleController,
                  label: AppLocalizations.of(context)!.title,
                  isRequired: true,
                  inputType: InputType.title,
                ),
                const SizedBox(height: AppMargin.m10),
              ],
            )
          : Container();
    } else {
      return Container();
    }
  }
}
