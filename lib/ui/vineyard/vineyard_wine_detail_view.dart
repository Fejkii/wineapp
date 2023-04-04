// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard_wine/vineyard_wine_cubit.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardWineDetailView extends StatefulWidget {
  final int vineyardId;
  final VineyardWineModel? vineyardWine;
  const VineyardWineDetailView({
    Key? key,
    required this.vineyardId,
    this.vineyardWine,
  }) : super(key: key);

  @override
  State<VineyardWineDetailView> createState() => _VineyardWineDetailViewState();
}

class _VineyardWineDetailViewState extends State<VineyardWineDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  final VineyardWineCubit vineyardWineCubit = instance<VineyardWineCubit>();

  late int vineyardId;
  late VineyardWineModel? vineyardWine;
  late WineBaseModel? selectedWine;
  late List<WineBaseModel> wineList;

  @override
  void initState() {
    wineList = appPreferences.getWineBaseList() ?? [];
    vineyardId = widget.vineyardId;
    selectedWine = null;
    vineyardWine = null;
    if (widget.vineyardWine != null) {
      vineyardWine = widget.vineyardWine!;
      selectedWine = vineyardWine!.wine;
      _titleController.text = vineyardWine!.title;
      _quantityController.text = vineyardWine!.quantity.toString();
      _noteController.text = vineyardWine!.note ?? "";
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VineyardWineCubit, VineyardWineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(vineyardWine != null ? vineyardWine!.title : AppLocalizations.of(context)!.addRecord),
            actions: [
              BlocConsumer<VineyardWineCubit, VineyardWineState>(
                listener: (context, state) {
                  if (state is VineyardWineSuccessState) {
                    setState(() {
                      vineyardWine != null
                          ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastStates.success)
                          : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastStates.success);
                    });
                    Navigator.pop(context);
                  } else if (state is VineyardWineFailureState) {
                    AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                  }
                },
                builder: (context, state) {
                  if (state is VineyardWineLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return AppIconButton(
                      iconButtonType: IconButtonType.save,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          vineyardWine != null
                              ? vineyardWineCubit.updateVineyardWine(
                                  vineyardWine!.id,
                                  selectedWine!.id,
                                  _titleController.text != "" ? _titleController.text : selectedWine!.title,
                                  int.parse(_quantityController.text),
                                  _noteController.text,
                                )
                              : vineyardWineCubit.createVineyardWine(
                                  vineyardId,
                                  selectedWine!.id,
                                  _titleController.text != "" ? _titleController.text : selectedWine!.title,
                                  int.parse(_quantityController.text),
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
          DropdownSearch<WineBaseModel>(
            popupProps: const PopupProps.menu(showSelectedItems: false, showSearchBox: true),
            items: wineList,
            itemAsString: (WineBaseModel wc) => wc.title,
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(10),
                labelText: AppLocalizations.of(context)!.wine,
                hintText: AppLocalizations.of(context)!.selectInSelectBox,
              ),
            ),
            onChanged: (WineBaseModel? value) {
              setState(() {
                selectedWine = value;
              });
            },
            selectedItem: selectedWine,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _titleController,
            label: AppLocalizations.of(context)!.title,
            inputType: InputType.title,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _quantityController,
            label: AppLocalizations.of(context)!.vineyardWineQuantity,
            inputType: InputType.number,
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
