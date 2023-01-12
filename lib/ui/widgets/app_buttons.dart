import 'package:flutter/material.dart';

class AppLoginButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const AppLoginButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        title,
        style: Theme.of(context).textTheme.button,
      ),
    );
  }
}

class AppTextButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  const AppTextButton({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(title),
    );
  }
}

class AppSaveIconButton extends StatelessWidget {
  final Function() onPress;
  const AppSaveIconButton({
    Key? key,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPress,
      icon: const Icon(Icons.save),
    );
  }
}
