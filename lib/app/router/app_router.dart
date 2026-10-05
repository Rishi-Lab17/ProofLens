import 'package:flutter/material.dart';

import '../../data/models/destination.dart';
import '../../data/models/evidence.dart';
import '../../data/models/location_data.dart';

import '../../features/camera/presentation/screens/camera_screen.dart';
import '../../features/evidence/presentation/screens/capture_preview_screen.dart';
import '../../features/evidence/presentation/screens/evidence_details_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/location/presentation/screens/where_am_i_screen.dart';
import '../../features/nearby/presentation/screens/nearby_places_screen.dart';
import '../../features/navigation/presentation/screens/simulated_navigation_screen.dart';
import '../../features/report/presentation/screens/report_preview_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/sharing/presentation/screens/share_export_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case RouteNames.splash:
        return _page(
          const SplashScreen(),
          settings,
        );

      case RouteNames.home:
        return _page(
          const HomeScreen(),
          settings,
        );

      case RouteNames.camera:
        return _page(
          const CameraScreen(),
          settings,
        );

      case RouteNames.capturePreview:
        return _page(
          const CapturePreviewScreen(),
          settings,
        );

      case RouteNames.evidenceDetails:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(
            EvidenceDetailsScreen(
              evidence: evidence,
            ),
            settings,
          );
        }

        return _page(
          const HomeScreen(),
          settings,
        );

      case RouteNames.location:
        return _page(
          const WhereAmIScreen(),
          settings,
        );

      case RouteNames.nearbyPlaces:
        final location = settings.arguments;

        if (location is LocationData) {
          return _page(
            NearbyPlacesScreen(
              location: location,
            ),
            settings,
          );
        }

        return _page(
          const WhereAmIScreen(),
          settings,
        );

      case RouteNames.search:
        return _page(
          const SearchScreen(),
          settings,
        );

      case RouteNames.navigation:
        final destination = settings.arguments;

        if (destination is Destination) {
          return _page(
            SimulatedNavigationScreen(
              destination: destination,
            ),
            settings,
          );
        }

        return _page(
          const SearchScreen(),
          settings,
        );

      case RouteNames.history:
        return _page(
          const HistoryScreen(),
          settings,
        );

      case RouteNames.report:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(
            ReportPreviewScreen(
              evidence: evidence,
            ),
            settings,
          );
        }

        return _page(
          const HomeScreen(),
          settings,
        );

      case RouteNames.shareExport:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(
            ShareExportScreen(
              evidence: evidence,
            ),
            settings,
          );
        }

        return _page(
          const HomeScreen(),
          settings,
        );

      case RouteNames.settings:
        return _page(
          const SettingsScreen(),
          settings,
        );

      default:
        return _page(
          const HomeScreen(),
          settings,
        );
    }
  }

  static PageRouteBuilder<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration:
          const Duration(milliseconds: 320),
      reverseTransitionDuration:
          const Duration(milliseconds: 240),
      pageBuilder: (
        context,
        animation,
        secondaryAnimation,
      ) {
        return child;
      },
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.025, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}