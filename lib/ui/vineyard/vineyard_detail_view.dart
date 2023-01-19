import 'package:flutter/material.dart';
import 'package:wine_app/ui/widgets/app_scaffold_layout.dart';

class VineyardDetailView extends StatefulWidget {
  const VineyardDetailView({Key? key}) : super(key: key);

  @override
  State<VineyardDetailView> createState() => _VineyardDetailViewState();
}

class _VineyardDetailViewState extends State<VineyardDetailView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffoldLayout(
      body: _bodyWidget(),
      appBar: AppBar(),
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: const [
        Center(child: Text("Vineyard detail")),
      ],
    );
  }
}
