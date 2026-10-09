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
import '../../features/settings/presentation/screens/image_overlay_settings_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/video_overlay_settings_screen.dart';
import '../../features/sharing/presentation/screens/share_export_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --------------------------------------------------
      // SPLASH SCREEN
      // --------------------------------------------------
      case RouteNames.splash:
        return _page(const SplashScreen(), settings);

      // --------------------------------------------------
      // HOME SCREEN
      // --------------------------------------------------
      case RouteNames.home:
        return _page(const HomeScreen(), settings);

      // --------------------------------------------------
      // CAMERA SCREEN
      // --------------------------------------------------
      case RouteNames.camera:
        return _page(const CameraScreen(), settings);

      // --------------------------------------------------
      // CAPTURE PREVIEW
      // Receives the captured image path and available GPS
      // metadata from CameraScreen.
      // --------------------------------------------------
      case RouteNames.capturePreview:
        final arguments = settings.arguments;

        if (arguments is Map<String, dynamic>) {
          return _page(
            CapturePreviewScreen(
              imagePath: arguments['imagePath'] as String?,
              address: arguments['address'] as String?,
              latitude: arguments['latitude'] as double?,
              longitude: arguments['longitude'] as double?,
              accuracy: arguments['accuracy'] as double?,
              altitude: arguments['altitude'] as double?,
              direction: arguments['direction'] as double?,
              capturedAt: arguments['capturedAt'] as DateTime?,
            ),
            settings,
          );
        }

        return _page(const CapturePreviewScreen(), settings);

      // --------------------------------------------------
      // EVIDENCE DETAILS
      // --------------------------------------------------
      case RouteNames.evidenceDetails:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(EvidenceDetailsScreen(evidence: evidence), settings);
        }

        return _page(const HomeScreen(), settings);

      // --------------------------------------------------
      // LOCATION / WHERE AM I
      // --------------------------------------------------
      case RouteNames.location:
        return _page(const WhereAmIScreen(), settings);

      // --------------------------------------------------
      // NEARBY PLACES
      // --------------------------------------------------
      case RouteNames.nearbyPlaces:
        final location = settings.arguments;

        if (location is LocationData) {
          return _page(NearbyPlacesScreen(location: location), settings);
        }

        return _page(const WhereAmIScreen(), settings);

      // --------------------------------------------------
      // DESTINATION SEARCH
      // --------------------------------------------------
      case RouteNames.search:
        return _page(const SearchScreen(), settings);

      // --------------------------------------------------
      // NAVIGATION
      // --------------------------------------------------
      case RouteNames.navigation:
        final destination = settings.arguments;

        if (destination is Destination) {
          return _page(
            SimulatedNavigationScreen(destination: destination),
            settings,
          );
        }

        return _page(const SearchScreen(), settings);

      // --------------------------------------------------
      // EVIDENCE HISTORY
      // --------------------------------------------------
      case RouteNames.history:
        return _page(const HistoryScreen(), settings);

      // --------------------------------------------------
      // REPORT PREVIEW
      // --------------------------------------------------
      case RouteNames.report:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(ReportPreviewScreen(evidence: evidence), settings);
        }

        return _page(const HomeScreen(), settings);

      // --------------------------------------------------
      // SHARE AND EXPORT
      // --------------------------------------------------
      case RouteNames.shareExport:
        final evidence = settings.arguments;

        if (evidence is Evidence) {
          return _page(ShareExportScreen(evidence: evidence), settings);
        }

        return _page(const HomeScreen(), settings);

      // --------------------------------------------------
      // SETTINGS
      // --------------------------------------------------
      case RouteNames.settings:
        return _page(const SettingsScreen(), settings);

      // --------------------------------------------------
      // IMAGE OVERLAY SETTINGS
      // --------------------------------------------------
      case RouteNames.imageOverlaySettings:
        return _page(const ImageOverlaySettingsScreen(), settings);

      // --------------------------------------------------
      // VIDEO OVERLAY SETTINGS
      // --------------------------------------------------
      case RouteNames.videoOverlaySettings:
        return _page(const VideoOverlaySettingsScreen(), settings);

      // --------------------------------------------------
      // UNKNOWN ROUTE
      // --------------------------------------------------
      default:
        return _page(const HomeScreen(), settings);
    }
  }

  // --------------------------------------------------
  // SHARED PAGE TRANSITION
  // --------------------------------------------------
  static PageRouteBuilder<dynamic> _page(Widget child, RouteSettings settings) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
