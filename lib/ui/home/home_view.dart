import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/vineyard/vineyard_view.dart';
import 'package:wine_app/ui/wine/wine_evidence_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const WineEvidenceListView(),
    const VineyardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  void _onItemTap(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  Widget _buildUI() {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onItemTap,
        items: const [
          BottomNavigationBarItem(
            label: AppStrings.wineEvidence,
            icon: Icon(Icons.format_list_bulleted_outlined),
          ),
          BottomNavigationBarItem(
            label: AppStrings.vineyards,
            icon: Icon(Icons.local_florist),
          ),
        ],
      ),
    );
  }
}
