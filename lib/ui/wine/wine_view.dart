import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';

class WineView extends StatefulWidget {
  const WineView({Key? key}) : super(key: key);

  @override
  State<WineView> createState() => _WineViewState();
}

class _WineViewState extends State<WineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Center(child: Text(AppStrings.wines)),
        ],
      ),
    );
  }
}
