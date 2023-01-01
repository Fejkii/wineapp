import 'package:flutter/material.dart';

class VineyardDetailView extends StatefulWidget {
  const VineyardDetailView({Key? key}) : super(key: key);

  @override
  State<VineyardDetailView> createState() => _VineyardDetailViewState();
}

class _VineyardDetailViewState extends State<VineyardDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: const [
          Center(child: Text("Vineyard detail")),
        ],
      ),
    );
  }
}
