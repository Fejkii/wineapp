import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController = TextEditingController();
  late AuthCubit authCubit = instance<AuthCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldLayout(
      body: _registerForm(context),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.registration),
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: AppMargin.m10),
          AppTextFormField(
            controller: _nameController,
            label: AppLocalizations.of(context)!.name,
            isRequired: true,
            icon: Icons.text_fields_outlined,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _emailController,
            label: AppLocalizations.of(context)!.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _passwordController,
            label: AppLocalizations.of(context)!.password,
            isRequired: true,
            inputType: InputType.password,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _passwordConfirmController,
            label: AppLocalizations.of(context)!.passwordConfirmation,
            isRequired: true,
            inputType: InputType.password,
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProjectRoute, (route) => false);
              } else if (state is LoginFailureState) {
                AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return AppButton(
                  title: AppLocalizations.of(context)!.register,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      authCubit.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
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
  }
}
