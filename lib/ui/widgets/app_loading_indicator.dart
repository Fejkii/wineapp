import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double? value;
  final Color? color;
  const AppLoadingIndicator({
    Key? key,
    this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      color: color,
      value: value,
    ));
  }
}
