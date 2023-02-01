import 'package:flutter/material.dart';

AppBar myAppBar({
  String? title,
  Widget? leading,
  List<Widget>? actions,
}) {
  return AppBar(
    title: title != null ? Text(title) : null,
    leading: leading,
    actions: actions,
  );
}
