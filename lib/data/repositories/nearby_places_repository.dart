import 'dart:math' as math;

import '../mock/mock_nearby_places.dart';
import '../models/nearby_place.dart';

class NearbyPlacesRepository {
  const NearbyPlacesRepository();

  Future<List<NearbyPlace>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    String? category,
  }) async {
    // Simulates a real nearby-places request.
    await Future<void>.delayed(
      const Duration(milliseconds: 450),
    );

    var places = MockNearbyPlaces.places;

    if (category != null && category != 'All') {
      places = places
          .where(
            (place) => place.category == category,
          )
          .toList();
    }

    final sorted = List<NearbyPlace>.from(places);

    sorted.sort(
      (a, b) {
        final distanceA = _distanceInKm(
          latitude,
          longitude,
          a.latitude,
          a.longitude,
        );

        final distanceB = _distanceInKm(
          latitude,
          longitude,
          b.latitude,
          b.longitude,
        );

        return distanceA.compareTo(distanceB);
      },
    );

    return sorted;
  }

  double calculateDistance({
    required double fromLatitude,
    required double fromLongitude,
    required double toLatitude,
    required double toLongitude,
  }) {
    return _distanceInKm(
      fromLatitude,
      fromLongitude,
      toLatitude,
      toLongitude,
    );
  }

  String formatDistance(double kilometers) {
    if (kilometers < 1) {
      return '${(kilometers * 1000).round()} m';
    }

    return '${kilometers.toStringAsFixed(1)} km';
  }

  int estimateMinutes(double kilometers) {
    // Prototype estimate.
    // Real routing/ETA will be supplied by a maps provider later.
    final minutes = (kilometers * 3.5).round();

    return math.max(1, minutes);
  }

  double _distanceInKm(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) {
    const earthRadiusKm = 6371.0;

    final dLat = _degreesToRadians(
      latitude2 - latitude1,
    );

    final dLon = _degreesToRadians(
      longitude2 - longitude1,
    );

    final lat1 = _degreesToRadians(latitude1);
    final lat2 = _degreesToRadians(latitude2);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(
      math.sqrt(a),
      math.sqrt(1 - a),
    );

    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}