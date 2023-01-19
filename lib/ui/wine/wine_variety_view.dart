import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class WineVarietyView extends StatefulWidget {
  final WineVarietyModel? wineVariety;
  const WineVarietyView({
    Key? key,
    this.wineVariety,
  }) : super(key: key);

  @override
  State<WineVarietyView> createState() => _WineVarietyViewState();
}

class _WineVarietyViewState extends State<WineVarietyView> {
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Text(widget.wineVariety != null ? widget.wineVariety!.title : AppStrings.createWineVariety),
              actions: [
                BlocConsumer<WineCubit, WineState>(
                  listener: (context, state) {
                    if (state is WineSuccessState) {
                      setState(() {
                        widget.wineVariety != null
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
          const SizedBox(height: 10),
          AppTextFormField(
            controller: _titleController,
            isRequired: true,
            label: AppStrings.title,
          ),
          const SizedBox(height: 20),
          AppTextFormField(
            controller: _codeController,
            isRequired: true,
            label: AppStrings.code,
          ),
          const SizedBox(height: AppMargin.m20),
        ],
      ),
    );
  }
}
