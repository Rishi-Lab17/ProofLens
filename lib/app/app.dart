import 'package:flutter/material.dart';

import '../core/widgets/prooflens_background.dart';
import 'router/app_router.dart';
import 'router/route_names.dart';
import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

final ThemeController themeController = ThemeController();

class ProofLensApp extends StatefulWidget {
  const ProofLensApp({super.key});

  @override
  State<ProofLensApp> createState() => _ProofLensAppState();
}

class _ProofLensAppState extends State<ProofLensApp> {
  @override
  void initState() {
    super.initState();
    themeController.addListener(_themeChanged);
  }

  void _themeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    themeController.removeListener(_themeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS LENS: MAP CAMERA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      initialRoute: RouteNames.splash,
      onGenerateRoute: AppRouter.generateRoute,
      builder: (context, child) {
        return ProofLensBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
