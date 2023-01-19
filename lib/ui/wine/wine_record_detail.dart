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
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineRecordDetailView extends StatefulWidget {
  final int wineEvidenceId;
  final WineRecordModel? wineRecord;
  const WineRecordDetailView({
    Key? key,
    required this.wineEvidenceId,
    this.wineRecord,
  }) : super(key: key);

  @override
  State<WineRecordDetailView> createState() => _WineRecordDetailViewState();
}

class _WineRecordDetailViewState extends State<WineRecordDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AppPreferences appPreferences = instance<AppPreferences>();
  WineCubit wineCubit = instance<WineCubit>();
  late int wineEvidenceId;
  late WineRecordModel? wineRecord;
  late WineRecordTypeModel? selectedWineRecordType;
  late List<WineRecordTypeModel> wineRecordTypeList;

  @override
  void initState() {
    wineRecordTypeList = appPreferences.getWineRecordTypeList() ?? [];
    wineEvidenceId = widget.wineEvidenceId;
    wineRecord = null;
    selectedWineRecordType = null;
    if (widget.wineRecord != null) {
      wineRecord = widget.wineRecord;
      selectedWineRecordType = wineRecord!.wineRecordType;
      _titleController.text = wineRecord!.title;
      _dateController.text = wineRecord!.date.toIso8601String();
      _noteController.text = wineRecord!.note;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(wineRecord != null ? wineRecord!.title : AppStrings.addRecord),
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
                                  _titleController.text,
                                  DateTime.parse(_dateController.text),
                                  _noteController.text,
                                )
                              : wineCubit.createWineRecord(
                                  wineEvidenceId,
                                  selectedWineRecordType!.id,
                                  _titleController.text,
                                  DateTime.parse(_dateController.text),
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
                selectedWineRecordType = value!;
              });
            },
            selectedItem: selectedWineRecordType,
            clearButtonProps: const ClearButtonProps(isVisible: true),
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _titleController,
            label: AppStrings.title,
            isRequired: true,
            inputType: InputType.title,
          ),
          const SizedBox(height: AppMargin.m20),
          AppDatePicker(
            controller: _dateController,
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
