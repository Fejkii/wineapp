import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/wine_model.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
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
                style: TextStyle(color: AppColors.black),
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
          const SizedBox(height: 20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                keyboardType: TextInputType.text,
                controller: _codeController,
                style: TextStyle(color: AppColors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.inputEmpty;
                  }
                  return null;
                },
                decoration: InputDecoration(
                    labelText: AppStrings.code,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.titleEmpty),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<WineCubit, WineState>(
            listener: (context, state) {
              if (state is WineVarietySuccessState) {
                setState(() {
                  widget.wineVariety != null
                      ? AppToastMessage().showToastMsg(AppStrings.createdSuccessfully, ToastStates.success)
                      : AppToastMessage().showToastMsg(AppStrings.updatedSuccessfully, ToastStates.success);
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
                      widget.wineVariety != null
                          ? wineCubit.updateWineVariety(widget.wineVariety!.id, _titleController.text, _codeController.text)
                          : wineCubit.createWineVariety(_titleController.text, _codeController.text);
                    }
                  },
                  child: Text(
                    widget.wineVariety != null ? AppStrings.update : AppStrings.create,
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
