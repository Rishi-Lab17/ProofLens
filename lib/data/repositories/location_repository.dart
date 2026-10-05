import 'package:geolocator/geolocator.dart';

import '../models/location_data.dart';
import '../mock/mock_location_data.dart';
import '../../core/services/permissions_service.dart';

class LocationRepository {
  LocationRepository({
    PermissionsService? permissionsService,
  }) : _permissionsService =
            permissionsService ?? const PermissionsService();

  final PermissionsService _permissionsService;

  Future<LocationData> getCurrentLocation({
    bool useMockFallback = true,
  }) async {
    try {
      final serviceEnabled =
          await _permissionsService.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw const LocationServiceDisabledException();
      }

      final permission =
          await _permissionsService.requestLocationPermission();

      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationPermissionPermanentlyDeniedException();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: 'Current location',
        accuracy: position.accuracy,
        altitude: position.altitude,
        heading: position.heading >= 0 ? position.heading : 0,
        city: 'Unknown',
        country: 'Unknown',
      );
    } catch (_) {
      if (useMockFallback) {
        return MockLocationData.current;
      }

      rethrow;
    }
  }

  Stream<LocationData> watchLocation() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    return Geolocator.getPositionStream(
      locationSettings: settings,
    ).map(
      (position) {
        return LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          address: 'Current location',
          accuracy: position.accuracy,
          altitude: position.altitude,
          heading: position.heading >= 0 ? position.heading : 0,
          city: 'Unknown',
          country: 'Unknown',
        );
      },
    );
  }
}

class LocationServiceDisabledException implements Exception {
  const LocationServiceDisabledException();

  @override
  String toString() => 'Location services are disabled.';
}

class LocationPermissionDeniedException implements Exception {
  const LocationPermissionDeniedException();

  @override
  String toString() => 'Location permission was denied.';
}

class LocationPermissionPermanentlyDeniedException implements Exception {
  const LocationPermissionPermanentlyDeniedException();

  @override
  String toString() => 'Location permission was permanently denied.';
}
