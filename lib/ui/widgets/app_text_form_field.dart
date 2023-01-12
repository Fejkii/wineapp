import 'package:flutter/material.dart';

import 'package:wine_app/app/app_functions.dart';
import 'package:wine_app/const/app_strings.dart';

enum InputType {
  email,
  password,
  title,
  note,
}

class AppTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  // if inputType is entered, the input value is validated by the inputType
  // if inputType is entered, icon for textField is set by the inputType;
  // icon attribute can override this icon
  final InputType? inputType;
  final bool? isRequired;
  final String? errorMessage;
  final IconData? icon;

  const AppTextFormField({
    Key? key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.inputType,
    this.isRequired = false,
    this.errorMessage,
    this.icon,
  }) : super(key: key);

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  late bool _obscured = true;

  Widget? showPasswordIcon() {
    if (widget.inputType == InputType.password) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
        child: GestureDetector(
          onTap: _toggleObscured,
          child: Icon(
            _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
            size: 24,
          ),
        ),
      );
    }
    return null;
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    IconData? iconData;
    if (widget.icon != null) {
      iconData = widget.icon;
    } else {
      switch (widget.inputType) {
        case InputType.email:
          iconData = Icons.email;
          break;
        case InputType.password:
          iconData = Icons.lock;
          break;
        case InputType.title:
          iconData = Icons.title;
          break;
        default:
          break;
      }
    }

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: widget.inputType == InputType.password ? _obscured : false,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        prefixIcon: iconData != null ? Icon(iconData) : null,
        isDense: true,
        suffixIcon: showPasswordIcon(),
      ),
      maxLines: widget.inputType == InputType.note ? 3 : 1,
      validator: (value) {
        if (widget.isRequired == true) {
          if (value == null || value.isEmpty) {
            return widget.errorMessage ?? AppStrings.inputEmpty;
          }
        }
        switch (widget.inputType) {
          case InputType.email:
            if (value != null && value.isNotEmpty && !isEmailValid(value)) {
              return AppStrings.emailError;
            }
            break;
          case InputType.password:
            if (value != null && value.isNotEmpty && !isPasswordValid(value)) {
              return AppStrings.passwordError;
            }
            break;
          case InputType.title:
            if (value != null && value.isNotEmpty && !isTitleValid(value)) {
              return AppStrings.titleError;
            }
            break;
          default:
            return null;
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
