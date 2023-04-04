import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/user/user_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/model/base/user_model.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class UserDetailView extends StatefulWidget {
  const UserDetailView({super.key});

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final UserCubit userCubit = instance<UserCubit>();
  final AppPreferences appPreferences = instance<AppPreferences>();
  late UserModel user;

  @override
  void initState() {
    user = appPreferences.getUser()!;
    _nameController.text = user.name;
    _emailController.text = user.email;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _body(),
          appBar: AppBar(
            title: Text(user.name),
            actions: [
              BlocConsumer<UserCubit, UserState>(
                listener: (context, state) {
                  if (state is UpdateUserSuccessState) {
                    appPreferences.setUser(state.user);
                    AppToastMessage().showToastMsg(AppLocalizations.of(context)!.updatedSuccessfully, ToastStates.success);
                  } else if (state is UserFailureState) {
                    AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
                  }
                },
                builder: (context, state) {
                  if (state is UserLoadingState) {
                    return const AppLoadingIndicator();
                  } else {
                    return AppIconButton(
                      iconButtonType: IconButtonType.save,
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          userCubit.updateUser(_nameController.text, _emailController.text);
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

  Widget _body() {
    return Column(
      children: [
        _form(context),
        const SizedBox(height: AppPadding.p20),
        _otherInfo(),
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
            controller: _nameController,
            label: AppLocalizations.of(context)!.name,
            isRequired: true,
            inputType: InputType.title,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            inputType: InputType.email,
          ),
        ],
      ),
    );
  }

  Widget _otherInfo() {
    return Table(
      children: [
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.created)),
          TableCell(child: Text(appFormatDateTime(user.createdAt, dateOnly: true))),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.updated)),
          TableCell(child: Text(user.updatedAt != null ? appFormatDateTime(user.updatedAt!, dateOnly: true) : AppConstant.EMPTY)),
        ]),
        TableRow(children: [
          TableCell(child: Text(AppLocalizations.of(context)!.emailVerification)),
          TableCell(
              child: Text(user.emailVarificationAt != null
                  ? appFormatDateTime(user.emailVarificationAt!, dateOnly: true)
                  : AppLocalizations.of(context)!.emailNotVerification)),
        ]),
      ],
    );
  }
}
