import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
import 'package:wine_app/ui/widgets/app_toast_messages.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AuthCubit authCubit = instance<AuthCubit>();

  @override
  void initState() {
    _emailController.text = "petr@test.cz";
    _passwordController.text = "password";
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AppScaffoldLayout(
          body: _bodyWidget(),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        const SizedBox(height: 80),
        _logo(),
        const SizedBox(height: 80),
        _loginForm(context),
      ],
    );
  }

  Widget _logo() {
    return Column(
      children: const [
        Icon(Icons.wine_bar, size: 80),
        SizedBox(height: 10),
        AppTitleText(text: AppStrings.appName),
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppTextFormField(
            controller: _emailController,
            label: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _passwordController,
            label: AppStrings.password,
            isRequired: true,
            inputType: InputType.password,
          ),
          const SizedBox(height: AppMargin.m20),
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                if (state.hasUserProject) {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.createProjectRoute, (route) => false);
                }
              } else if (state is LoginFailureState) {
                AppToastMessage().showToastMsg(state.errorMessage, ToastStates.error);
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const AppLoadingIndicator();
              } else {
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authCubit.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  child: Text(
                    AppStrings.login,
                    style: Theme.of(context).textTheme.button,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: AppMargin.m20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextButton(
                title: AppStrings.forgetPassword,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.forgetPasswordRoute);
                },
              ),
              AppTextButton(
                title: AppStrings.register,
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.registerRoute);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
