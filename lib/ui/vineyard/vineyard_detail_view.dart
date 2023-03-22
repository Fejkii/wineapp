import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/vineyard_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class VineyardDetailView extends StatefulWidget {
  final VineyardModel? vineyard;
  const VineyardDetailView({
    Key? key,
    this.vineyard,
  }) : super(key: key);

  @override
  State<VineyardDetailView> createState() => _VineyardDetailViewState();
}

class _VineyardDetailViewState extends State<VineyardDetailView> {
  final TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final VineyardCubit vineyardCubit = instance<VineyardCubit>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  late VineyardModel? vineyard;

  @override
  void initState() {
    vineyard = widget.vineyard;
    if (vineyard != null) {
      _titleController.text = vineyard!.title;
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
    return BlocBuilder<VineyardCubit, VineyardState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
          appBar: AppBar(
            title: Text(vineyard != null ? vineyard!.title : AppLocalizations.of(context)!.createVineyard),
            actions: [
              BlocConsumer<VineyardCubit, VineyardState>(
                listener: (context, state) {
                  if (state is VineyardSuccessState) {
                    setState(() {
                      vineyard != null
                          ? AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastStates.success)
                          : AppToastMessage().showToastMsg(AppLocalizations.of(context)!.createdSuccessfully, ToastStates.success);
                    });
                  } else if (state is VineyardFailureState) {
                    AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                  }
                },
                builder: (context, state) {
                  if (state is VineyardLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return AppIconButton(
                      iconButtonType: IconButtonType.save,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          vineyard != null
                              ? vineyardCubit.updateVineyard(
                                  vineyard!.id,
                                  _titleController.text,
                                )
                              : vineyardCubit.createVineyard(
                                  _titleController.text,
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
      ],
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
            isRequired: true,
          ),
        ],
      ),
    );
  }
}
