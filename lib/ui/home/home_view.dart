import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wine_app/app/app_preferences.dart';
import 'package:wine_app/app/dependency_injection.dart';
import 'package:wine_app/bloc/project_settings/project_settings_cubit.dart';
import 'package:wine_app/bloc/vineyard/vineyard_cubit.dart';
import 'package:wine_app/bloc/wine/wine_cubit.dart';
import 'package:wine_app/ui/vineyard/vineyard_list_view.dart';
import 'package:wine_app/ui/wine/wine_evidence_list_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AppPreferences appPreferences = instance<AppPreferences>();
  late WineCubit wineCubit = instance<WineCubit>();
  late ProjectSettingsCubit projectSettingsCubit = instance<ProjectSettingsCubit>();
  late VineyardCubit vineyardCubit = instance<VineyardCubit>();
  int _currentPageIndex = 0;

  @override
  void initState() {
    if (appPreferences.hasUserProject()) {
      int projectId = appPreferences.getProject()!.id;
      projectSettingsCubit.getProjectSettings(projectId);
      wineCubit.getWineVarietyList(projectId);
      wineCubit.getWineClassificationList();
      wineCubit.getWineList();
    }
    super.initState();
  }

  final List<Widget> _pages = [
    const WineEvidenceListView(),
    const VineyardListView(),
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
        items: [
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.wineEvidence,
            icon: const Icon(Icons.wine_bar),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.vineyards,
            icon: const Icon(Icons.local_florist),
          ),
        ],
      ),
    );
  }
}
