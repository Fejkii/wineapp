import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/const/app_values.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';
import 'package:wine_app/ui/widgets/app_text_form_field.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldLayout(
      body: _bodyWidget(),
      appBar: AppBar(
        title: const Text(AppStrings.forgetPassword),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        const SizedBox(height: 80),
        _forgetPasswordForm(context),
      ],
    );
  }

  Widget _forgetPasswordForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const AppTitleText(text: AppStrings.resetPasswordTitle),
          const SizedBox(height: AppMargin.m20),
          const AppContentText(text: AppStrings.resetPasswordText),
          const SizedBox(height: AppMargin.m20),
          AppTextFormField(
            controller: _emailController,
            label: AppStrings.email,
            keyboardType: TextInputType.emailAddress,
            isRequired: true,
            inputType: InputType.email,
          ),
          const SizedBox(height: AppMargin.m20),
          StreamBuilder<bool>(
            builder: (context, snapshot) {
              return ElevatedButton(
                  child: Text(
                    AppStrings.resetPasswordButton,
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: () {
                    // TODO: reset password email
                    print("Reset password pressed");
                  });
            },
          ),
        ],
      ),
    );
  }
}
