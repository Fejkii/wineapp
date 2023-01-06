import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wine_app/const/app_strings.dart';
import 'package:wine_app/ui/vineyard/vineyard_view.dart';
import 'package:wine_app/ui/widgets/app_sidebar.dart';
import 'package:wine_app/ui/wine/wine_view.dart';

enum HomeViewIndexes {
  wine,
  vineyard,
  project,
  settings,
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = [
    const WineView(),
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
      drawer: AppSidebar(),
      appBar: AppBar(),
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _onItemTap,
        items: const [
          BottomNavigationBarItem(
            label: AppStrings.wines,
            icon: Icon(CupertinoIcons.wind),
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
