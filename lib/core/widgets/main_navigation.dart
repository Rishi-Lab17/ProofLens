import 'package:flutter/material.dart';

import '../../app/router/route_names.dart';

class ProofLensMainNavigation extends StatelessWidget {
  const ProofLensMainNavigation({super.key, required this.currentIndex});

  final int currentIndex;

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) {
      return;
    }

    const routes = <String>[
      RouteNames.home,
      RouteNames.history,
      RouteNames.settings,
    ];

    Navigator.of(context)
        .pushNamedAndRemoveUntil(routes[index], (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 10),
            color: Colors.black.withValues(alpha: 0.12),
          ),
        ],
      ),
      child: NavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        height: 70,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          _navigate(context, index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
