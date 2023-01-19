import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineEvidenceView extends StatefulWidget {
  final WineEvidenceModel? wineEvidence;
  const WineEvidenceView({
    Key? key,
    this.wineEvidence,
  }) : super(key: key);

  @override
  State<WineEvidenceView> createState() => _WineEvidenceViewState();
}

class _WineEvidenceViewState extends State<WineEvidenceView> {
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
  WineBaseModel? selectedWine;
  WineEvidenceModel? wineEvidence;

  @override
  void initState() {
    wineClassificationList = appPreferences.getWineClassificationList() ?? [];
    wineList = appPreferences.getWineList() ?? [];
    selectedWine = null;
    selectedWineClassification = null;
    wineEvidence = null;
    if (widget.wineEvidence != null) {
      wineEvidence = widget.wineEvidence;
      _titleController.text = wineEvidence!.title;
      selectedWine = wineEvidence!.wine;
      selectedWineClassification = wineEvidence!.wineClassification;
      _volumeController.text = wineEvidence!.volume.toString();
      _yearController.text = wineEvidence!.year.toString();
      _alcoholController.text = wineEvidence!.alcohol.toString();
      _acidController.text = wineEvidence!.acid.toString();
      _sugarController.text = wineEvidence!.sugar.toString();
      _noteController.text = wineEvidence!.note;
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(wineEvidence != null ? wineEvidence!.title : AppStrings.createWine),
              actions: [
                BlocConsumer<WineCubit, WineState>(
                  listener: (context, state) {
                    if (state is WineEvidenceSuccessState) {
                      setState(() {
                        wineEvidence != null
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
                            wineEvidence != null
                                ? wineCubit.updateWineEvidence(
                                    wineEvidence!.id,
                                    selectedWine!.id,
                                    selectedWineClassification!.id,
                                    _titleController.text,
                                    double.parse(_volumeController.text),
                                    int.parse(_yearController.text),
                                    double.parse(_alcoholController.text),
                                    double.parse(_acidController.text),
                                    double.parse(_sugarController.text),
                                    _noteController.text,
                                  )
                                : wineCubit.createWineEvidence(
                                    selectedWine!.id,
                                    selectedWineClassification!.id,
                                    _titleController.text,
                                    double.parse(_volumeController.text),
                                    int.parse(_yearController.text),
                                    double.parse(_alcoholController.text),
                                    double.parse(_acidController.text),
                                    double.parse(_sugarController.text),
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
              _form(context),
              const SizedBox(height: AppMargin.m20),
              _otherInfo(),
              const SizedBox(height: AppMargin.m20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otherInfo() {
    if (wineEvidence != null) {
      return Column(
        children: [
          Text("${AppStrings.created}: ${appFormatDate(wineEvidence!.createdAt)}"),
          Text(wineEvidence!.updatedAt != null ? "${AppStrings.updated}: ${appFormatDate(wineEvidence!.updatedAt!)}" : ""),
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
            label: AppStrings.title,
            isRequired: true,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineBaseModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineList,
            itemAsString: (WineBaseModel wc) => wc.title,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: AppStrings.wines,
                hintText: AppStrings.selectInSelectBox,
              ),
            ),
            onChanged: (WineBaseModel? value) {
              setState(() {
                selectedWine = value!;
              });
            },
            selectedItem: selectedWine,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          DropdownSearch<WineClassificationModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineClassificationList,
            itemAsString: (WineClassificationModel wc) => wc.title,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: AppStrings.wineClassification,
                hintText: AppStrings.selectInSelectBox,
              ),
            ),
            onChanged: (WineClassificationModel? value) {
              setState(() {
                selectedWineClassification = value!;
              });
            },
            selectedItem: selectedWineClassification,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _volumeController,
            label: AppStrings.volume,
            isRequired: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _yearController,
            label: AppStrings.year,
            isRequired: true,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _alcoholController,
            label: AppStrings.alcohol,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _acidController,
            label: AppStrings.acid,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _sugarController,
            label: AppStrings.sugar,
            keyboardType: TextInputType.number,
          ),
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
}
