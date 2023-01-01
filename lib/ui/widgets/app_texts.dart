import 'package:flutter/material.dart';

class AppTitleText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const AppTitleText({
    required this.text,
    Key? key,
    this.size = 30,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AppContentTitleText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const AppContentTitleText({
    Key? key,
    required this.text,
    this.size = 16,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class AppContentText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  const AppContentText({
    Key? key,
    required this.text,
    this.size = 16,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
