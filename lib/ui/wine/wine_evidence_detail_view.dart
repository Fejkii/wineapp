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
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineEvidenceDetailView extends StatefulWidget {
  final WineEvidenceModel? wineEvidence;
  const WineEvidenceDetailView({
    Key? key,
    this.wineEvidence,
  }) : super(key: key);

  @override
  State<WineEvidenceDetailView> createState() => _WineEvidenceDetailViewState();
}

class _WineEvidenceDetailViewState extends State<WineEvidenceDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _volumeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _alcoholController = TextEditingController();
  final TextEditingController _acidController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  WineCubit wineCubit = instance<WineCubit>();
  AppPreferences appPreferences = instance<AppPreferences>();
  List<WineClassificationModel> wineClassificationList = [];
  List<WineBaseModel> wineList = [];
  WineClassificationModel? selectedWineClassification;
  late List<WineBaseModel> selectedWines;
  WineEvidenceModel? wineEvidence;

  @override
  void initState() {
    wineClassificationList = appPreferences.getWineClassificationList() ?? [];
    wineList = appPreferences.getWineBaseList() ?? [];
    selectedWines = [];
    selectedWineClassification = null;
    wineEvidence = null;

    if (widget.wineEvidence != null) {
      wineEvidence = widget.wineEvidence;
      _titleController.text = wineEvidence!.title;
      if (wineEvidence!.wines.isNotEmpty) {
        for (var element in wineEvidence!.wines) {
          selectedWines.add(element.wine);
        }
      }
      selectedWineClassification = wineEvidence!.wineClassification;
      _volumeController.text = wineEvidence!.volume.toString();
      _yearController.text = wineEvidence!.year.toString();
      _alcoholController.text = wineEvidence!.alcohol.toString();
      _acidController.text = wineEvidence!.acid.toString();
      _sugarController.text = wineEvidence!.sugar.toString();
      _noteController.text = wineEvidence!.note ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _volumeController.dispose();
    _yearController.dispose();
    _alcoholController.dispose();
    _acidController.dispose();
    _sugarController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
          appBar: AppBar(
            title: Text(wineEvidence != null ? wineEvidence!.title : AppLocalizations.of(context)!.createWine),
            actions: [
              BlocConsumer<WineCubit, WineState>(
                listener: (context, state) {
                  if (state is WineEvidenceSuccessState) {
                    setState(() {
                      wineEvidence != null
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
                          wineEvidence != null
                              ? wineCubit.updateWineEvidence(
                                  wineEvidence!.id,
                                  selectedWines,
                                  selectedWineClassification != null ? selectedWineClassification!.id : null,
                                  _titleController.text,
                                  double.parse(_volumeController.text),
                                  int.parse(_yearController.text),
                                  double.tryParse(_alcoholController.text),
                                  double.tryParse(_acidController.text),
                                  double.tryParse(_sugarController.text),
                                  _noteController.text,
                                )
                              : wineCubit.createWineEvidence(
                                  selectedWines,
                                  selectedWineClassification != null ? selectedWineClassification!.id : null,
                                  _titleController.text,
                                  double.parse(_volumeController.text),
                                  int.parse(_yearController.text),
                                  double.tryParse(_alcoholController.text),
                                  double.tryParse(_acidController.text),
                                  double.tryParse(_sugarController.text),
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

  Widget _bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppMargin.m10),
        _form(context),
        const SizedBox(height: AppMargin.m20),
        _otherInfo(),
        const SizedBox(height: AppMargin.m20),
      ],
    );
  }

  Widget _otherInfo() {
    if (wineEvidence != null) {
      return Column(
        children: [
          Text("${AppLocalizations.of(context)!.created}: ${appFormatDateTime(wineEvidence!.createdAt)}"),
          Text(wineEvidence!.updatedAt != null
              ? "${AppLocalizations.of(context)!.updated}: ${appFormatDateTime(wineEvidence!.updatedAt!)}"
              : AppConstant.EMPTY),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _form(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AppTextFormField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.title,
            isRequired: true,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineBaseModel>.multiSelection(
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              interceptCallBacks: true,
              showSearchBox: true,
            ),
            items: wineList,
            itemAsString: (WineBaseModel wine) => wine.title,
            compareFn: (item, selectedItem) => item.id == selectedItem.id,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.wines,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (List<WineBaseModel> wines) {
              setState(() {
                selectedWines = wines;
              });
            },
            selectedItems: selectedWines,
            validator: (List<WineBaseModel>? item) {
              if (item == null) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineClassificationModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineClassificationList,
            itemAsString: (WineClassificationModel wineClassification) => wineClassification.title,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                labelText: AppLocalizations.of(context)!.wineClassification,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (WineClassificationModel? wineClassification) {
              setState(() {
                selectedWineClassification = wineClassification!;
              });
            },
            selectedItem: selectedWineClassification,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _volumeController,
            label: AppLocalizations.of(context)!.wineQuantity,
            isRequired: true,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits().liter(_volumeController, context),
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _yearController,
            label: AppLocalizations.of(context)!.year,
            isRequired: true,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _alcoholController,
            label: AppLocalizations.of(context)!.alcohol,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.percent,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _acidController,
            label: AppLocalizations.of(context)!.acid,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.gramPerOneLiter,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _sugarController,
            label: AppLocalizations.of(context)!.sugar,
            inputType: InputType.double,
            keyboardType: TextInputType.number,
            unit: AppUnits.gramPerOneLiter,
          ),
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
}
