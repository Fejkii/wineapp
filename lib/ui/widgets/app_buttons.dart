import 'package:flutter/material.dart';

enum ButtonType {
  logout,
  add,
}

class AppButton extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final ButtonType? buttonType;
  const AppButton({
    Key? key,
    required this.title,
    required this.onTap,
    this.buttonType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonType == ButtonType.logout) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout),
        label: Text(
          title,
        ),
      );
    }

    if (buttonType == ButtonType.add) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add),
        label: Text(
          title,
        ),
      );
    }

    return ElevatedButton(
      onPressed: onTap,
      child: Text(
        title,
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

enum IconButtonType {
  save,
  edit,
}

class AppIconButton extends StatelessWidget {
  final IconButtonType iconButtonType;
  final Function() onPress;
  const AppIconButton({
    Key? key,
    required this.iconButtonType,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = Icons.image;
    switch (iconButtonType) {
      case IconButtonType.save:
        icon = Icons.save;
        break;
      case IconButtonType.edit:
        icon = Icons.edit;
        break;
      default:
        break;
    }
    return IconButton(
      onPressed: onPress,
      icon: Icon(icon),
    );
  }
}
