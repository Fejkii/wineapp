import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class VineyardView extends StatefulWidget {
  const VineyardView({Key? key}) : super(key: key);

  @override
  State<VineyardView> createState() => _VineyardViewState();
}

class _VineyardViewState extends State<VineyardView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldLayout(
      body: _bodyWidget(),
      hasSidebar: true,
      appBar: AppBar(
        title: const Text(AppStrings.vineyards),
      ),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: const [
        Center(child: Text(AppStrings.vineyards)),
      ],
    );
  }
}
