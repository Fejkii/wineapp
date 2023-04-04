import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class WineDetailView extends StatefulWidget {
  final WineModel? wine;
  const WineDetailView({
    Key? key,
    this.wine,
  }) : super(key: key);

  @override
  State<WineDetailView> createState() => _WineDetailViewState();
}

class _WineDetailViewState extends State<WineDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  WineCubit wineCubit = instance<WineCubit>();
  AppPreferences appPreferences = instance<AppPreferences>();
  late List<WineVarietyModel> wineVarietyList;
  late WineVarietyModel? selectedWineVariety;

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
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(widget.wine != null ? widget.wine!.title : AppLocalizations.of(context)!.createWine),
            actions: [
              BlocConsumer<WineCubit, WineState>(
                listener: (context, state) {
                  if (state is WineSuccessState) {
                    setState(() {
                      widget.wine != null
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
                      onPress: (() {
                        if (_formKey.currentState!.validate()) {
                          widget.wine != null
                              ? wineCubit.updateWine(widget.wine!.id, selectedWineVariety!.id, _titleController.text)
                              : wineCubit.createWine(_titleController.text, selectedWineVariety!.id);
                        }
                      }),
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
          AppTextFormField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.title,
            inputType: InputType.title,
            isRequired: true,
            icon: Icons.abc,
          ),
          const SizedBox(height: AppMargin.m20),
          DropdownSearch<WineVarietyModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineVarietyList,
            itemAsString: (WineVarietyModel wv) => wv.title,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                labelText: AppLocalizations.of(context)!.wineVarieties,
                hintText: AppLocalizations.of(context)!.wineVarietySelect,
              ),
            ),
            onChanged: (WineVarietyModel? value) {
              setState(() {
                selectedWineVariety = value;
              });
            },
            selectedItem: selectedWineVariety,
            validator: (WineVarietyModel? wineVariety) {
              if (wineVariety == null) return AppLocalizations.of(context)!.inputEmpty;
              return null;
            },
            clearButtonProps: const ClearButtonProps(isVisible: true),
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
