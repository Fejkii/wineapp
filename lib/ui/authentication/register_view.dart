import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/login/auth_cubit.dart';
import 'package:wine_app/const/app_routes.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/widgets/app_loading_indicator.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: _getContentWidget(),
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.all(AppPadding.p20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            _registerForm(context),
          ],
        ),
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
        children: <Widget>[
          const AppTitleText(text: AppStrings.register),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.text_fields_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppStrings.name,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.emailError),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppStrings.email,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.emailError),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppStrings.password,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.passwordError),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return TextFormField(
                controller: _passwordConfirmController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppStrings.passwordConfirmation,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.passwordError),
              );
            },
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
                return ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authCubit.register(
                        _nameController.text,
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  child: Text(
                    AppStrings.register,
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
