import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  const AppTitleText({
    required this.text,
    Key? key,
    this.size = 25,
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
    this.size = 16,
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
    this.size = 16,
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
