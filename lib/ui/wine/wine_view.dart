import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineView extends StatefulWidget {
  final WineModel? wine;
  const WineView({
    Key? key,
    this.wine,
  }) : super(key: key);

  @override
  State<WineView> createState() => _WineViewState();
}

class _WineViewState extends State<WineView> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  WineCubit wineCubit = instance<WineCubit>();
  AppPreferences appPreferences = instance<AppPreferences>();
  List<WineVarietyModel> wineVarietyList = [];
  WineVarietyModel? selectedWineVariety;

  @override
  void initState() {
    wineVarietyList = appPreferences.getWineVarietyList() ?? [];
    selectedWineVariety = null;
    if (widget.wine != null) {
      _titleController.text = widget.wine!.title;
      selectedWineVariety = widget.wine!.wineVariety;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Navigator.pop(context, true);
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.wine != null ? widget.wine!.title : AppStrings.createWine),
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
              _form(context),
            ],
          ),
        ),
      ),
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
                decoration: InputDecoration(
                    labelText: AppStrings.title,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.titleEmpty),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineVarietyModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineVarietyList,
            itemAsString: (WineVarietyModel wv) => wv.title,
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: AppStrings.wineVarieties,
                hintText: AppStrings.wineVarietySelect,
              ),
            ),
            onChanged: (WineVarietyModel? value) {
              setState(() {
                selectedWineVariety = value!;
              });
            },
            selectedItem: selectedWineVariety,
            validator: (WineVarietyModel? i) {
              if (i == null) return 'required filed';
              return null;
            },
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<WineCubit, WineState>(
            listener: (context, state) {
              if (state is WineSuccessState) {
                setState(() {
                  widget.wine != null
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
                      widget.wine != null
                          ? wineCubit.updateWine(widget.wine!.id, selectedWineVariety!.id, _titleController.text)
                          : wineCubit.createWine(_titleController.text, selectedWineVariety!.id);
                    }
                  },
                  child: Text(
                    widget.wine != null ? AppStrings.update : AppStrings.create,
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
