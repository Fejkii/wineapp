import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class WineVarietyDetailView extends StatefulWidget {
  final WineVarietyModel? wineVariety;
  const WineVarietyDetailView({
    Key? key,
    this.wineVariety,
  }) : super(key: key);

  @override
  State<WineVarietyDetailView> createState() => _WineVarietyDetailViewState();
}

class _WineVarietyDetailViewState extends State<WineVarietyDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  WineCubit wineCubit = instance<WineCubit>();

  @override
  void initState() {
    if (widget.wineVariety != null) {
      _titleController.text = widget.wineVariety!.title;
      _codeController.text = widget.wineVariety!.code;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineCubit, WineState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _form(context),
          appBar: AppBar(
            title: Text(widget.wineVariety != null ? widget.wineVariety!.title : AppLocalizations.of(context)!.createWineVariety),
            actions: [
              BlocConsumer<WineCubit, WineState>(
                listener: (context, state) {
                  if (state is WineVarietySuccessState) {
                    setState(() {
                      widget.wineVariety != null
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
                          widget.wineVariety != null
                              ? wineCubit.updateWineVariety(widget.wineVariety!.id, _titleController.text, _codeController.text)
                              : wineCubit.createWineVariety(_titleController.text, _codeController.text);
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
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _titleController,
            isRequired: true,
            label: AppLocalizations.of(context)!.title,
          ),
          const SizedBox(height: 20),
          AppTextFormField(
            controller: _codeController,
            isRequired: true,
            label: AppLocalizations.of(context)!.code,
          ),
          const SizedBox(height: AppMargin.m20),
        ],
      ),
    );
  }
}
