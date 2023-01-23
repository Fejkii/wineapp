import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';

import 'package:wine_app/ui/widgets/app_buttons.dart';
import 'package:wine_app/ui/widgets/app_texts.dart';

class AppModalDialog extends StatefulWidget {
  final String title;
  final String content;
  final Function() onTap;
  const AppModalDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AppModalDialog> createState() => _AppModalDialogState();
}

class _AppModalDialogState extends State<AppModalDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: AppTitleText(text: widget.title),
      content: AppContentText(text: widget.content),
      actions: [
        AppTextButton(
          title: AppStrings.cancel,
          onTap: () {
            Navigator.pop(context);
          },
        ),
        AppTextButton(title: AppStrings.ok, onTap: widget.onTap),
      ],
    );
  }
}
