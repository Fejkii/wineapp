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
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
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
  List<WineModel> wineList = [];
  WineClassificationModel? selectedWineClassification;
  WineModel? selectedWine;
  WineEvidenceModel? wineEvidence;

  @override
  void initState() {
    wineClassificationList = appPreferences.getWineClassificationList() ?? [];
    selectedWineClassification = null;
    wineEvidence = null;
    if (widget.wineEvidence != null) {
      wineEvidence = widget.wineEvidence;
      _titleController.text = wineEvidence!.title;
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
          Text(wineEvidence!.updatedAt != null ? "${AppStrings.updated}: ${wineEvidence!.updatedAt.toString()}" : ""),
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
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.text,
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.titleEmpty;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: AppStrings.title,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineClassificationModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineClassificationList,
            itemAsString: (WineClassificationModel wc) => wc.title,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: AppStrings.wineClassification,
                hintText: AppStrings.wineClassificationSelect,
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
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _volumeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.inputEmpty;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: AppStrings.volume,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _yearController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.inputEmpty;
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: AppStrings.year,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _alcoholController,
                decoration: const InputDecoration(
                  labelText: AppStrings.alcohol,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _acidController,
                decoration: const InputDecoration(
                  labelText: AppStrings.acid,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.number,
                controller: _sugarController,
                decoration: const InputDecoration(
                  labelText: AppStrings.sugar,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.text,
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: AppStrings.note,
                  border: OutlineInputBorder(),
                ),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
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
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      wineEvidence != null
                          ? wineCubit.updateWineEvidence(
                              wineEvidence!.id,
                              wineEvidence!.wine.id,
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
                              1,
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
                  child: Text(
                    wineEvidence != null ? AppStrings.update : AppStrings.create,
                    style: Theme.of(context).textTheme.button,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
