import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  const AppTitleText({
    required this.text,
    Key? key,
    this.size = 22,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class AppContentTitleText extends StatelessWidget {
  final String text;
  final double size;
  const AppContentTitleText({
    Key? key,
    required this.text,
    this.size = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AppContentText extends StatelessWidget {
  final String text;
  final double size;
  const AppContentText({
    Key? key,
    required this.text,
    this.size = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}

class AppTextWithValue extends StatelessWidget {
  final String text;
  final dynamic value;
  final bool? separator;
  final String? unit;
  const AppTextWithValue({
    Key? key,
    required this.text,
    required this.value,
    this.unit,
    this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String content;
    content = unit != null ? "${value.toString()} $unit" : value.toString();
    return Row(
      children: [
        AppContentText(text: text),
        separator == false ? Container() : const AppContentText(text: ": "),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
