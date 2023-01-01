import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/widgets/app_sidebar.dart';

class WineView extends StatefulWidget {
  const WineView({Key? key}) : super(key: key);

  @override
  State<WineView> createState() => _WineViewState();
}

class _WineViewState extends State<WineView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppSidebar(),
      appBar: AppBar(),
      body: Column(
        children: const [
          Center(child: Text(AppStrings.wines)),
        ],
      ),
    );
  }
}