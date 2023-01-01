import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/theme/app_colors.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

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
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                style: TextStyle(color: AppColors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    labelText: AppStrings.passwordAgain,
                    border: const OutlineInputBorder(),
                    errorText: (snapshot.data ?? true) ? null : AppStrings.passwordError),
              );
            },
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return ElevatedButton(
                  child: Text(
                    AppStrings.register,
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    print("Sign up pressed");
                  });
            },
          ),
        ],
      ),
    );
  }
}
